--
--
--
--
-- Importa o pacote awful
local awful = require("awful")
--
-- Função para abrir um terminal em um monitor específico
local function open_terminal_on_monitor(monitor, command)
    -- Define a tela atual para o monitor desejado
    awful.screen.focus(monitor)
    -- Abre o terminal com o comando especificado
    awful.spawn("urxvt -e " .. command, {screen = monitor})
end
--
-- Função para abrir dois terminais em um monitor específico
local function open_two_terminals_on_monitor(monitor, command1, command2)
    -- Abre o primeiro terminal
    open_terminal_on_monitor(monitor, command1)
    -- Abre o segundo terminal
    open_terminal_on_monitor(monitor, command2)
end
--
-- Abre um terminal no monitor 3 e executa o comando btop
open_terminal_on_monitor(3, "btop")
--
-- Abre dois terminais no monitor 1 e executa o comando htop em um deles
open_two_terminals_on_monitor(1, "htop", "")
--
-- Abre dois terminais no monitor 2 e executa os comandos radeontop e htop
open_two_terminals_on_monitor(2, "radeontop", "htop")