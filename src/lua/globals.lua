astal = require('astal')
App = require('astal.gtk4.app')
Widget = require('astal.gtk4.widget')

Variable, bind = astal.Variable, astal.bind
async, await = astal.async, astal.await

ScreenShareSelection = Variable.new()

GLib = astal.require('GLib')
Gdk = astal.require('Gdk')
Gtk = astal.require('Gtk')
Gio = astal.require('Gio')
Adw = astal.require('Adw')
GObject = astal.require('GObject')

local astalify = Widget.astalify

Widget.ToggleButton = astalify(Gtk.ToggleButton)

Widget.Clamp = astalify(Adw.Clamp)

Widget.ApplicationWindow = astalify(Adw.ApplicationWindow, {
    set_children = function(self, children) self.content = children[1] or Gtk.Box {} end,
    get_children = function(self) return { self.content } end,
})

Widget.ToolbarView = astalify(Adw.ToolbarView, {
    set_children = function(self, children)
        if Adw.HeaderBar:is_type_of(children[1]) then
            self:add_top_bar(table.remove(children, 1))
        end

        self.content = table.remove(children, 1)

        if Adw.HeaderBar:is_type_of(children[1]) then
            self:add_bottom_bar(table.remove(children, 1))
        end
    end,
    get_children = function(self) return { self.content } end,
})

Widget.HeaderBar = astalify(Adw.HeaderBar, {
    set_children = function(self, children)
        if Gtk.Widget:is_type_of(children[1]) then self:pack_start(table.remove(children, 1)) end
        if Gtk.Widget:is_type_of(children[1]) then self:pack_end(table.remove(children, 1)) end
    end,
    get_children = function() return {} end,
})

Widget.PreferencesPage = astalify(Adw.PreferencesPage, {
    set_children = function(self, children)
        for _, ch in ipairs(children) do
            self:add(ch)
        end
    end,
    get_children = function() return {} end,
})

Widget.PreferencesGroup = astalify(Adw.PreferencesGroup, {
    set_children = function(self, children)
        for _, ch in ipairs(children) do
            self:add(ch)
        end
    end,
    get_children = function() return {} end,
})

---@type Adw.ActionRow | { prefix: Gtk.Widget, suffix: Gtk.Widget, prefixes: Gtk.Widget[], suffixes: Gtk.Widget[] }
local ActionRow = Adw.ActionRow

---@diagnostic disable-next-line
ActionRow._attribute.prefix = {
    set = function(self, prefix) self:add_prefix(prefix) end,
}

ActionRow._attribute.prefixes = {
    set = function(self, prefixes)
        for _, value in ipairs(prefixes) do
            self:add_prefix(value)
        end
    end,
}

---@diagnostic disable-next-line
ActionRow._attribute.suffix = {
    set = function(self, suffix) self:add_suffix(suffix) end,
}

ActionRow._attribute.suffixes = {
    set = function(self, suffixes)
        for _, value in ipairs(suffixes) do
            self:add_suffix(value)
        end
    end,
}

Widget.ActionRow = astalify(ActionRow)
