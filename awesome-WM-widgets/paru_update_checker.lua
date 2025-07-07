--[[
    Paru Update Checker Widget para AwesomeWM
    =========================================
EN:
    This widget displays in the AwesomeWM wibar (status bar) the number of available updates via Paru,
    including both official repositories and the AUR. The update count is retrieved using "paru -Qu".

    Features:
    - Shows the number of available updates in the statusbar.
    - Tooltip with detailed update list (shows on click).
    - Auto-refresh on startup and at configurable intervals.
    - Manual refresh with right-click on the widget.

    Designed for visual integration with custom themes (reads colors from theme.lua).
    Ideal for ArchLinux users who use Paru as AUR helper.

PT:
    Este widget exibe na wibar (barra de status) do AwesomeWM a quantidade de atualizações disponíveis via Paru,
    incluindo tanto pacotes oficiais quanto do AUR. O número de updates é obtido usando o comando "paru -Qu".

    Recursos:
    - Mostra o número de atualizações disponíveis no statusbar.
    - Tooltip detalhado com a lista de atualizações (aparece ao clicar no widget).
    - Atualização automática ao iniciar e em intervalos configuráveis.
    - Atualização manual com clique direito no widget.

    Desenvolvido para integração visual com temas personalizados (usa cores do theme.lua).
    Ideal para usuários ArchLinux que utilizam o Paru como AUR helper.

    Author: John Kennedy Loria Segundo (jKyon)
]]

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function rtrim(s)
    return s:match("^(.-)%s*$")
end

local pkg_widget = wibox.widget.textbox()

local pkg_tooltip = awful.tooltip({
    objects = {},
    text = "Nenhuma atualização disponível",
    visible = false,
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    font = beautiful.font,
    opacity = 1,
})

local function update_widget(widget)
    awful.spawn.easy_async("paru -Qu", function(stdout)
        local count = 0
        for _ in stdout:gmatch("[^\r\n]+") do
            count = count + 1
        end
        widget.markup = count > 0 and ("<span font='MesloLGS Nerd Font Bold'>  " .. count .. " Pkgs |</span>") or ""
        pkg_tooltip.text = (stdout ~= "" and rtrim(stdout) or "Nenhuma atualização disponível")
    end)
end

-- Atualiza imediatamente ao iniciar
update_widget(pkg_widget)

-- E depois usa o timer
awful.widget.watch("sleep 3600", 3600, update_widget, pkg_widget)   -- 1 hora

pkg_widget:connect_signal("button::press", function(_, x, y, button)
    if button == 1 then
        -- Esquerdo: tooltip on/off
        if not pkg_tooltip.visible then
            pkg_tooltip.visible = true
            pkg_tooltip.x = mouse.current_widget_geometry.x
            pkg_tooltip.y = mouse.current_widget_geometry.y + 20
        else
            pkg_tooltip.visible = false
        end
    elseif button == 3 then
        -- Direito: atualizar agora
        update_widget(pkg_widget)
    end
end)

return pkg_widget