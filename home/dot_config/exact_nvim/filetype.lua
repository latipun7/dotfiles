local CHEZMOI_PREFIXES = {
  "^exact_",
  "^private_",
  "^public_",
  "^readonly_",
  "^executable_",
  "^symlink_",
  "^encrypted_",
  "^empty_",
  "^create_",
  "^modify_",
  "^run_once_after_",
  "^run_once_before_",
  "^run_once_",
  "^run_onchange_after_",
  "^run_onchange_before_",
  "^run_onchange_",
  "^run_after_",
  "^run_before_",
  "^run_",
  "^once_",
  "^onchange_",
  "^before_",
  "^after_",
  "^literal_",
}

local function match_neutral_filetype(clean_path, bufnr)
  -- Ensure path has a leading slash so Neovim's `.*/...` patterns match correctly
  local path_with_slash = clean_path:find("/") and clean_path or ("/" .. clean_path)

  -- Strip chezmoi folder/file prefixes from path so it won't re-trigger chezmoi filetype handlers
  local neutral_path = path_with_slash:gsub("/%.?chezmoi[%w_]*", "/file")

  return vim.filetype.match({ filename = neutral_path, buf = bufnr })
end

local function parse_hashbang_line(line)
  if not line or not line:find("#!", 1, true) then return nil end

  local clean_line = line:gsub("{{%s*lookPath%s+[\"'](.-)[\"']%s*}}", "/usr/bin/env %1")
  clean_line = clean_line:gsub("{{.-}}", ""):match("^%s*(.-)%s*$")

  local nvim_ft = vim.filetype.match({
    filename = "dummy_script",
    contents = { clean_line },
  })

  if nvim_ft and nvim_ft ~= "" then return nvim_ft end

  local exec_part = clean_line:match("^#!%s*(.-)$")
  if not exec_part then return nil end

  local tokens = {}
  for token in exec_part:gmatch("%S+") do
    table.insert(tokens, token)
  end
  if #tokens == 0 then return nil end

  local binary = tokens[1]:match("([^/]+)$") or tokens[1]
  if binary == "env" and tokens[2] then binary = tokens[2]:match("([^/]+)$") or tokens[2] end

  return binary
end

local function detect_templated_interpreter(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return nil end
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, 20, false)
  if not ok or not lines then return nil end

  local shell_flag_found = false
  for _, line in ipairs(lines) do
    if line:find("#!", 1, true) then
      local ft = parse_hashbang_line(line)
      if ft then return ft end
    elseif not shell_flag_found and (line:find("set -", 1, true) or line:find("pipefail", 1, true)) then
      shell_flag_found = true
    end
  end
  return shell_flag_found and "sh" or nil
end

local function unwrap_chezmoi_filename(filename)
  local is_tmpl = false
  if filename:sub(-5) == ".tmpl" then
    is_tmpl = true
    filename = filename:sub(1, -6)
  elseif filename:sub(-8) == ".literal" then
    filename = filename:sub(1, -9)
  end

  local changed = true
  while changed do
    changed = false
    for _, prefix in ipairs(CHEZMOI_PREFIXES) do
      local new_name, count = filename:gsub(prefix, "")
      if count > 0 then
        filename = new_name
        changed = true
      end
    end
  end

  if filename:sub(1, 4) == "dot_" then filename = "." .. filename:sub(5) end

  return filename, is_tmpl
end

local function format_chezmoi_ft(base_ft, is_template)
  if not is_template then return base_ft end
  if not base_ft or base_ft == "" then return "chezmoitmpl" end
  if base_ft:sub(1, 12) == "chezmoitmpl." or base_ft == "chezmoitmpl" then return base_ft end
  return "chezmoitmpl." .. base_ft
end

local function resolve_chezmoi_ft(path, bufnr)
  local filename = path:match("([^/]+)$")
  if not filename then return end

  local dir = path:match("^(.*/)") or ""

  local is_in_template_dir = path:find(".chezmoitemplates/", 1, true) ~= nil
    or path:find(".chezmoiscripts/", 1, true) ~= nil
    or path:find(".chezmoiexternals/", 1, true) ~= nil

  local is_external_file = filename:find("^%.chezmoiexternal") ~= nil
  local clean_filename, is_tmpl = unwrap_chezmoi_filename(filename)
  local is_template = is_tmpl or is_in_template_dir or is_external_file
  local clean_path = dir .. clean_filename

  if not is_template then
    if clean_filename ~= filename then return match_neutral_filetype(clean_path, bufnr) end
    return nil
  end

  local base_ft = detect_templated_interpreter(bufnr) or match_neutral_filetype(clean_path, bufnr)

  if not base_ft and path:find(".chezmoiscripts/", 1, true) then base_ft = "sh" end

  return format_chezmoi_ft(base_ft, true)
end

-- Register chezmoitmpl filetype suffix to use the gotmpl tree-sitter parser
vim.treesitter.language.register("gotmpl", "chezmoitmpl")

-- Register custom directive to dynamically set the injection language from compound filetypes (e.g. chezmoitmpl.zsh -> zsh)
vim.treesitter.query.add_directive("set-chezmoi-injection-language!", function(_, _, bufnr, _, metadata)
  local ft = vim.bo[bufnr].filetype
  local base_ft = ft:match("^chezmoitmpl%.(.*)$") or ft:match("^gotmpl%.(.*)$")

  if base_ft and base_ft ~= "" then
    -- Map filetype alias to Tree-sitter language (e.g., 'sh' -> 'bash')
    local lang = vim.treesitter.language.get_lang(base_ft) or base_ft
    metadata["injection.language"] = lang
  end
end, { force = true })

vim.filetype.add({
  filename = {
    ["dunstrc"] = "confini",
    [".chezmoiignore"] = "chezmoitmpl.gitignore",
    [".chezmoiremove"] = "chezmoitmpl.gitignore",
    [".chezmoiroot"] = "text",
    [".chezmoiversion"] = "text",
  },
  pattern = {
    [".*ignore"] = "gitignore",
    [".*%.conf"] = {
      function(_, bufnr)
        -- Guard: If there is no valid buffer (e.g. called from Snacks/Telescope pickers)
        if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return "conf" end

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
        local first_line = lines[1] or ""

        if first_line:find("<%?xml") then
          return "xml"
        else
          return "conf"
        end
      end,
      { priority = -math.huge },
    },
    [".*%.tmpl"] = { resolve_chezmoi_ft, { priority = math.huge } },
    [".*/%.chezmoi.*"] = { resolve_chezmoi_ft, { priority = math.huge } },
    [".*/%.local/share/chezmoi/.*"] = { resolve_chezmoi_ft, { priority = math.huge } },
  },
  extensions = {
    tfstate = "json",
    mdx = "markdown",
  },
})
