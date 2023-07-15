local pipe = io.popen('uname -m')
local output = pipe:read('*all')
pipe:close()
output = output:gsub('\n', '')
local brew_prefix = '/usr/local'
if output == 'arm64' then
    brew_prefix = '/opt/homebrew'
elseif output ~= 'x86_64' then
    hs.alert.show('Unknown architecture: ' .. output)
end

function launch_terminal2()
  if hs.appfinder.appFromName('WezTerm') then
    hs.execute('/Applications/WezTerm.app/Contents/MacOS/wezterm start')
  else
    --hs.execute('/Applications/WezTerm.app/Contents/MacOS/wezterm start')
    hs.execute('open -a WezTerm')
  end
end

function launch_terminal()
  if hs.appfinder.appFromName('Alacritty') then
    hs.execute(brew_prefix .. '/bin/alacritty msg create-window -e ' .. brew_prefix .. '/bin/tmux')
  else
    hs.execute('open -a Alacritty --args -e ' .. brew_prefix .. '/bin/tmux')
  end
end

hs.hotkey.bind({'ctrl'}, 'return', launch_terminal)

hs.hotkey.bind({'control'}, 's', function ()
  hs.execute('/Applications/flameshot.app/Contents/MacOS/flameshot gui')
end)

--hs.loadSpoon("Emojis")
--spoon.Emojis:bindHotkeys({toggle = {{'ctrl'}, 'e'}})
