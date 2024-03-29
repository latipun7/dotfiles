local M = {}
local actions_state = require("telescope.actions.state")
local telescope_utils = require("telescope.utils")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

local pickers = {
  git_files = {
    attach_mappings = function(_)
      actions.file_edit:enhance({
        post = function() vim.cmd("normal! zx") end,
      })
      return true
    end,
  },
  find_files = {
    attach_mappings = function(_)
      actions.file_edit:enhance({
        post = function() vim.cmd("normal! zx") end,
      })
      return true
    end,
    find_command = { "fd", "--type=file", "--hidden" },
    hidden = true,
  },
  buffers = {
    theme = "dropdown",
    previewer = false,
    initial_mode = "normal",
    mappings = {
      i = { ["<C-d>"] = actions.delete_buffer },
      n = { ["dd"] = actions.delete_buffer },
    },
  },
  lsp_references = { theme = "dropdown", initial_mode = "normal" },
  lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
  lsp_declarations = { theme = "dropdown", initial_mode = "normal" },
  lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
  live_grep = { only_sort_text = true },
  grep_string = { only_sort_text = true, theme = "dropdown" },
  planets = { show_pluto = true, show_moon = true },
}

-- beautiful default layout for telescope prompt
local layout_config = function()
  return {
    width = 0.90,
    height = 0.85,
    preview_cutoff = 120,
    horizontal = {
      preview_width = function(_, cols, _)
        if cols < 120 then return math.floor(cols * 0.5) end
        return math.floor(cols * 0.6)
      end,
    },
    vertical = {
      width = 0.9,
      height = 0.95,
      preview_height = 0.5,
    },
    flex = { horizontal = { preview_width = 0.9 } },
  }
end

local function _multiopen(prompt_bufnr, open_cmd)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  local border_contents = picker.prompt_border.contents[1]

  if not (string.find(border_contents, "Find Files") or string.find(border_contents, "Git Files")) then
    actions.select_default(prompt_bufnr)
    return
  end

  if num_selections > 1 then
    vim.cmd("bw!")
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", open_cmd, entry.value))
    end
    vim.cmd("stopinsert")
  else
    if open_cmd == "vsplit" then
      actions.file_vsplit(prompt_bufnr)
    elseif open_cmd == "split" then
      actions.file_split(prompt_bufnr)
    elseif open_cmd == "tabe" then
      actions.file_tab(prompt_bufnr)
    else
      actions.file_edit(prompt_bufnr)
    end
  end
end

local function multi_selection_open_vsplit(prompt_bufnr) _multiopen(prompt_bufnr, "vsplit") end

local function multi_selection_open_split(prompt_bufnr) _multiopen(prompt_bufnr, "split") end

local function multi_selection_open_tab(prompt_bufnr) _multiopen(prompt_bufnr, "tabe") end

local function multi_selection_open(prompt_bufnr) _multiopen(prompt_bufnr, "edit") end

function M.find_project_files(opts)
  opts = opts or {}

  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  local _, ret = telescope_utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)

  if ret ~= 0 then
    local in_worktree = telescope_utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = telescope_utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)

    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      builtin.find_files(opts)
      return
    end
  end

  builtin.git_files(opts)
end

-- another file string search
function M.find_string()
  local opts = {
    border = true,
    previewer = false,
    shorten_path = false,
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = { width = { padding = 0.15 } },
      vertical = { preview_height = 0.75 },
    },
  }
  builtin.live_grep(opts)
end

-- show refrences to this using language server
function M.lsp_references()
  local opts = {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
  builtin.lsp_references(opts)
end

-- show implementations of the current thingy using language server
function M.lsp_implementations()
  local opts = {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
  builtin.lsp_implementations(opts)
end

-- find files in the upper directory
function M.find_updir()
  local up_dir = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
  local opts = { cwd = up_dir }

  builtin.find_files(opts)
end

function M.installed_plugins()
  builtin.find_files({
    cwd = join_paths(vim.env.LUNARVIM_RUNTIME_DIR, "site", "pack", "lazy"),
  })
end

function M.project_search()
  builtin.find_files({
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p")),
  })
end

function M.curbuf()
  local opts = themes.get_dropdown({
    winblend = 10,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    layout_config = {
      width = 0.45,
      prompt_position = "top",
    },
  })
  builtin.current_buffer_fuzzy_find(opts)
end

function M.git_status()
  local opts = themes.get_dropdown({
    winblend = 10,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    layout_config = {
      width = 0.45,
      prompt_position = "top",
    },
  })

  -- Can change the git icons using this.
  -- opts.git_icons = {
  --   changed = "M"
  -- }

  builtin.git_status(opts)
end

function M.search_only_certain_files()
  builtin.find_files({
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input("Type: "),
    },
  })
end

function M.builtin() builtin.builtin() end

function M.git_files()
  local path = vim.fn.expand("%:h") or nil

  local width = 0.45
  if path and string.find(path, "sourcegraph.*sourcegraph", 1, false) then width = 0.6 end

  local opts = themes.get_dropdown({
    winblend = 5,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    cwd = path,
    layout_config = {
      width = width,
      prompt_position = "top",
    },
  })

  opts.file_ignore_patterns = {
    "^[.]vale/",
  }
  builtin.git_files(opts)
end

function M.grep_string_visual()
  local visual_selection = function()
    local save_previous = vim.fn.getreg("a")
    vim.api.nvim_command('silent! normal! "ay')
    local selection = vim.fn.trim(vim.fn.getreg("a"))
    vim.fn.setreg("a", save_previous)
    return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
  end
  builtin.live_grep({ default_text = visual_selection() })
end

M.config = function()
  lvim.builtin.telescope.theme = ""
  lvim.builtin.telescope.defaults.layout_config = layout_config()
  lvim.builtin.telescope.defaults.dynamic_preview_title = true
  lvim.builtin.telescope.defaults.mappings = {
    i = {
      ["<C-c>"] = actions.close,
      ["<C-y>"] = actions.which_key,
      ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
      ["<CR>"] = multi_selection_open,
      ["<C-v>"] = multi_selection_open_vsplit,
      ["<C-s>"] = multi_selection_open_split,
      ["<C-t>"] = multi_selection_open_tab,
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
    },
    n = {
      q = actions.close,
      ["<Esc>"] = actions.close,
      ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
      ["<CR>"] = multi_selection_open,
      ["<C-v>"] = multi_selection_open_vsplit,
      ["<C-s>"] = multi_selection_open_split,
      ["<C-t>"] = multi_selection_open_tab,
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-n>"] = actions.cycle_history_next,
      ["<C-p>"] = actions.cycle_history_prev,
      ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    },
  }
  lvim.builtin.telescope.defaults.file_ignore_patterns = {
    "__pycache__/",
    "__pycache__/",
    "vendor/",
    "build/",
    "env/",
    "modules/",
    "gradle/",
    "smalljre_./",
    "target/",
    "%.lock",
    "%.sqlite3",
    "%.ipynb",
    "%.jpg",
    "%.jpeg",
    "%.png",
    "%.svg",
    "%.otf",
    "%.ttf",
    "%.git/",
    "%.webp",
    "%.dart_tool/",
    "%.gradle/",
    "%.idea/",
    "%.settings/",
    "%.pdb",
    "%.dll",
    "%.class",
    "%.exe",
    "%.cache",
    "%.ico",
    "%.pdf",
    "%.dylib",
    "%.jar",
    "%.docx",
    "%.met",
    "%.vale/",
    "%.burp",
    "%.mp4",
    "%.mkv",
    "%.rar",
    "%.zip",
    "%.7z",
    "%.tar",
    "%.bz2",
    "%.epub",
    "%.flac",
    "%.tar.gz",
  }
  lvim.builtin.telescope.pickers = pickers
end

return M
