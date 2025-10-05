local settings = Gio.Settings {
    schema_id = package.domain,
}

local count = Variable.new(settings:get_uint('simple-uint'))

---@param args { application: Gtk.Application }
---@return Adw.ApplicationWindow
return function(args)
    local App = args.application

    ---@type Adw.ApplicationWindow
    return Widget.ApplicationWindow {
        title = 'Counter',
        resizable = false,
        visible = false,
        application = App,
        setup = function(self)
            self:hook(App, 'shutdown', function() settings:set_uint('simple-uint', count:get()) end)
        end,
        Widget.ToolbarView {
            Widget.HeaderBar { show_end_title_buttons = true },
            Widget.CenterBox {
                valign = 'CENTER',
                hexpand = true,
                vertical = true,
                on_scroll = function(_, _, dy)
                    if dy < 0 then count.value = count.value + 1 end
                    if dy > 0 and count.value > 0 then count.value = count.value - 1 end
                end,
                Widget.Button {
                    halign = 'CENTER',
                    css_classes = { 'circular', 'flat' },
                    icon_name = 'value-increase-symbolic',
                    on_clicked = function() count.value = count.value + 1 end,
                },
                Widget.Label {
                    css_classes = { 'title-1' },
                    selectable = true,
                    halign = 'CENTER',
                    label = bind(count):as(tostring),
                },
                Widget.Button {
                    halign = 'CENTER',
                    css_classes = { 'circular', 'flat' },
                    icon_name = 'value-decrease-symbolic',
                    sensitive = bind(count):as(function(value) return value > 0 end),
                    on_clicked = function() count.value = count.value - 1 end,
                },
            },
        },
    }
end
