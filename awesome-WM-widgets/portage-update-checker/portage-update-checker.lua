--
--      Title:      portage-update-checker.lua
--      Brief:      Widget para verificar atualizações do Portage e mostrar detalhes em um tooltip
--      Path:       /home/jkyon/ShellScript/awesome-WM-widgets/portage-update-checker/portage-update-checker.lua
--      Linked:     /home/jkyon/.config/awesome/jkyon-widgets/portage-update-checker/portage-update-checker.lua
--      Author:     John Kennedy a.k.a. jKyon
--      Created:    2024-12-31
--      Updated:    2026-06-27
--      Notes:      Refatorado para funcionar com 'emerge --quiet' (sem USE flags no popup).
--


local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local portage_checker = wibox.widget.textbox()

local tooltip = awful.tooltip({
    bg = beautiful.bg_normal,
    border_color = beautiful.border_focus,
    border_width = 2,
    fg = beautiful.fg_normal,
    font = "MesloLGS Nerd Font Bold 10", -- Dobre o tamanho aqui (ajuste conforme sua fonte)
    opacity = 1,
    shape = gears.shape.rounded_rect,
    text = "Verificando...",
    spacing = 10,
    margins = 10
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

-- Limite de linhas no tooltip. Mesmo sem USE flags (--quiet), um @world
-- grande (ex: rebuild de slot) pode gerar 100+ linhas e voltar a estourar a tela.
local MAX_TOOLTIP_LINES = 50

local function update_widget()
    -- --color=n: garante saída sem códigos ANSI mesmo se o emerge decidir
    -- colorir (não deveria, sem tty, mas é defesa barata contra regex furada).
    awful.spawn.easy_async_with_shell('LC_MESSAGES=C emerge -puND --quiet --color=n @world', function(stdout)
        local updates = {}
        local num_pkgs = 0

        -- Por que mudou: --quiet suprime a linha de resumo "Total: N packages...".
        -- Essa linha só existe no modo verboso (-v). Sem ela, "Total: (%d+) packages"
        -- nunca casa com nada -> num_pkgs fica nil -> widget sempre "desaparece".
        --
        -- Fix: cada operação real do emerge em modo --quiet imprime UMA linha
        -- começando com "[ebuild". Não existe mais resumo pra ler; a contagem
        -- passa a ser o próprio número de linhas que batem nesse padrão.
        -- (Linhas como "[blocks B  ]" são avisos de bloqueio, não merges reais,
        -- então ficam de fora de propósito — mesmo comportamento do "Total:" antigo.)
        for line in stdout:gmatch("[^\r\n]+") do
            if line:match("^%[ebuild") then
                num_pkgs = num_pkgs + 1
                table.insert(updates, line)
            end
        end

        if num_pkgs > 0 then
            portage_checker.text = "  " .. num_pkgs .. " Pkgs  |"
        else
            portage_checker.text = ""
        end

        if #updates > 0 then
            if #updates > MAX_TOOLTIP_LINES then
                local shown = {}
                for i = 1, MAX_TOOLTIP_LINES do
                    shown[i] = updates[i]
                end
                table.insert(shown, string.format("... e mais %d pacote(s)", #updates - MAX_TOOLTIP_LINES))
                tooltip.text = table.concat(shown, "\n")
            else
                tooltip.text = table.concat(updates, "\n")
            end
        else
            tooltip.text = "Nenhuma atualização"
        end
    end)
end

-- Timer para atualizar a cada hora
local timer = gears.timer {
    autostart = true,
    call_now = true,
    callback = update_widget,
    -- timeout = 3600,         -- Tempo em segundos (1 hora)
    timeout = 7200,         -- Tempo em segundos (2 horas)
    -- timeout = 14400,        -- Tempo em segundos (4 horas)
}

return portage_checker