# 🚀 upgrade-kernel.sh

Automated Linux kernel preparation and build flow using `modprobed-db` to keep only the modules your system actually uses.

Automação de preparação e compilação de kernel Linux usando `modprobed-db` para manter apenas os módulos realmente usados pelo sistema.

## ✨ What This Script Does / O que Este Script Faz

### 🇺🇸 English

This script automates a practical kernel upgrade workflow:

1. Enters `/usr/src/linux`
2. Stores currently loaded modules with `modprobed-db`
3. Copies the running kernel config from `/proc/config.gz`
4. Generates a reduced config with `localmodconfig`
5. Refreshes defaults with `olddefconfig`
6. Compiles the kernel with the number of threads you provide
7. Installs modules
8. Installs the kernel

The goal is to make kernel upgrades faster and more reproducible while keeping the configuration close to the hardware and modules actually in use.

### 🇧🇷 Português

Este script automatiza um fluxo prático de upgrade de kernel:

1. Entra em `/usr/src/linux`
2. Salva os módulos atualmente carregados com `modprobed-db`
3. Copia a configuração do kernel em uso a partir de `/proc/config.gz`
4. Gera uma configuração reduzida com `localmodconfig`
5. Atualiza os padrões com `olddefconfig`
6. Compila o kernel com a quantidade de threads informada
7. Instala os módulos
8. Instala o kernel

O objetivo é tornar o upgrade do kernel mais rápido e mais reproduzível, mantendo a configuração próxima do hardware e dos módulos realmente usados.

## 📂 File

- `upgrade-kernel.sh`

## 🧰 Requirements / Requisitos

### 🇺🇸 English

Before using this script, make sure your system has:

- Bash
- `sudo`
- `make`
- `zcat`
- `modprobed-db`
- A valid kernel source tree linked at `/usr/src/linux`
- `/proc/config.gz` enabled in the currently running kernel

Recommended:

- Keep your bootloader update flow working correctly
- Run the script only after your normal hardware and drivers are already loaded

### 🇧🇷 Português

Antes de usar este script, verifique se o sistema possui:

- Bash
- `sudo`
- `make`
- `zcat`
- `modprobed-db`
- Uma árvore de fontes de kernel válida apontada em `/usr/src/linux`
- `/proc/config.gz` habilitado no kernel atualmente em execução

Recomendado:

- Manter o fluxo de atualização do bootloader funcionando corretamente
- Executar o script somente depois que seu hardware e drivers normais já estiverem carregados

## ▶️ Usage / Uso

### 🇺🇸 English

```bash
./upgrade-kernel.sh -j 16
```

or

```bash
./upgrade-kernel.sh --threads 16
```

### 🇧🇷 Português

```bash
./upgrade-kernel.sh -j 16
```

ou

```bash
./upgrade-kernel.sh --threads 16
```

## 🛠️ Example Workflow / Exemplo de Fluxo

### 🇺🇸 English

```bash
cd /home/jkyon/ShellScript/TheseusMachine/tools/upgrade-kernel
chmod +x upgrade-kernel.sh
./upgrade-kernel.sh -j 24
```

### 🇧🇷 Português

```bash
cd /home/jkyon/ShellScript/TheseusMachine/tools/upgrade-kernel
chmod +x upgrade-kernel.sh
./upgrade-kernel.sh -j 24
```

## 🧠 Script Flow / Fluxo Interno do Script

### 🇺🇸 English

The script follows this internal order:

```text
/usr/src/linux
	-> modprobed-db store
	-> copy /proc/config.gz to .config
	-> make localmodconfig
	-> make olddefconfig
	-> make -jN
	-> make modules_install
	-> make install
```

### 🇧🇷 Português

A ordem interna do script é esta:

```text
/usr/src/linux
	-> modprobed-db store
	-> copiar /proc/config.gz para .config
	-> make localmodconfig
	-> make olddefconfig
	-> make -jN
	-> make modules_install
	-> make install
```

## ⚠️ Important Warnings / Avisos Importantes

### 🇺🇸 English

- `localmodconfig` can remove modules that are not currently loaded. This is efficient, but risky if you build while some hardware is disconnected or inactive.
- If `/proc/config.gz` is unavailable, the current workflow will not reproduce the running kernel config correctly.
- The script assumes `/usr/src/linux` already points to the correct kernel source tree.
- The script does not validate whether the thread count is numeric.
- The script does not check whether required commands exist before running.

### 🇧🇷 Português

- `localmodconfig` pode remover módulos que não estejam carregados no momento. Isso é eficiente, mas arriscado se você compilar com algum hardware desconectado ou inativo.
- Se `/proc/config.gz` não estiver disponível, o fluxo atual não vai reproduzir corretamente a configuração do kernel em uso.
- O script assume que `/usr/src/linux` já aponta para a árvore correta de fontes do kernel.
- O script não valida se a quantidade de threads é numérica.
- O script não verifica se os comandos necessários existem antes da execução.

## ✅ Strong Points / Pontos Fortes

### 🇺🇸 English

- Clean and direct workflow
- Good use of `modprobed-db` for a leaner kernel
- Straightforward command-line interface
- Easy to adapt for a personal Gentoo-style environment

### 🇧🇷 Português

- Fluxo limpo e direto
- Bom uso de `modprobed-db` para um kernel mais enxuto
- Interface de linha de comando simples
- Fácil de adaptar para um ambiente pessoal no estilo Gentoo

## 🔍 Suggested Improvements / Melhorias Sugeridas

### 🇺🇸 English

Future improvements that would make the script safer:

- Add `set -o pipefail`
- Validate that the thread count exists and is numeric
- Check dependencies before starting
- Run `sudo -v` once at the beginning
- Confirm that `/usr/src/linux` exists and is accessible
- Warn when `/proc/config.gz` is not available
- Optionally create logs for build output

### 🇧🇷 Português

Melhorias futuras que deixariam o script mais seguro:

- Adicionar `set -o pipefail`
- Validar se a quantidade de threads existe e é numérica
- Verificar dependências antes de iniciar
- Executar `sudo -v` uma vez no começo
- Confirmar que `/usr/src/linux` existe e está acessível
- Avisar quando `/proc/config.gz` não estiver disponível
- Opcionalmente criar logs para a saída da compilação

## ❤️ Who Is This For? / Para Quem Isso É Útil?

### 🇺🇸 English

This script is a good fit for users who:

- Build custom kernels regularly
- Want a reduced configuration based on real module usage
- Prefer a fast personal automation flow over a highly defensive general-purpose tool

### 🇧🇷 Português

Este script é útil para quem:

- Compila kernels customizados com frequência
- Quer uma configuração reduzida baseada no uso real de módulos
- Prefere uma automação pessoal rápida em vez de uma ferramenta genérica cheia de validações

## 📜 License / Licença

### 🇺🇸 English

No license file is currently included in this directory.

### 🇧🇷 Português

Nenhum arquivo de licença foi incluído neste diretório até o momento.

## 🙌 Author / Autor

John Kennedy a.k.a. jKyon

