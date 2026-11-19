# 🚀 upgrade-kernel.sh

Automated Linux kernel preparation and build flow using `modprobed-db` to keep only the modules your system actually uses.

Automação de preparação e compilação de kernel Linux usando `modprobed-db` para manter apenas os módulos realmente usados pelo sistema.

Shared by the machines that run the CachyOS kernel (TheseusMachine, Viamar-PC) since 2026-11-19. It used to live in `TheseusMachine/tools/`.

Compartilhado entre as máquinas com kernel CachyOS (TheseusMachine, Viamar-PC) desde 2026-11-19. Antes morava em `TheseusMachine/tools/`.

## ✨ What This Script Does / O que Este Script Faz

### 🇺🇸 English

1. Checks the arguments (`-j` must be a positive integer), `/usr/src/linux`, `/proc/config.gz` and the `modprobed-db` database, then runs `sudo -v` once
2. Enters `/usr/src/linux`
3. Stores the currently loaded modules with `modprobed-db` (as the user, in `~/.config/modprobed-db/modprobed.db`)
4. Copies the running kernel config from `/proc/config.gz`
5. Forces `LOCALVERSION="-gentoo"` and `MODULE_SIG_KEY="certs/signing_key.pem"`: on the first build after a `gentoo-kernel-bin`, the config carries `-gentoo-dist-bin` and a signing key path from Gentoo's own build that does not exist here
6. Generates a reduced config with `localmodconfig`, then forces the per-machine drivers that never existed in `/proc/config.gz` (today only `USB_SERIAL_PL2303` on TheseusMachine, for the SMS UPS)
7. Refreshes defaults with `olddefconfig`
8. Compiles the kernel locally with ccache (`CC="ccache gcc"`, compiler identified by the real `gcc -v`). **No distcc**: the `gcc` in `PATH` is `/usr/bin/gcc`
9. Installs modules and the kernel (`installkernel`: dracut initramfs, `grub.cfg` and, with Secure Boot via sbctl, the signature of `/boot/kernel-<version>`)
10. Only when there are out-of-tree module packages (`linux-mod`): gives `portage` read access to the signing key and reminds you to run `emerge @module-rebuild`

### 🇧🇷 Português

1. Confere os argumentos (`-j` precisa ser inteiro positivo), o `/usr/src/linux`, o `/proc/config.gz` e o banco do `modprobed-db`, e roda `sudo -v` uma vez
2. Entra em `/usr/src/linux`
3. Salva os módulos carregados com o `modprobed-db` (como usuário, em `~/.config/modprobed-db/modprobed.db`)
4. Copia a configuração do kernel em uso a partir de `/proc/config.gz`
5. Força `LOCALVERSION="-gentoo"` e `MODULE_SIG_KEY="certs/signing_key.pem"`: no 1º build depois de um `gentoo-kernel-bin`, a config vem com `-gentoo-dist-bin` e com o caminho da chave de assinatura do build do Gentoo, que não existe aqui
6. Gera uma configuração reduzida com `localmodconfig` e força os drivers de cada máquina que nunca existiram no `/proc/config.gz` (hoje só o `USB_SERIAL_PL2303` na TheseusMachine, do nobreak SMS)
7. Atualiza os padrões com `olddefconfig`
8. Compila o kernel localmente com ccache (`CC="ccache gcc"`, compilador identificado pelo `gcc -v` real). **Sem distcc**: o `gcc` do `PATH` é o `/usr/bin/gcc`
9. Instala os módulos e o kernel (`installkernel`: initramfs do dracut, `grub.cfg` e, com Secure Boot via sbctl, a assinatura do `/boot/kernel-<versão>`)
10. Só quando há pacote com módulo fora da árvore (`linux-mod`): libera a chave de assinatura pro usuário `portage` e lembra do `emerge @module-rebuild`

## 📂 File

- `upgrade-kernel.sh`

## 🧰 Requirements / Requisitos

- Bash, `sudo`, `make`, `zcat`, `ccache`
- `modprobed-db`, with its database at `~/.config/modprobed-db/modprobed.db` / com o banco em `~/.config/modprobed-db/modprobed.db`
- `/usr/src/linux` pointing to the new source tree (`eselect kernel set`) / apontando pra árvore nova (`eselect kernel set`)
- `/proc/config.gz` in the running kernel / no kernel em uso (`CONFIG_IKCONFIG_PROC=y`)
- `setfacl` only on machines with out-of-tree modules / só nas máquinas com módulo fora da árvore

## ▶️ Usage / Uso

Alias `upgrade-kernel` (`jkyon-terminal`, `zsh/shared/alias.zsh`):

```bash
upgrade-kernel -j 10      # Viamar-PC (12 threads, regra n − 2)
upgrade-kernel -j 28      # TheseusMachine (30 threads online)
```

The full routine (portage, incubadora, checks before rebooting, cleanup) lives in `jkyon-ai-context`, `GENTOO-UPDATE.md`, section "Kernel CachyOS".

O roteiro completo (portage, incubadora, conferências antes do reboot, limpeza) está no `jkyon-ai-context`, `GENTOO-UPDATE.md`, seção "Kernel CachyOS".

## 🧠 Script Flow / Fluxo Interno do Script

```text
checks + sudo -v
/usr/src/linux
	-> modprobed-db store                       (user / usuário)
	-> copy /proc/config.gz to .config
	-> scripts/config LOCALVERSION + MODULE_SIG_KEY
	-> make localmodconfig
	-> scripts/config --module <per-machine extras>
	-> make olddefconfig
	-> make -jN                                  (ccache, local)
	-> make modules_install
	-> make install                              (installkernel: dracut, grub, sbctl)
	-> setfacl portage on signing_key.pem        (only with linux-mod packages)
```

## ⚠️ Important Warnings / Avisos Importantes

### 🇺🇸 English

- `localmodconfig` removes modules that are not in the `modprobed-db` database. Plug in occasional hardware (USB Wi-Fi, pendrive, printer, webcam) before building.
- A driver that was never in `/proc/config.gz` is never turned on by `localmodconfig`, even if loaded: add it to the per-machine `case` in the script.
- The kernel config comes from `/proc/config.gz`, not from the `cachyos-sources` USE flags (the `.config` the ebuild writes is discarded).

### 🇧🇷 Português

- O `localmodconfig` remove os módulos que não estão no banco do `modprobed-db`. Plugar o hardware de uso eventual (Wi-Fi USB, pendrive, impressora, webcam) antes do build.
- Driver que nunca esteve no `/proc/config.gz` não é ligado pelo `localmodconfig`, mesmo carregado: entra no `case` por máquina do script.
- A config do kernel vem do `/proc/config.gz`, não das USE do `cachyos-sources` (o `.config` que o ebuild gera é descartado).

## 🙌 Author / Autor

John Kennedy a.k.a. jKyon
