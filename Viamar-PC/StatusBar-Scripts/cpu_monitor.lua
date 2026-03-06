-- cpu_monitor.lua (NOVA VERSÃO)
-- Repositório: ~/ShellScript/Viamar-PC/StatusBar-Scripts/
-- Symlink: ~/.config/awesome/jkyon-widgets/cpu_monitor.lua

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- Adiciona o diretório de StatusBar-Scripts ao package.path para que o require funcione
local script_dir = os.getenv("HOME") .. "/ShellScript/Viamar-PC/StatusBar-Scripts"
if not package.path:find(script_dir, 1, true) then
    package.path = script_dir .. "/?.lua;" .. package.path
end

-- Agora pode fazer o require normalmente
local monitor = require("lib.monitor")
local formatters = require("lib.formatters")

local function create_cpu_widget(args)
    args = args or { "usage", "freq", "temp" } -- Default: mostrar tudo

    local icon = '<span font="MesloLGS Nerd Font 11">  </span>'
    local widget = wibox.widget.textbox(icon .. "...")
    widget.font = "MesloLGS Nerd Font Mono Bold 8.5"
    widget.align = "center"

    local popup
    local last_stats = {}

    -- Função para criar/mostrar o popup
    local function show_popup()
        if not popup then
            popup = awful.popup {
                widget = wibox.widget {
                    widget = wibox.widget.textbox,
                    id = "valuebox",
                    markup = formatters.format_cpu_for_popup(last_stats)
                },
                border_width = 1,
                border_color = beautiful.border_focus,
                ontop = true,
                visible = false,
                shape = gears.shape.rounded_rect,
                margins = 10,
            }
        end
        popup.widget.markup = formatters.format_cpu_for_popup(last_stats)

        -- Posiciona o popup perto do widget (não do mouse)
        local x, y = mouse.coords()
        popup.x = x or 0           -- Se x for nil, usa 0
        popup.y = (y or 0) + 20    -- Se y for nil, usa 0, depois soma 20
        popup.visible = true
    end

    local function hide_popup()
        if popup then popup.visible = false end
    end

    -- Função de atualização
    local function update_widget()
        last_stats = monitor.get_cpu_stats()
        local display_text = formatters.format_cpu_for_wibar(last_stats, args)
        widget.markup = icon .. display_text
    end

    -- Timer para atualizações periódicas
    gears.timer {
        timeout = 2, -- Atualiza a cada 2 segundos
        autostart = true,
        call_now = true,
        callback = update_widget
    }

    -- Sinais do mouse: CLICK em vez de HOVER
    widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then -- Botão esquerdo do mouse
            if popup and popup.visible then
                hide_popup()
            else
                show_popup()
            end
        end
    end)

    return widget
end

return create_cpu_widget