#! /usr/bin/env bash

# Função para obter a carga da bateria
get_battery_percentage() {
  # Adapte o comando abaixo para a sua distribuição Linux
  # Se você usa upower, use:
  # battery_percentage=$(upower -i $(upower -e | grep BAT) | grep -oP '(?<=percentage: )\d+')

battery_percentage=$(acpi -b | awk '{match($0, /[0-9]+%/); print substr($0, RSTART, RLENGTH-1)}')
echo $battery_percentage

}

# Função para verificar se está conectado à energia
is_charging() {
  # Adapte o comando abaixo para a sua distribuição Linux
  # Se você usa upower, use:
  # charging=$(upower -i $(upower -e | grep BAT) | grep -oP '(?<=status: )\w+')
  # echo $?

  charging=$(acpi -a | grep -c "on-line")  # Conta o número de ocorrências de "Charging"
  echo $charging
}

# Loop principal
#while true; do
  clear
  battery_level=$(get_battery_percentage)
  charging=$(is_charging)

  # Verifica a carga da bateria e define a cor
  if [ "$battery_level" -lt 33 ]; then
    color="\033[31m"  # Vermelho
  elif [ "$battery_level" -lt 50 ]; then
    color="\033[33m"  # Amarelo
  else
    color="\033[0m"  # Normal
  fi

  # Verifica se está carregando e adiciona o símbolo do raio
  if [ "$charging" -gt 0 ]; then  # Verifica se há ocorrência de "Charging"
    # charging_symbol=" ⚡  "
    charging_symbol=" 🟢"
  else
    charging_symbol=""
  fi

  # Exibe a informação formatada
#  echo -ne " ${color} $charging_symbol $battery_level \033[0m "
  echo -ne "${color} $battery_level%$charging_symbol \033[0m"
# sleep 5
# done

