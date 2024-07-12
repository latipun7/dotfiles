require("full-border"):setup()
require("git-status"):setup({
  folder_size_ignore = {},
  gitstatus_ignore = {},
  enable_folder_size = false,
})

function Header:host()
  if ya.target_family() ~= "unix" then return ui.Line({}) end
  return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("magenta")
end

function Status:owner()
  local h = cx.active.current.hovered
  if h == nil or ya.target_family() ~= "unix" then return ui.Line({}) end

  return ui.Line({
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
    ui.Span(":"),
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    ui.Span(" "),
  })
end

function Header:render(area)
  self.area = area

  local right = ui.Line({ self:count(), self:tabs() })
  local left = ui.Line({ self:host(), self:cwd(math.max(0, area.w - right:width())) })
  return {
    ui.Paragraph(area, { left }),
    ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
  }
end

function Status:render(area)
  self.area = area

  local left = ui.Line({ self:mode(), self:size(), self:name() })
  local right = ui.Line({ self:owner(), self:permissions(), self:percentage(), self:position() })
  return {
    ui.Paragraph(area, { left }),
    ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
    table.unpack(Progress:render(area, right:width())),
  }
end
