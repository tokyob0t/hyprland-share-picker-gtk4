local Hyprland = astal.require('AstalHyprland')
local Gtk = astal.require('Gtk')
local Gdk = astal.require('Gdk')

local Theme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default())

local function lookup_icon(...)
    for _, name in ipairs { ... } do
        for _, value in ipairs {
            name,
            name:lower(),
            name:upper(),
        } do
            local icon_info = Theme:lookup_icon(value, nil, 16, 1, 'NONE', 'NONE')

            if icon_info.icon_name ~= 'image-missing' then return value end
        end
    end
end

local function XDPH_WINDOW_SHARING_LIST(address)
    local list = os.getenv('XDPH_WINDOW_SHARING_LIST')
    if not list then return nil end

    for window in string.gmatch(list, '(.-)%[HA>%]') do
        local id, class, title, handle =
            string.match(window, '^(%d+)%[HC>%](.-)%[HT>%](.-)%[HE>%](%d+)$')

        if tonumber(handle) == tonumber(address, 16) then return id end
    end
end

---@param args { client: AstalHyprland.Client }
local function ClientRow(args)
    local c = args.client
    local id = XDPH_WINDOW_SHARING_LIST(c.address)

    if not id then return end

    local selection_id = string.format('window:%d', id)

    return Widget.ActionRow {
        title = bind(c, 'initial-class'),
        subtitle = bind(c, 'title'),
        subtitle_lines = 1,
        activatable = true,
        on_activated = function() ScreenShareSelection:set(selection_id) end,
        prefix = Widget.Image {
            icon_name = lookup_icon(c.initial_class, 'application-x-executable'),
            pixel_size = 32,
        },
        suffix = Widget.Image {
            icon_name = 'emblem-ok-symbolic',
            pixel_size = 12,
            visible = bind(ScreenShareSelection):as(
                function(value) return value == selection_id end
            ),
        },
    }
end

return function()
    local hypr = Hyprland.get_default()
    ---@type table<string, Gtk.ListBoxRow | Astalified4>
    local clients = {}

    return Widget.PreferencesGroup {
        setup = function(self)
            local added = function(c)
                local widget = ClientRow { client = c }

                if widget then
                    clients[c.address] = widget
                    self:add(widget)
                end
            end

            local removed = function(addr)
                local w = clients[addr]
                if w then
                    self:remove(w)
                    w:run_dispose()
                end
            end

            for _, c in ipairs(hypr.clients) do
                added(c)
            end

            self:hook(hypr, 'client-added', function(_, c) added(c) end)
            self:hook(hypr, 'client-removed', function(_, address) removed(address) end)
        end,
    }
end
