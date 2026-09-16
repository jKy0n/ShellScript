# tmp-claude-nopasswd

Concede/revoga sudo sem senha (`NOPASSWD:ALL`) temporário pro usuário atual,
via `/etc/sudoers.d/tmp-claude-nopasswd`. Existe porque o cache de `sudo -v`
é por tty/sessão — não atravessa de um terminal local pra uma sessão SSH
separada (ex: Claude Code numa conexão SSH), então não dá pra "herdar" um
sudo já autenticado em outro terminal.

## Contexto / por que existe

Alternativa considerada e descartada: desativar `tty_tickets`
(`Defaults:jkyon !tty_tickets`) resolveria o problema do cache sem abrir mão
de senha. Optou-se por `NOPASSWD:ALL` mesmo assim por simplicidade
operacional — decisão consciente de que isso é liberação de root sem senha
pra **qualquer** processo rodando como o usuário, não só o Claude Code,
enquanto o arquivo existir. Por isso todo `on` agenda um auto-off (ver
abaixo) e o `off` manual continua sendo o próximo passo recomendado assim
que terminar o que precisava de root.

## Comandos

| comando           | descrição                                                |
|------------------:|:----------------------------------------------------------|
| `... on [DURAÇÃO]`| ativa NOPASSWD:ALL (cria `/etc/sudoers.d/tmp-claude-nopasswd`, validado com `visudo -c` antes de instalar) e agenda auto-off |
| `... off`         | desativa (remove o arquivo e cancela o auto-off pendente)  |
| `... status`      | mostra se está ativo, o caminho do arquivo e se o auto-off está agendado |

Todos os subcomandos precisam rodar com `sudo` (o diretório
`/etc/sudoers.d` é `0750 root:root`, ilegível sem privilégio).

```bash
sudo ~/ShellScript/Tools/tmp-claude-nopasswd/tmp-claude-nopasswd.sh on
sudo ~/ShellScript/Tools/tmp-claude-nopasswd/tmp-claude-nopasswd.sh status
sudo ~/ShellScript/Tools/tmp-claude-nopasswd/tmp-claude-nopasswd.sh off
```

`on` precisa ser rodado por um humano (só quem tem a senha ativa a partir do
estado sem NOPASSWD). Depois de ativo, o próprio Claude Code já consegue
rodar `sudo ... off` sozinho pra encerrar a janela quando terminar o
trabalho que precisava de root — não é obrigatório esperar o humano.

**Uso recomendado no dia a dia**: pelo comando `tmp-claude-nopasswd` (function
zsh, `~/.jkyon-terminal/zsh/shared/functions/tmp-claude-nopasswd.zsh`), que
chama este script por baixo e adiciona suporte a máquina remota e a `all`
(todas as 4 do parque). Ver aquele arquivo pra sintaxe completa
(`tmp-claude-nopasswd theseusmachine`, `tmp-claude-nopasswd all status` etc).

## Auto-off (rede de segurança)

`on` agenda automaticamente um `off` futuro via `systemd-run --on-active`
(unit transiente `tmp-claude-nopasswd-expire`, nível de sistema — mesmo
idioma do `systemd-run` já usado no `ephedrine`, mas sem `--user` porque
mexe em `/etc/sudoers.d`). Duração default **4h**, configurável por:

1. Argumento: `sudo .../tmp-claude-nopasswd.sh on 2h` (sintaxe de time-span
   do systemd — `2h`, `90min` etc)
2. Variável de ambiente: `TMP_CLAUDE_NOPASSWD_EXPIRE=1h sudo -E .../tmp-claude-nopasswd.sh on`
3. Default: `4h`

Rodar `off` manualmente cancela o timer pendente. Rodar `on` de novo (por
exemplo pra estender o prazo) rearma o timer do zero.

**Limitação conhecida**: a unit transiente do `systemd-run` **não sobrevive
a reboot** — o arquivo em `/etc/sudoers.d/` sobrevive (é disco), mas o timer
de auto-off, não. Se a máquina reiniciar com o NOPASSWD ativo, ele fica sem
rede de segurança. `status` detecta e avisa esse caso (`⚠️  ATENÇÃO: ativo
SEM auto-expiração agendada`) — não há correção automática pós-reboot, só a
detecção; o hábito recomendado é rodar `tmp-claude-nopasswd all status`
periodicamente pra auditar as 4 máquinas de uma vez.

## Arquivo que fica no sistema

`/etc/sudoers.d/tmp-claude-nopasswd` — nome fixo, prefixo `tmp-claude-`
pra ficar óbvio em qualquer auditoria futura (`ls /etc/sudoers.d/`) que é
temporário e de qual finalidade, caso alguém esqueça de rodar `off`.

---
### Autoria:
Desenvolvido com 🖤 por John Kennedy a.k.a. **jKyon**
