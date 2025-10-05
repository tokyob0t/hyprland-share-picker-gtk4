local json = require('dkjson')
local async_exec = require('astal.process').async_exec

local SCALE = 1 / 5

local group = nil

---@class MonitorProps
---@field name string
---@field width string
---@field height string

---@param args MonitorProps
local function MonitorWidget(args)
    local selection_id = string.format('screen:%s', args.name)

    return Widget.ToggleButton {
        halign = 'CENTER',
        valign = 'CENTER',
        width_request = args.width * SCALE,
        height_request = args.height * SCALE,
        active = bind(ScreenShareSelection):as(function(value) return value == selection_id end),
        on_notify_active = function(_, active)
            if active and ScreenShareSelection:get() ~= selection_id then
                ScreenShareSelection:set(selection_id)
            end
        end,
        setup = function(self)
            if not group then
                group = self
            else
                self.group = group
                group = self
            end
        end,
        Widget.Label {
            label = args.name,
        },
    }
end

return function()
    return Widget.PreferencesGroup {
        css_classes = { 'boxed-list-separate' },
        hexpand = true,
        Widget.Clamp {
            Widget.Box {
                halign = 'CENTER',
                hexpand = true,
                spacing = 15,
                setup = async(function(self)
                    ---@type MonitorProps[]?
                    local monitors = json.decode(async_exec { 'hyprctl', 'monitors', '-j' })

                    if not monitors then return end

                    for _, mon in ipairs(monitors) do
                        self:append(MonitorWidget(mon))
                    end
                end),
            },
        },
    }
end
