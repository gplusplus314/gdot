function launch_terminal()
  if hs.appfinder.appFromName('Alacritty') then
    hs.execute('/usr/local/bin/alacritty msg create-window -e /usr/local/bin/tmux')
  else
    hs.execute('open -a Alacritty --args -e /usr/local/bin/tmux')
  end
end

hs.hotkey.bind({'ctrl'}, 'return', launch_terminal)

hs.loadSpoon("Emojis")
spoon.Emojis:bindHotkeys({toggle = {{'ctrl'}, 'e'}})
