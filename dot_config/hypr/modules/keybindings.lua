local mainMod = "SUPER"
local terminal = "kitty"
local menu = "rofi -show drun"
local lock = "hyprlock"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap-workspaces.sh"))

for _, direction in ipairs({ "left", "down", "up", "right" }) do
    local key = ({ left = "H", down = "J", up = "K", right = "L" })[direction]
    local monitorDirection = ({ left = "l", down = "d", up = "u", right = "r" })[direction]
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.workspace.move({ monitor = monitorDirection }))
end

hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg orientationleft"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg orientationtop"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("hyprctl keyword general:layout dwindle"))
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprctl dispatch focuscurrentorlast"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg focusparent"))

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + M",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })