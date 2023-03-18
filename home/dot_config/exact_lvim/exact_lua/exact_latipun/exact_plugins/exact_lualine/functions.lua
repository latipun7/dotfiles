local kind = require("latipun.lsp_kind")

local functions = {
  mode = function()
    local mod = vim.fn.mode()
    local _time = os.date("*t")

    local selector = math.floor(_time.hour / 8) + 1
    local normal_icons = {
      "",
      "",
      "",
    }

    if mod == "n" or mod == "no" or mod == "nov" then
      return normal_icons[selector]
    elseif mod == "i" or mod == "ic" or mod == "ix" then
      local insert_icons = {
        "",
        "",
        "",
      }
      return insert_icons[selector]
    elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
      local visual_icons = {
        "",
        "",
        "",
      }
      return visual_icons[selector]
    elseif mod == "c" or mod == "ce" then
      local command_icons = {
        "",
        "",
        "",
      }
      return command_icons[selector]
    elseif mod == "r" or mod == "rm" or mod == "r?" or mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
      local replace_icons = {
        "",
        "",
        "",
      }
      return replace_icons[selector]
    end
    return normal_icons[selector]
  end,

  win_icon = function()
    local fname = vim.fn.expand("%:p")
    if string.find(fname, "term://") ~= nil then return kind.icons.term end
    local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
    if winnr > 10 then winnr = 10 end
    local win = kind.numbers[winnr]
    return win
  end,

  filename = function()
    local fname = vim.fn.expand("%:p")

    if
      string.find(fname, "term") ~= nil
      and string.find(fname, "lazygit;#toggleterm") ~= nil
      and (vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1)
    then
      local git_repo_cmd = io.popen('git remote get-url origin | tr -d "\n"') or ""
      local git_repo = git_repo_cmd:read("*a")
      git_repo_cmd:close()

      local git_branch_cmd = io.popen('git branch --show-current | tr -d "\n"') or ""
      local git_branch = git_branch_cmd:read("*a")
      git_branch_cmd:close()

      return git_repo .. "~" .. git_branch
    end

    local show_name = vim.fn.expand("%:t")

    local readonly = ""
    local modified = ""

    if vim.bo.readonly then readonly = " " end

    if vim.bo.modified then modified = " " end

    return show_name .. readonly .. modified
  end,

  python_env = function()
    local utils = require("lvim.core.lualine.utils")
    if vim.bo.filetype == "python" then
      local venv = vim.env.CONDA_DEFAULT_ENV or vim.env.VIRTUAL_ENV

      if venv then return string.format(" (%s)", utils.env_cleanup(venv)) end
    end
    return ""
  end,

  testing = function()
    if vim.g.testing_status == "running" then return "" end
    if vim.g.testing_status == "fail" then return "" end
    if vim.g.testing_status == "pass" then return "" end
    return nil
  end,

  session = function()
    if vim.g.persisting then
      return ""
    elseif vim.g.persisting == false then
      return ""
    end
  end,

  auto_format = function()
    local exists, autocmds = pcall(vim.api.nvim_get_autocmds, {
      group = "lsp_format_on_save",
      event = "BufWritePre",
    })
    if not exists or #autocmds == 0 then
      return ""
    else
      return ""
    end
  end,

  readonly = function()
    if vim.bo.readonly or not vim.bo.modifiable then return "" end
    return ""
  end,

  treesitter = function() return "" end,

  lsp_status = function(msg)
    msg = msg or kind.icons.ls_inactive .. " " .. "LS Inactive"
    local buf_clients = vim.lsp.buf_get_clients()
    if next(buf_clients) == nil then
      if type(msg) == "boolean" or #msg == 0 then return kind.icons.ls_inactive .. " " .. "LS Inactive" end
      return msg
    end
    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        local _added_client = client.name
        table.insert(buf_client_names, _added_client)
      end
    end

    -- add formatter
    local formatters = require("lvim.lsp.null-ls.formatters")
    local supported_formatters = {}
    for _, fmt in pairs(formatters.list_registered(buf_ft)) do
      local _added_formatter = fmt
      table.insert(supported_formatters, _added_formatter)
    end
    vim.list_extend(buf_client_names, supported_formatters)

    -- add linter
    local linters = require("lvim.lsp.null-ls.linters")
    local supported_linters = {}
    for _, lnt in pairs(linters.list_registered(buf_ft)) do
      local _added_linter = lnt
      table.insert(supported_linters, _added_linter)
    end
    vim.list_extend(buf_client_names, supported_linters)

    return kind.icons.ls_active .. " " .. table.concat(buf_client_names, ", ")
  end,

  filesize = function()
    local function format_file_size(file)
      local size = vim.fn.getfsize(file)
      if size <= 0 then return "" end
      local sufixes = { "b", "k", "m", "g" }
      local i = 1
      while size > 1024 do
        size = size / 1024
        i = i + 1
      end
      return string.format("%.1f%s", size, sufixes[i])
    end
    local file = vim.fn.expand("%:p")
    if string.len(file) == 0 then return "" end
    return format_file_size(file)
  end,

  scrollbar = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = {
      "__",
      "▁▁",
      "▂▂",
      "▃▃",
      "▄▄",
      "▅▅",
      "▆▆",
      "▇▇",
      "██",
    }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
}

return functions
