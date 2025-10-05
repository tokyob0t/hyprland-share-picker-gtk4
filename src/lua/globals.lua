astal = require('astal')
App = require('astal.gtk4.app')
Widget = require('astal.gtk4.widget')

Variable, bind = astal.Variable, astal.bind
async, await = astal.async, astal.await

GLib = astal.require('GLib')
Gtk = astal.require('Gtk')
Gio = astal.require('Gio')
Adw = astal.require('Adw')
GObject = astal.require('GObject')

local astalify = Widget.astalify

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

Widget.HeaderBar = astalify(Adw.HeaderBar)
