-- Widget DND

local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

-- Variável para armazenar o estado DND
local dnd_enabled = false

-- Função para alternar DND
local function toggle_dnd()
    dnd_enabled = not dnd_enabled
    if dnd_enabled then
        naughty.notify({ preset = naughty.config.presets.low,
                         title = "Modo DND",
                         text = "Notificações desativadas." })
    else
        naughty.notify({ preset = naughty.config.presets.low,
                         title = "Modo DND",
                         text = "Notificações ativadas." })
    end
end

-- Widget de botão
local dnd_widget = wibox.widget {
    {
        text   = "󰂞 ", -- Ícone para DND
        align  = "center",
        valign = "center",
        -- font   = beautiful.font,
        font   = "MesloLGS Nerd Font bold 12",
        widget = wibox.widget.textbox
    },
    shape  = gears.shape.circle,
    bg     = beautiful.bg_normal,
    fg     = beautiful.fg_normal,
    widget = wibox.container.background
}

-- Alternar DND ao clicar
dnd_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        toggle_dnd()
        -- Alterar a aparência do widget com base no estado DND
        if dnd_enabled then
            dnd_widget.bg = beautiful.bg_urgent
        else
            dnd_widget.bg = beautiful.bg_normal
        end
    end)
))

-- Bloqueio de notificações diretamente na função padrão
naughty.config.notify_callback = function(notification)
    if dnd_enabled then
        return nil -- Impede que notificações sejam exibidas
    end
    return notification -- Permite que notificações sejam exibidas
end

-- Retorna o widget para adicionar ao wibox
return dnd_widget