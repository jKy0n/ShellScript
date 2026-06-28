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
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local ephedrine = {}

-- Cor de fundo quando ativo (suspensão bloqueada)
local ACTIVE_BG = beautiful.bg_focus

-- Cores do texto/ícone, trocam junto com o fundo pra manter contraste
local ICON_FG_NORMAL = beautiful.fg_normal
local ICON_FG_ACTIVE = beautiful.fg_focus

-- fa-tablets (solid), codepoint \uf490
-- IMPORTANTE: ajuste o nome da fonte abaixo pro que estiver instalado
-- de fato (`fc-list | grep -i "font awesome"` pra confirmar o nome exato).
local ICON_FONT = "Font Awesome 6 Free Solid 12"
local ICON_GLYPH = "tablets"
-- local ICON_SIZE = 16

local icon_widget = wibox.widget {
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

-- Reconstrói o <span> com a cor desejada — a cor do markup Pango vem do
-- atributo `foreground` dentro do span, não de uma propriedade solta do widget.
local function icon_markup(fg)
    return string.format(
        "<span font_desc='%s' foreground='%s'>%s</span>",
        ICON_FONT, fg, ICON_GLYPH
    )
end

icon_widget.markup = icon_markup(ICON_FG_NORMAL)

local background = wibox.widget {
    {
        icon_widget,
        margins = 4,
        widget  = wibox.container.margin
    },
    bg     = nil,
    shape  = gears.shape.rounded_rect,
    widget = wibox.container.background
}

local tooltip = awful.tooltip {
    objects      = { background },
    bg           = beautiful.bg_normal,
    border_color = beautiful.border_focus,
    border_width = 2,
    fg           = beautiful.fg_normal,
    margins      = 10,
    spacing      = 10,
    text         = "ephedrine off",
}

-- Atualiza visual (fundo + cor do ícone + tooltip) a partir do estado já conhecido
local function set_state(active)
    if active then
        background.bg      = ACTIVE_BG
        icon_widget.markup = icon_markup(ICON_FG_ACTIVE)
        tooltip:set_text("ephedrine on")
    else
        background.bg      = nil
        icon_widget.markup = icon_markup(ICON_FG_NORMAL)
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