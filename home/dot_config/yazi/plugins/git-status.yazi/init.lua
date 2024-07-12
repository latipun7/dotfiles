local function string_split(input, delimiter)
  local result = {}

  for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

local function make_git_table(git_is_dirty)
  local file_table = {}
  local split_table = string_split(git_is_dirty:sub(1, -2), "\n")
  for _, value in ipairs(split_table) do
    split_value = string_split(value, " ")
    if split_value[#split_value - 1] == "" then split_value = string_split(value, "  ") end

    file_table[split_value[#split_value]] = split_value[#split_value - 1] == "??" and "U"
      or split_value[#split_value - 1]
  end
  return file_table
end

local save = ya.sync(function(st, cwd, git_branch, git_is_dirty, folder_size, git_file_status)
  if cx.active.current.cwd == Url(cwd) then
    st.git_branch = git_branch
    st.git_is_dirty = git_is_dirty
    st.folder_size = folder_size
    st.git_file_status = git_file_status
    ya.render()
  end
end)

local enable_file_size = ya.sync(function(st) return st.opt_enable_folder_size end)

local set_opts_default = ya.sync(function(state)
  if state.opt_folder_size_ignore == nil then state.opt_folder_size_ignore = {} end
  if state.opt_gitstatus_ignore == nil then state.opt_gitstatus_ignore = {} end
  if state.opt_enable_folder_size == nil then state.opt_enable_folder_size = false end
end)

return {
  setup = function(st, opts)
    set_opts_default()

    if opts ~= nil and opts.folder_size_ignore ~= nil then st.opt_folder_size_ignore = opts.folder_size_ignore end
    if opts ~= nil and opts.gitstatus_ignore ~= nil then st.opt_gitstatus_ignore = opts.gitstatus_ignore end
    if opts ~= nil and opts.enable_folder_size ~= nil then st.opt_enable_folder_size = opts.enable_folder_size end

    function Entity:symlink(file)
      local git_span = {}

      if st.git_is_dirty ~= nil and st.git_is_dirty ~= "" then
        local name = file.name:gsub("\r", "?", 1)
        if file:is_hovered() then
          git_span = st.git_file_status[name] and { ui.Span(" ["), ui.Span(st.git_file_status[name]), ui.Span("]") }
        else
          git_span = st.git_file_status[name]
            and {
              ui.Span(" ["):fg("#98ca65"),
              ui.Span(st.git_file_status[name]):fg("#98ca65"),
              ui.Span("]"):fg("#98ca65"),
            }
        end
      end

      if not MANAGER.show_symlink and (st.git_is_dirty == nil or st.git_is_dirty == "") then
        return {}
      elseif not MANAGER.show_symlink and st.git_is_dirty ~= nil and st.git_is_dirty ~= "" then
        return git_span
      elseif MANAGER.show_symlink and st.git_is_dirty ~= nil and st.git_is_dirty ~= "" then
        local to = file.link_to
        return to and { git_span, ui.Span(" -> " .. tostring(to)):italic() } or { git_span }
      else
        local to = file.link_to
        return to and { ui.Span(" -> " .. tostring(to)):italic() } or {}
      end
    end

    function Header:cwd(max)
      local git_span = {}
      local cwd = cx.active.current.cwd
      local ignore_caculate_size = false
      local ignore_gitstatus = false

      for _, value in ipairs(st.opt_folder_size_ignore) do
        if value == tostring(cwd) then ignore_caculate_size = true end
      end

      for _, value in ipairs(st.opt_gitstatus_ignore) do
        if value == tostring(cwd) then ignore_gitstatus = true end
      end

      local folder_size_span = (st.folder_size ~= nil and st.folder_size ~= "")
          and ui.Span(" [" .. st.folder_size .. "]")
        or {}
      if st.cwd ~= cwd then
        st.cwd = cwd
        ya.manager_emit("plugin", {
          st._name,
          args = ya.quote(tostring(cwd)) .. " " .. tostring(ignore_caculate_size) .. " " .. tostring(ignore_gitstatus),
        })
      else
        local git_is_dirty = (st.git_is_dirty ~= nil and st.git_is_dirty ~= "") and "*" or ""
        git_span = (st.git_branch and st.git_branch ~= "")
            and ui.Span(" <" .. st.git_branch .. git_is_dirty .. ">"):fg("#c6ca4a")
          or {}
      end

      local s = ya.readable_path(tostring(cx.active.current.cwd)) .. self:flags()

      return ui.Line({
        ui.Span(ya.truncate(s, { max = max, rtl = true })):style(THEME.manager.cwd),
        git_span,
        folder_size_span,
      })
    end
  end,

  entry = function(_, args)
    local output

    local git_branch = ""
    if args[3] ~= "true" then
      local command = "git symbolic-ref HEAD 2> /dev/null"
      local file = io.popen(command, "r")
      output = file:read("*a")
      file:close()
    else
      output = nil
    end
    if output ~= nil and output ~= "" then
      local split_output = string_split(output:sub(1, -2), "/")

      git_branch = split_output[3]
    end

    local git_is_dirty = ""
    local git_file_status = nil
    if args[3] ~= "true" then
      local command = "git status -s --ignore-submodules=dirty 2> /dev/null"
      local file = io.popen(command, "r")
      output = file:read("*a")
      file:close()
    else
      output = nil
    end
    if output ~= nil and output ~= "" then
      git_is_dirty = output
      git_file_status = make_git_table(git_is_dirty)
    end

    local folder_size = ""
    if args[2] ~= "true" and enable_file_size() then
      output = Command("du"):args({ "-sh", args[1] .. "/" }):output()
    else
      output = nil
    end
    if output then
      local split_output = string_split(output.stdout, "\t")
      folder_size = split_output[1]
    end

    save(args[1], git_branch, git_is_dirty, folder_size, git_file_status)
  end,
}
