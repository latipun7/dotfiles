require("full-border"):setup()
require("githead"):setup()

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

table.insert(Header._left, 1, { "host", id = 99, order = 100 })
table.insert(Status._right, 1, { "owner", id = 99, order = 100 })
