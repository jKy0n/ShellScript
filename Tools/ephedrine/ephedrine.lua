--
--       Title:      ephedrine.lua
--       Brief:      Widget AwesomeWM (wibar) para o ephedrine
--       Path:       /home/jkyon/ShellScript/Tools/ephedrine/ephedrine.lua
--       Author:     John Kennedy a.k.a. jKyon
--       Created:    2026-06-27
--       Updated:    2026-06-27
--       Notes:      Não reimplementa a lógica do ephedrine.sh — apenas chama
--                   `ephedrine status` / `ephedrine toggle` via awful.spawn.
--                   Fonte de verdade do estado é sempre o systemd-inhibit,
--                   lido pelo próprio script.
--


local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local color_palette = require("themes.jkyon.color_palette")

local ephedrine = {}

-- Cor de fundo quando ativo (suspensão bloqueada)
local ACTIVE_BG = color_palette.blue

-- fa-tablets (solid), codepoint \uf490
-- IMPORTANTE: ajuste o nome da fonte abaixo pro que estiver instalado
-- de fato (`fc-list | grep -i "font awesome"` pra confirmar o nome exato).
local ICON_FONT = "Font Awesome 6 Free Solid 12"
local ICON_GLYPH = "tablets"

local icon_widget = wibox.widget {
    markup = string.format("<span font_desc='%s'>%s</span>", ICON_FONT, ICON_GLYPH),
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

local background = wibox.widget {
    {
        icon_widget,
        margins = 4,
        widget  = wibox.container.margin,
    },
    bg     = nil,
    shape  = gears.shape.rounded_rect,
    widget = wibox.container.background,
}

local tooltip = awful.tooltip {
    objects      = { background },
    text         = "ephedrine off",
    bg           = color_palette.base,
    fg           = color_palette.text,
    border_color = color_palette.blue,
    border_width = 2,
}

-- Atualiza visual (cor + tooltip) a partir do estado já conhecido
local function set_state(active)
    if active then
        background.bg = ACTIVE_BG
        tooltip:set_text("ephedrine on")
    else
        background.bg = nil
        tooltip:set_text("ephedrine off")
    end
end

-- Consulta o estado real via `ephedrine status` (exit code 0 = ativo, 1 = inativo)
local function refresh_state()
    awful.spawn.easy_async({ "ephedrine", "status" }, function(_, _, _, exit_code)
        set_state(exit_code == 0)
    end)
end

-- Alterna estado via `ephedrine toggle`, depois resincroniza
local function toggle()
    awful.spawn.easy_async({ "ephedrine", "toggle" }, function()
        refresh_state()
    end)
end

background:buttons(gears.table.join(
    awful.button({}, 1, toggle)
))

-- Polling leve: garante que o widget reflita mudanças feitas por fora
-- (SSH, terminal local, outra instância) e não só pelo próprio clique.
gears.timer {
    timeout   = 5,
    autostart = true,
    call_now  = true,
    callback  = refresh_state,
}

ephedrine.widget = background

return ephedrine