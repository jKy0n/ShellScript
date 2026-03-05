-- ~/.config/awesome/viamar-pc/formatters.lua -- Corrigir path
-- viamar/formatters.lua
-- Funções para formatar os dados brutos da biblioteca de monitoramento.

local M = {}

--- Formata as estatísticas da CPU para exibição na wibar.
-- @param stats Tabela de estatísticas da CPU (de monitor.get_cpu_stats).
-- @param items_to_show Lista de strings com os itens a serem exibidos (ex: {"usage", "freq"}).
-- @return String formatada para o widget.
function M.format_cpu_for_wibar(stats, items_to_show)
    local items = {}
    local sep = " | "

    for _, item in ipairs(items_to_show) do
        if item == "usage" and stats.usage_percent then
            table.insert(items, string.format("%2d%%", stats.usage_percent))
        elseif item == "freq" and stats.frequency_ghz then
            table.insert(items, string.format("%.1fGHz", stats.frequency_ghz))
        elseif item == "temp" and stats.temperature_celsius then
            table.insert(items, string.format("%d°C", stats.temperature_celsius))
        end
    end

    return table.concat(items, sep)
end

--- Formata as estatísticas de RAM para exibição na wibar.
-- @param stats Tabela de estatísticas de RAM (de monitor.get_ram_stats).
-- @param items_to_show Lista de strings com os itens a serem exibidos.
-- @return String formatada para o widget.
function M.format_ram_for_wibar(stats, items_to_show)
    local items = {}
    local sep = " | "

    for _, item in ipairs(items_to_show) do
        if item == "usage" and stats.usage_percent then
            table.insert(items, string.format("U: %2d%%", stats.usage_percent))
        elseif item == "available" and stats.available_gb then
            table.insert(items, string.format("A: %.1fGB", stats.available_gb))
        elseif item == "swap_usage" and stats.swap_usage_percent then
            table.insert(items, string.format("S: %2d%%", stats.swap_usage_percent))
        end
    end

    return table.concat(items, sep)
end

--- Formata todas as estatísticas da CPU para o popup.
-- @param stats Tabela de estatísticas da CPU.
-- @return String formatada para o popup.
function M.format_cpu_for_popup(stats)
    return string.format(
        "<b>Usage:</b>\t%s%%\n" ..
        "<b>Frequency:</b>\t%s GHz\n" ..
        "<b>Temperature:</b>\t%s°C",
        stats.usage_percent or "--",
        stats.frequency_ghz and string.format("%.2f", stats.frequency_ghz) or "--",
        stats.temperature_celsius or "--"
    )
end

--- Formata todas as estatísticas de RAM para o popup.
-- @param stats Tabela de estatísticas de RAM.
-- @return String formatada para o popup.
function M.format_ram_for_popup(stats)
    return string.format(
        "<b>Mem Total:</b>\t%.2f GB\n" ..
        "<b>Mem Used:</b>\t%.2f GB (%d%%)\n" ..
        "<b>Mem Available:</b>\t%.2f GB\n" ..
        "<b>Swap Used:</b>\t%.2f GB (%d%%)",
        stats.total_gb or 0,
        stats.used_gb or 0, stats.usage_percent or 0,
        stats.available_gb or 0,
        stats.swap_used_gb or 0, stats.swap_usage_percent or 0
    )
end

return M