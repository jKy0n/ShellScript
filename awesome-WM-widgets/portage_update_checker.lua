local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local portage_checker = wibox.widget.textbox()
local tooltip = awful.tooltip({
    text = "Verificando...",
    bg = "#1e2030",
    fg = "#cad3f5",
    border_width = 2,
    opacity = 1,
    font = "MesloLGS Nerd Font Bold 10", -- Dobre o tamanho aqui (ajuste conforme sua fonte)

}) -- Customizado manualmente

-- Função para mostrar/ocultar o tooltip manualmente
local tooltip_visible = false
local function toggle_tooltip()
    if tooltip_visible then
        tooltip:hide()
        tooltip:remove_from_object(portage_checker)
        tooltip_visible = false
    else
        tooltip:add_to_object(portage_checker)
        tooltip:show()
        tooltip_visible = true
    end
end

portage_checker:buttons(gears.table.join(
    awful.button({}, 1, function()
        toggle_tooltip()
    end)
))

local function update_widget()
    awful.spawn.easy_async_with_shell('LC_MESSAGES=C emerge -pvuND @world', function(stdout)
        local num_pkgs = stdout:match("Total: (%d+) packages")
        if num_pkgs then
            portage_checker.text = "  " .. num_pkgs .. " Pkgs |"
        else
            portage_checker.text = ""
        end

        local updates = {}
        -- Simples, pega cada linha de atualização, ignora o resumo
        for line in stdout:gmatch("\n([^%s][^\n]*)") do
            if not line:match("^Total:") and not line:match("^\\[") then
                table.insert(updates, line)
            end
        end

        if #updates > 0 then
            tooltip.text = table.concat(updates, "\n")
        else
            tooltip.text = "Nenhuma atualização"
        end
    end)
end

-- Timer para atualizar a cada hora
local timer = gears.timer {
    timeout = 3600,
    autostart = true,
    call_now = true,
    callback = update_widget,
}

return portage_checker