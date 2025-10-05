local Hyprland = astal.require('AstalHyprland')

local SCALE = 1 / 5

local group = nil

---@param args { monitor: AstalHyprland.Monitor }
local function MonitorWidget(args)
    local m = args.monitor

    local selection_id = string.format('screen:%s', m.name)

    return Widget.ToggleButton {
        halign = 'CENTER',
        valign = 'CENTER',
        width_request = bind(m, 'width'):as(function(w) return w * SCALE end),
        height_request = bind(m, 'height'):as(function(h) return h * SCALE end),
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
            label = m.name,
        },
    }
end

return function()
    local hypr = Hyprland.get_default()
    ---@type table<string, Gtk.ListBoxRow | Astalified4>
    local monitors = {}

    return Widget.PreferencesGroup {
        css_classes = { 'boxed-list-separate' },
        hexpand = true,
        Widget.Clamp {
            Widget.Box {
                halign = 'CENTER',
                hexpand = true,
                -- height_request = 300,
                spacing = 15,
                setup = function(self)
                    ---@param m AstalHyprland.Monitor
                    local added = function(m)
                        local widget = MonitorWidget { monitor = m }

                        monitors[m.id] = widget

                        self:append(widget)
                    end

                    local removed = function(id)
                        local w = monitors[id]
                        self:remove(w)
                        w:run_dispose()
                    end

                    for _, m in ipairs(hypr.monitors) do
                        added(m)
                    end

                    self:hook(hypr, 'monitor-added', function(_, m) added(m) end)
                    self:hook(hypr, 'monitor-removed', function(_, id) removed(id) end)
                end,
            },
        },
    }
end
