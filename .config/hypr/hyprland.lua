-- matugen hook
local colors = require("subconfigurations.colors")

-- Check connected display outputs
local function is_output_connected(name)
local p = io.popen("cat /sys/class/drm/*-" .. name .. "/status 2>/dev/null")
if not p then return false end
    local status = p:read("*a"):gsub("%s+", "")
    p:close()
    return status == "connected"
    end

    local has_dp = is_output_connected("DP-1")
    local has_hdmi = is_output_connected("HDMI-A-1")

    -- Determine machine hostname
    local handle = io.popen("uname -n")
    local hostname = handle:read("*a"):gsub("%s+", "")
    handle:close()

    -- Configure laptop panel scale per machine
    local edp_scale = "1"
    local edp_mode = "preferred"

    if hostname == "14aph8" then
        edp_scale = "1.333333"
        edp_mode = "preferred"
        else
            edp_scale = "1"
            edp_mode = "preferred"
            end

            --###############
            --## MONITORS ###
            --###############

            hl.monitor({
                output = "DP-1",
                mode = "preferred",
                position = "0x0",
                scale = "1",
            })

            hl.monitor({
                output = "HDMI-A-1",
                mode = "1920x1080@60",
                position = "auto-right",
                scale = "1",
            })

            hl.monitor({
                output = "eDP-1",
                mode = edp_mode,
                position = "auto-right",
                scale = edp_scale,
            })

            hl.monitor({
                output = "",
                mode = "preferred",
                position = "auto-left",
                scale = "1",
            })

            --################
            --## WORKSPACES ##
            --################

            local external_output = nil
            if has_dp then
                external_output = "DP-1"
                elseif has_hdmi then
                    external_output = "HDMI-A-1"
                    end

                    if external_output then
                        -- External monitor is connected: 1-5 external, 6-10 eDP-1
                        for w = 1, 5 do
                            hl.workspace_rule({
                                workspace = tostring(w),
                                              monitor = external_output,
                                              default = (w == 1),
                            })
                            end
                            for w = 6, 10 do
                                hl.workspace_rule({
                                    workspace = tostring(w),
                                                  monitor = "eDP-1",
                                                  default = (w == 6),
                                })
                                end
                                else
                                    -- Laptop only: route all workspaces to eDP-1
                                    for w = 1, 10 do
                                        hl.workspace_rule({
                                            workspace = tostring(w),
                                                          monitor = "eDP-1",
                                                          default = (w == 1),
                                        })
                                        end
                                        end

--############################
--## ENVIRONMENT VARIABLES ###
--############################

-- XWayland

hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.layer_rule({
    name = "waybar",
    match = {
        namespace = "waybar",
    },
    blur = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    name = "kitty",
    match = {
        namespace = "kitty",
    },
    blur = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    name = "swayosd",
    match = {
        namespace = "swayosd",
    },
    blur = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    name = "quickshell-surfaces",
    match = {
        namespace = "^(quickshell-bar|quickshell-drawer)$",
    },
    blur = true,
    ignore_alpha = 0.1,
    no_anim = true,
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

local terminal = "kitty"
local fileManager = "kitty -e yazi"
local menu = "fuzzel"
local browser = "waterfox"

local home = os.getenv("HOME")

-- Window Actions
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
hl.bind("SUPER + SHIFT + backslash", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind("SUPER + backslash", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))

-- Tab Traversal
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { repeating = true })

-- App Launchers & Utilities
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + CTRL + RETURN", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("waypaper"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("quickshell ipc call drawer toggle"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --freeze copysave area ".. home .. "/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S').png"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("pidof hyprlock || (hyprlock & sleep 1 && hyprctl dispatch dpms off)"))
hl.bind("SUPER + ALT + backslash", hl.dsp.exec_cmd("hyprshutdown"))

-- Layout Toggles
hl.bind("SUPER + S", hl.dsp.layout("swapsplit"))
hl.bind("SUPER + D", hl.dsp.layout("togglesplit"))

-- Focus Movement (HJKL + Hardware Arrows)
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Monitor Focus
hl.bind("SUPER + comma", hl.dsp.focus({ monitor = "direction left" }))
hl.bind("SUPER + period", hl.dsp.focus({ monitor = "direction right" }))

-- Window Swapping (HJKL + Hardware Arrows)
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

-- Window Resizing (HJKL + Hardware Arrows via ALT)
hl.bind("SUPER + ALT + H", hl.dsp.window.resize({ x = -80, y = 0, relative = true }))
hl.bind("SUPER + ALT + L", hl.dsp.window.resize({ x = 80, y = 0, relative = true }))
hl.bind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = -80, relative = true }))
hl.bind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = 80, relative = true }))
hl.bind("SUPER + ALT + left",  hl.dsp.window.resize({ x = -80, y = 0, relative = true }))
hl.bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 80, y = 0, relative = true }))
hl.bind("SUPER + ALT + up",    hl.dsp.window.resize({ x = 0, y = -80, relative = true }))
hl.bind("SUPER + ALT + down",  hl.dsp.window.resize({ x = 0, y = 80, relative = true }))

-- Mouse Integration
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Media & Brightness Controls
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("quickshell ipc call hw volUp"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("quickshell ipc call hw volDown"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("quickshell ipc call hw volMute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("quickshell ipc call hw micMute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("quickshell ipc call hw briDown"), { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("quickshell ipc call hw briUp"),   { repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                 { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),           { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),           { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),             { locked = true })

-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

hl.window_rule({
    name = "kitty",
    match = {
        class = "^(waybar_update)$",
    },
    float = true,
    center = true,
    size = "1000 800",
})

hl.window_rule({
    name = "pip",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    pin = true,
    move = "70% 4%",
})

hl.window_rule({
    name = "steam-popups",
    match = {
        class = "^(steam)$",
               title = "negative:^Steam$",
    },
    float = true,
})

hl.window_rule({
    name = "musicbee",
    match = {
        class = "^(musicbee.exe)$",
               title = "negative:.*MusicBee.*",
    },
    float = true,
})

hl.window_rule({
    name = "game-suppressions",
    match = {
        class = "^(cs2|cstrike_linux64)$",
    },
    suppress_event = "maximize fullscreen",
})

-- Pavucontrol
hl.window_rule({
    name = "pavucontrol",
    match = {
        class = "(.*org.pulseaudio.pavucontrol.*)",
    },
    float = true,
    center = true,
    pin = true,
    size = "700 600",
})

-- Waypaper
hl.window_rule({
    name = "waypaper",
    match = {
        class = "(.*waypaper.*)",
    },
    float = true,
    center = true,
    pin = true,
    size = "900 700",
})

hl.window_rule({
    name = "yazi-portal",
    match = {
        class = "^(yazi-portal)$",
    },
    float = true,
    center = true,
    size = "1100 700",
})

hl.window_rule({
    name = "idle-inhibit-fullscreen",
    match = { class = "^(firefox|vlc|mpv)$" },
               idle_inhibit = "fullscreen",
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    render = {
        direct_scanout = 2,
        cm_enabled = true,
        cm_auto_hdr = 1,
--         cm_sdr_eotf = "gamma22",
    },
    --####################
    --## LOOK AND FEEL ###
    --####################
    -- Refer to https://wiki.hypr.land/Configuring/Variables/
    -- https://wiki.hypr.land/Configuring/Variables/#general
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        ["col.active_border"] = "0xff" .. colors.primary,
        ["col.inactive_border"] = "0xff" .. colors.outline_variant,
        layout = "dwindle",
        resize_on_border = true,
        allow_tearing = true,
    },
    -- https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = true,
        },
        shadow = {
            enabled = false,
        },
    },
    -- https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
        enabled = true,
    },
    -- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
    },
    master = {
        new_status = "master",
    },
    -- Extra binds for laptop
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
    -- https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        mouse_move_enables_dpms = false,
        key_press_enables_dpms = true,
    },
    --############
    --## INPUT ###
    --############
    -- https://wiki.hypr.land/Configuring/Variables/#input
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 2,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
    cursor = {
        hide_on_key_press = true,
        no_hardware_cursors = false,
    },
})
--##################
--## ANIMS ##
--##################

hl.curve("spring", { type = "spring", mass = 1, stiffness = 640, dampening = 46 })
hl.curve("exit_spring", { type = "spring", mass = 1, stiffness = 1250, dampening = 64 })
hl.curve("instant_spring", { type = "spring", mass = 1, stiffness = 1000, dampening = 60 })

hl.animation({ leaf = "windows", enabled = true, speed = 3, spring = "spring", style = "popin 85%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, spring = "spring", style = "slide" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.5, spring = "exit_spring" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.5, spring = "exit_spring" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, spring = "instant_spring" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, spring = "instant_spring" })


hl.on("hyprland.start", function ()
    hl.exec_cmd("waypaper --restore")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sway-audio-idle-inhibit")
end)




