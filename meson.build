# FIXME: rename
project('hyprland-share-picker-gtk4', version: '0.0.1')
domain = 'ggez.tokyob0t.hyprlandSharePicker'
resource = '/ggez/tokyob0t/hyprlandSharePicker'
ignore_requires = 'lgi'

name = meson.project_name()
version = meson.project_version()

root = meson.current_source_dir()
prefix = get_option('prefix')
libdir = prefix / get_option('libdir')
datadir = prefix / get_option('datadir')
bindir = prefix / get_option('bindir')
pkgdatadir = datadir / name

lua_dirs = run_command(
  'find',
  root / 'src',
  '-type', 'f',
  '-name', '*.lua',
  '-exec', 'dirname',
  '{}',
  ';',
).stdout().strip().split('\n')

project_paths = ''

foreach d : lua_dirs
  project_paths += d + '/?.lua;' + d + '/?/init.lua;'
endforeach

luajit = find_program('luajit')
luarocks = find_program('luarocks')

luarocks_path = run_command(luarocks, '--lua-version=5.1', 'path').stdout()

lua_path = ''

foreach line : luarocks_path.split('\n')
  if line.startswith('export LUA_PATH=')
    lua_path = line.split('=')[1].strip('\'')
  endif
endforeach

custom_target(
  input: configure_file(
    input: 'src/init.in.lua',
    output: 'init.in.lua',
    configuration: {
      'lua': luajit.full_path(),
      'resource': resource,
      'domain': domain,
    },
  ),
  command: [
    luajit,
    root / 'scripts/lua/bundle.lua',
    '@INPUT@',
    '-o', '@OUTPUT@',
    '-i', project_paths + ';' + lua_path,
    '-g', ignore_requires,
    '--minify',
    '--verbose',
    '--no-animals',
  ],
  output: name,
  install: true,
  install_dir: bindir,
  install_mode: 'rwxr-xr-x',
)
