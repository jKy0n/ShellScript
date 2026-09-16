# claude-sudo-nopasswd

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
enquanto o arquivo existir. Por isso o `off` é sempre o próximo passo depois
de terminar o que precisava de root.

## Comandos

| comando  | descrição                                                |
|---------:|:----------------------------------------------------------|
| `... on`     | ativa NOPASSWD:ALL (cria `/etc/sudoers.d/tmp-claude-nopasswd`, validado com `visudo -c` antes de instalar) |
| `... off`    | desativa (remove o arquivo)                                |
| `... status` | mostra se está ativo e o caminho do arquivo                |

Todos os subcomandos precisam rodar com `sudo` (o diretório
`/etc/sudoers.d` é `0750 root:root`, ilegível sem privilégio).

```bash
sudo ~/ShellScript/Tools/claude-sudo-nopasswd/claude-sudo-nopasswd.sh on
sudo ~/ShellScript/Tools/claude-sudo-nopasswd/claude-sudo-nopasswd.sh status
sudo ~/ShellScript/Tools/claude-sudo-nopasswd/claude-sudo-nopasswd.sh off
```

`on` precisa ser rodado por um humano (só quem tem a senha ativa a partir do
estado sem NOPASSWD). Depois de ativo, o próprio Claude Code já consegue
rodar `sudo ... off` sozinho pra encerrar a janela quando terminar o
trabalho que precisava de root — não é obrigatório esperar o humano.

## Arquivo que fica no sistema

`/etc/sudoers.d/tmp-claude-nopasswd` — nome fixo, prefixo `tmp-claude-`
pra ficar óbvio em qualquer auditoria futura (`ls /etc/sudoers.d/`) que é
temporário e de qual finalidade, caso alguém esqueça de rodar `off`.

---
### Autoria:
Desenvolvido com 🖤 por John Kennedy a.k.a. **jKyon**
