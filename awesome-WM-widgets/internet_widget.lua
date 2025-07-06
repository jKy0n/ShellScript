


-- internet_widget.lua
local awful = require("awful")
local wibox = require("wibox")

local internet_widget = {}

-- Função para verificar a conexão com a internet
local function check_internet()
    awful.spawn.easy_async_with_shell("ping -c 1 8.8.8.8", function(stdout, stderr, reason, exit_code)
        if exit_code == 0 then
            -- Se o ping for bem-sucedido, a internet está funcionando
            awful.spawn.easy_async_with_shell("lshw -C network | grep capacity", function(stdout, stderr, reason, exit_code)
                if stdout:match("100Mbit/s") then
                    -- Se a capacidade da interface de rede for 100 Mbps, a conexão pode estar limitada
                    internet_widget:set_markup("<span font='MesloLGS Nerd Font Bold 9' color='yellow'>⚠️ Conexão limitada |</span>")
                else
                    -- Se a capacidade da interface de rede for diferente de 100 Mbps, a conexão está normal e o widget fica invisível
                    internet_widget:set_markup("")
                end
            end)
        else
            -- Se o ping falhar, a internet não está funcionando e o widget mostra uma mensagem
            internet_widget:set_markup("<span font='MesloLGS Nerd Font Bold 9' color='red'> 🔴 SEM INTERNET |</span>")
        end
    end)
end

-- Criando o widget
internet_widget = wibox.widget.textbox()

-- Verificar a conexão com a internet a cada 10 segundos
awful.widget.watch("bash -c 'sleep 10'", 0, check_internet)

return internet_widget
