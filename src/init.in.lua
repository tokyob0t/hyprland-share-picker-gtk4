#!@lua@

require('lua.globals')

package.domain, package.resource = '@domain@', '@resource@'

local MainWindow = require('lua.widgets.window')
local main_window

---@type Adw.Application | { run: fun(self: Adw.Application, ...: string[]): number  }
local App = Adw.Application {
    application_id = package.domain,
    flags = { 'FLAGS_NONE' },
}

function App:on_startup()
    main_window = MainWindow {
        application = self,
    }
end

function App:on_activate() main_window:present() end

os.exit(App:run { arg[0], ... })
