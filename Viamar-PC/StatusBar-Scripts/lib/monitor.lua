-- ~/.config/awesome/viamar/monitor.lua
-- viamar/monitor.lua
-- Biblioteca central para coletar métricas do sistema diretamente em Lua.

local M = {}

-- Armazena o estado anterior para cálculos de delta (CPU)
local last_cpu_stats = {}

--- Lê um arquivo do /proc ou /sys e retorna seu conteúdo.
-- @param path Caminho do arquivo
-- @return Conteúdo do arquivo como string ou nil se falhar
local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

--- Converte uma string para número, com fallback para 0.
-- @param s String para converter
-- @return Número
local function to_number(s)
    return tonumber(s) or 0
end

--- Coleta e calcula estatísticas da CPU.
-- @return Tabela com as métricas: usage_percent, frequency_ghz, temperature_celsius
function M.get_cpu_stats()
    local stats = {}

    -- 1. Uso da CPU (%)
    local stat_content = read_file("/proc/stat")
    if stat_content then
        local user, nice, system, idle, iowait, irq, softirq, steal = stat_content:match("cpu +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+) +(%d+)")

        local current = {
            idle = to_number(idle) + to_number(iowait),
            total = to_number(user) + to_number(nice) + to_number(system) + to_number(idle) + to_number(iowait) + to_number(irq) + to_number(softirq) + to_number(steal)
        }

        if last_cpu_stats.total and last_cpu_stats.total > 0 then
            local diff_idle = current.idle - last_cpu_stats.idle
            local diff_total = current.total - last_cpu_stats.total
            if diff_total > 0 then
                stats.usage_percent = math.floor((1 - diff_idle / diff_total) * 100)
            else
                stats.usage_percent = 0
            end
        else
            stats.usage_percent = 0
        end
        last_cpu_stats = current
    end

    -- 2. Frequência Média (GHz)
    local cpuinfo_content = read_file("/proc/cpuinfo")
    if cpuinfo_content then
        local total_freq, count = 0, 0
        for freq in cpuinfo_content:gmatch("cpu MHz%s*:%s*([%d%.]+)") do
            total_freq = total_freq + to_number(freq)
            count = count + 1
        end
        if count > 0 then
            stats.frequency_ghz = (total_freq / count) / 1000
        end
    end

    -- 3. Temperatura (°C) - Busca por k10temp primeiro
    local temp_path
    for i = 0, 9 do
        local name_path = "/sys/class/hwmon/hwmon" .. i .. "/name"
        local name_content = read_file(name_path)
        if name_content and name_content:match("k10temp") then
            temp_path = "/sys/class/hwmon/hwmon" .. i .. "/temp1_input"
            break
        end
    end
    -- Fallback genérico
    if not temp_path then
        for i = 0, 9 do
            local generic_path = "/sys/class/hwmon/hwmon" .. i .. "/temp1_input"
            if read_file(generic_path) then
                temp_path = generic_path
                break
            end
        end
    end
    if temp_path then
        local temp_val = read_file(temp_path)
        if temp_val then
            stats.temperature_celsius = math.floor(to_number(temp_val) / 1000)
        end
    end

    return stats
end

--- Coleta e calcula estatísticas de RAM e Swap.
-- @return Tabela com as métricas de memória
function M.get_ram_stats()
    local stats = {}
    local meminfo = read_file("/proc/meminfo")
    if not meminfo then return stats end

    local mem_total_kb = to_number(meminfo:match("MemTotal:%s*(%d+)"))
    local mem_free_kb = to_number(meminfo:match("MemFree:%s*(%d+)"))
    local mem_available_kb = to_number(meminfo:match("MemAvailable:%s*(%d+)"))
    local buffers_kb = to_number(meminfo:match("Buffers:%s*(%d+)"))
    local cached_kb = to_number(meminfo:match("Cached:%s*(%d+)"))

    local swap_total_kb = to_number(meminfo:match("SwapTotal:%s*(%d+)"))
    local swap_free_kb = to_number(meminfo:match("SwapFree:%s*(%d+)"))

    -- O cálculo de "usado" que corresponde ao `free -m` é Total - Free - Buffers - Cache
    local mem_used_kb = mem_total_kb - mem_free_kb - buffers_kb - cached_kb
    local swap_used_kb = swap_total_kb - swap_free_kb

    -- Converte para GB
    local to_gb = function(kb) return kb / 1024 / 1024 end
    stats.total_gb = to_gb(mem_total_kb)
    stats.used_gb = to_gb(mem_used_kb)
    stats.free_gb = to_gb(mem_free_kb)
    stats.available_gb = to_gb(mem_available_kb)

    stats.swap_total_gb = to_gb(swap_total_kb)
    stats.swap_used_gb = to_gb(swap_used_kb)
    stats.swap_free_gb = to_gb(swap_free_kb)

    -- Calcula porcentagens
    if mem_total_kb > 0 then
        stats.usage_percent = math.floor((mem_used_kb / mem_total_kb) * 100)
        stats.usage_available_percent = math.floor((mem_available_kb / mem_total_kb) * 100)
    end
    if swap_total_kb > 0 then
        stats.swap_usage_percent = math.floor((swap_used_kb / swap_total_kb) * 100)
    end

    return stats
end

return M