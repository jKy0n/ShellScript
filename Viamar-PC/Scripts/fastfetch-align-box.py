import json
import json5
import subprocess
import re
from pathlib import Path

# Arquivos
input_path = Path("/home/jkyon/.config/fastfetch/config.jsonc")
output_path = Path("/home/jkyon/.config/fastfetch/config_aligned.jsonc")

# Ler JSONC como texto bruto
with input_path.open("r", encoding="utf-8") as f:
    raw_text = f.read()

# Extrai a seção de módulos
match = re.search(r'"modules"\s*:\s*(\[[\s\S]*?\])\s*(,|\})', raw_text)
if not match:
    print("❌ Não foi possível localizar a seção de módulos.")
    exit(1)

modules_raw = match.group(1)
modules = json5.loads(modules_raw)

# Detectar saída real de comandos e calcular o tamanho de exibição
max_line_len = 0
command_outputs = {}

for mod in modules:
    key = mod.get("key", "")
    text = mod.get("text", "")
    fmt = mod.get("format", "")

    if mod.get("type") == "command" and key.startswith("│") and fmt.endswith("│"):
        try:
            # Executa o comando de forma segura, sem shell expandido
            result = subprocess.run(
                text,
                shell=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                timeout=1,
                check=False,
                executable="/bin/bash"
            )
            output = result.stdout.decode("utf-8").strip().replace("\n", " ")
        except Exception:
            output = ""

        command_outputs[id(mod)] = output
        total_len = len(key) + 1 + len(output) + 1  # key + espaço + output + │
        max_line_len = max(max_line_len, total_len)

# Realinhar os formats
for mod in modules:
    key = mod.get("key", "")
    fmt = mod.get("format", "")
    if mod.get("type") == "command" and key.startswith("│") and fmt.endswith("│"):
        output = command_outputs.get(id(mod), "")
        current_len = len(key) + 1 + len(output)
        padding = max_line_len - current_len - 1  # menos o "│"

        # Limpa o format e adiciona espaços antes do │
        stripped_fmt = fmt[:-1].rstrip()
        mod["format"] = f"{stripped_fmt}{' ' * padding}│"

# Gerar novo JSON com módulos alinhados
modules_aligned = json.dumps(modules, indent=4, ensure_ascii=False)
final_text = raw_text.replace(modules_raw, modules_aligned)
final_text = re.sub(r'[ ]+\n', '\n', final_text)

# Salvar resultado
with output_path.open("w", encoding="utf-8") as f:
    f.write(final_text)

print(f"✅ Arquivo gerado com alinhamento inteligente: {output_path}")