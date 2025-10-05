#!@lua@

require('lua.globals')

package.domain, package.resource = '@domain@', '@resource@'

local AppWindow = require('lua.widgets.appwindow')

---@class Application: Adw.Application
---@field main_window Adw.ApplicationWindow
---@field run fun(self: Application, ...: string[]): number
local Application = Adw.Application:derive('MyApplication')

Application._property.main_window =
    GObject.param_spec_object('main-window', nil, nil, Adw.ApplicationWindow, { 'READWRITE' })

function Application:_init()
    self.application_id = package.domain
    self.flags = { 'FLAGS_NONE' }
end

---@type Application
local App = Application()

function App:on_startup()
    self.main_window = AppWindow {
        application = self,
    }
end

function App:on_activate() self.main_window:present() end

local exit_code = App:run { arg[0], ... }

os.exit(exit_code)
