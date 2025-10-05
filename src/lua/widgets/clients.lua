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

---@class Client
---@field id string
---@field class string
---@field title string

---@return Client[]
local function XDPH_WINDOW_SHARING_LIST()
    local list = os.getenv('XDPH_WINDOW_SHARING_LIST')
    local tbl = {}

    if not list then return tbl end

    for window in string.gmatch(list, '(.-)%[HA>%]') do
        local id, class, title, handle =
            string.match(window, '^(%d+)%[HC>%](.-)%[HT>%](.-)%[HE>%](%d+)$')

        table.insert(tbl, {
            id = id,
            class = class,
            title = title,
        })
    end

    return tbl
end

---@param args Client
local function ClientRow(args)
    local selection_id = string.format('window:%d', args.id)

    return Widget.ActionRow {
        title = args.class,
        subtitle = args.title,
        subtitle_lines = 1,
        activatable = true,
        on_activated = function() ScreenShareSelection:set(args.id) end,
        prefix = Widget.Image {
            icon_name = lookup_icon(args.class, 'application-x-executable'),
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
    local clients = XDPH_WINDOW_SHARING_LIST()
    local clients_widgets = {}

    for _, value in ipairs(clients) do
        table.insert(clients_widgets, ClientRow(value))
    end

    return Widget.PreferencesGroup {
        clients_widgets,
    }
end
