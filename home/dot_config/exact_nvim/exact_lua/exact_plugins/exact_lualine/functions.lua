local functions = {
  mode = function()
    local mode_code = vim.api.nvim_get_mode().mode
    local select_random = function(icons)
      local time = os.date("*t")
      local divider = math.ceil(24 / #icons)
      return icons[math.ceil(time.hour / divider)]
    end
    local normal_icons = {
      "󰊠 ",
      " ",
      " ",
    }
    local insert_icons = {
      "󰏒 ",
      " ",
      " ",
    }
    local visual_icons = {
      " ",
      " ",
      " ",
    }
    local command_icons = {
      "󰱫 ",
      " ",
      " ",
    }
    local replace_icons = {
      " ",
      " ",
      " ",
    }

    local mode_map = {
      ["n"] = select_random(normal_icons),
      ["no"] = "O-PENDING",
      ["nov"] = "O-PENDING",
      ["noV"] = "O-PENDING",
      ["no\22"] = "O-PENDING",
      ["niI"] = select_random(normal_icons),
      ["niR"] = select_random(normal_icons),
      ["niV"] = select_random(normal_icons),
      ["nt"] = select_random(normal_icons),
      ["ntT"] = select_random(normal_icons),
      ["v"] = select_random(visual_icons),
      ["vs"] = select_random(visual_icons),
      ["V"] = select_random(visual_icons),
      ["Vs"] = select_random(visual_icons),
      ["\22"] = select_random(visual_icons),
      ["\22s"] = select_random(visual_icons),
      ["s"] = "SELECT",
      ["S"] = "S-LINE",
      ["\19"] = "S-BLOCK",
      ["i"] = select_random(insert_icons),
      ["ic"] = select_random(insert_icons),
      ["ix"] = select_random(insert_icons),
      ["R"] = select_random(replace_icons),
      ["Rc"] = select_random(replace_icons),
      ["Rx"] = select_random(replace_icons),
      ["Rv"] = select_random(replace_icons),
      ["Rvc"] = select_random(replace_icons),
      ["Rvx"] = select_random(replace_icons),
      ["c"] = select_random(command_icons),
      ["cv"] = select_random(command_icons),
      ["ce"] = select_random(command_icons),
      ["r"] = select_random(replace_icons),
      ["rm"] = select_random(replace_icons),
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERMINAL",
    }

    if mode_map[mode_code] == nil then return mode_code .. " " .. select_random(normal_icons) end
    return mode_map[mode_code]
  end,

  win_icon = function()
    local fname = vim.fn.expand("%:p")
    ---@cast fname string
    if string.find(fname, "term://") ~= nil then return " " end
    local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
    if winnr > 10 then winnr = 10 end
    local number_icon = {
      "󰎥 ",
      "󰎨 ",
      "󰎫 ",
      "󰎲 ",
      "󰎯 ",
      "󰎴 ",
      "󰎷 ",
      "󰎺 ",
      "󰎽 ",
      "󰏀 ",
    }
    local win = number_icon[winnr]
    return win
  end,

  readonly = function()
    if vim.bo.readonly or not vim.bo.modifiable then return " " end
    return ""
  end,

  session = function()
    if vim.g.persisting then
      return "󰅠 "
    elseif vim.g.persisting == false then
      return "󰅣 "
    end
  end,

  treesitter = function() return " " end,

  auto_format = function()
    if not require("lazyvim.util").format.enabled() then
      return "󰉥 "
    else
      return "󰉼 "
    end
  end,

  lsp_status = function(msg)
    local buf_client_names = {}

    msg = msg or "󰅛 LS Inactive"
    local original_bufnr = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_clients({ bufnr = original_bufnr })
    if next(buf_clients) == nil then
      if type(msg) == "boolean" or #msg == 0 then msg = "󰅛 LS Inactive" end
      table.insert(buf_client_names, msg)
    else
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          local _added_client = client.name
          table.insert(buf_client_names, "󰛳 " .. _added_client)
        end
      end
    end

    -- add linter
    local supported_linters = {}
    local linter_list = require("lint")._resolve_linter_by_ft(vim.bo.filetype)
    for _, lnt in pairs(linter_list) do
      local _added_formatter = lnt
      table.insert(supported_linters, _added_formatter)
    end
    vim.list_extend(buf_client_names, supported_linters)

    -- add formatter
    local supported_formatters = {}
    local formatter_list = require("conform").list_formatters()
    for _, fmt in pairs(formatter_list) do
      local _added_formatter = fmt.name
      table.insert(supported_formatters, _added_formatter)
    end
    vim.list_extend(buf_client_names, supported_formatters)

    return table.concat(buf_client_names, ", ")
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
    local fname = vim.fn.expand("%:p")
    ---@cast fname string
    if string.len(fname) == 0 then return "" end
    return format_file_size(fname)
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
