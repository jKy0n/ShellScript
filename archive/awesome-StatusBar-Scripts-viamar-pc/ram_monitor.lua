-- ram_monitor.lua (NOVA VERSÃO)
-- Repositório: ~/ShellScript/Viamar-PC/StatusBar-Scripts/
-- Symlink: ~/.config/awesome/jkyon-widgets/ram_monitor.lua

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

local function create_ram_widget(args)
    args = args or { "usage", "available" } -- Default: mostrar uso e memória disponível

    local icon = '<span font="MesloLGS Nerd Font 11">   </span>'
    local widget = wibox.widget.textbox(icon .. "...")
    widget.font = "MesloLGS Nerd Font Mono Bold 8.5"
    widget.align = "center"

    local popup
    local popup_valuebox  -- referência direta ao widget de valores
    local last_stats = {}

    -- Função para criar/mostrar o popup
    local function show_popup()
        if not popup then
            popup_valuebox = wibox.widget {
                markup = formatters.format_ram_values_for_popup(last_stats),
                align = "left",
                valign = "top",
                widget = wibox.widget.textbox,
            }

            popup = awful.popup {
                widget = wibox.widget {
                    {
                        {
                            markup = "<b>Mem Total:</b>\n<b>Mem Used:</b>\n<b>Mem Available:</b>\n<b>Swap Used:</b>",
                            align = "right",
                            valign = "top",
                            widget = wibox.widget.textbox,
                        },
                        popup_valuebox,
                        spacing = 10,
                        layout = wibox.layout.fixed.horizontal,
                    },
                    margins = 10,
                    widget = wibox.container.margin,
                },
                border_color = beautiful.border_focus,
                border_width = 2,
                ontop = true,
                shape = gears.shape.rounded_rect,
                visible = false,
            }
        end
        popup_valuebox.markup = formatters.format_ram_values_for_popup(last_stats)
        local mouse_coords = mouse.coords()
        popup.x = mouse_coords.x + 10
        popup.y = mouse_coords.y + 10
        popup.visible = true
    end

    local function hide_popup()
        if popup then popup.visible = false end
    end

    -- Função de atualização
    local function update_widget()
        last_stats = monitor.get_ram_stats()
        local display_text = formatters.format_ram_for_wibar(last_stats, args)
        widget.markup = icon .. display_text
        if popup and popup.visible then
            popup_valuebox.markup = formatters.format_ram_values_for_popup(last_stats)
        end
    end

    -- Timer para atualizações periódicas
    gears.timer {
        autostart = true,
        call_now = true,
        callback = update_widget,
        timeout = 5, -- RAM não precisa de atualização tão frequente
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

return create_ram_widget