local Clients = require('lua.widgets.clients')
local Screens = require('lua.widgets.screens')

---@param args { application: Gtk.Application }
---@return Adw.ApplicationWindow
return function(args)
    local App = args.application

    ---@type Adw.ApplicationWindow
    return Widget.ApplicationWindow {
        title = 'Screen Share',
        application = App,
        default_height = 500,
        default_width = 800,
        visible = false,
        resizable = false,
        on_unrealize = function() App:quit() end,
        on_key_pressed = function(_, keyval)
            local ESC = keyval == Gdk.KEY_Escape

            if ESC then App:quit() end
        end,
        Widget.ToolbarView {
            Widget.HeaderBar {
                show_end_title_buttons = false,
                Widget.Button {
                    label = 'Cancel',
                    on_clicked = function() App:quit() end,
                },
                Widget.Button {
                    css_classes = { 'suggested-action' },
                    label = 'Share',
                    sensitive = bind(ScreenShareSelection):as(
                        function(value) return not not value end
                    ),
                    on_clicked = function()
                        io.stdout:write(('[SELECTION]/%s\n'):format(ScreenShareSelection:get()))
                        -- print('[SELECTION]/window:94282765966800')
                        -- print('[SELECTION]/screen:eDP-1')

                        App:quit()
                    end,
                },
            },
            Widget.PreferencesPage {
                Screens(),
                Clients(),
            },
        },
    }
end
