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
    hs.execute('/usr/local/bin/alacritty msg create-window -e /usr/local/bin/tmux')
  else
    hs.execute('open -a Alacritty --args -e /usr/local/bin/tmux')
  end
end

hs.hotkey.bind({'ctrl'}, 'return', launch_terminal)

--hs.hotkey.bind({'control'}, 's', function ()
--  hs.execute('/Applications/flameshot.app/Contents/MacOS/flameshot gui')
--end)

--hs.loadSpoon("Emojis")
--spoon.Emojis:bindHotkeys({toggle = {{'ctrl'}, 'e'}})
