# portage-unused-ranker

Script Bash que ranqueia pacotes instalados no Gentoo/Portage pelo número de dependências reversas, ajudando a encontrar candidatos seguros para remoção ou revisão. Baseado em `equery depends`, roda bem em modo "fire-and-forget" e aceita `watch` sem Frescura.

## Resumo Rápido
- **Métrica**: `usage_score = quantidade de pacotes instalados que dependem do alvo`.
- **Escopo padrão**: `@selected` (world file do usuário). Use `--world` para abrangência total.
- **Saída**: ordenada, determinística, sem cores/pagers; perfeita para rodar em `watch`.
- **Paralelismo**: `xargs -P $(nproc)` por padrão; configurável com `-j/--jobs`.

## Requisitos
- Gentoo com Portage funcional.
- [`gentoolkit`](https://wiki.gentoo.org/wiki/Gentoolkit) (por causa do `equery`).
- Ferramentas básicas (`bash`, `awk`, `sort`, `grep`, `sed`, `date`, `xargs`). O script checa tudo antes de rodar e imprime dicas de instalação via `emerge` se faltar algo.

## Instalação
1. Clone ou copie este repositório para qualquer diretório do seu usuário.
2. Garanta permissão de execução:
	```bash
	chmod +x portage-unused-ranker.sh
	```
3. (Opcional) Adicione ao `PATH`, por exemplo:
	```bash
	ln -s "$PWD"/portage-unused-ranker.sh ~/.local/bin/portage-unused-ranker
	```

## Como Funciona
1. Escolhe a lista de pacotes (via `@selected` ou `@world`).
2. Para cada CP (`categoria/pacote`), executa `equery -q depends <CP>` e conta as linhas (cada linha = um pacote instalado que depende daquele CP).
3. Opcionalmente filtra apenas itens com `score == 0` (`--no-dependency`).
4. Ordena conforme o modo escolhido (uso, ordem alfabética ou data de instalação via `BUILD_TIME`).
5. Imprime colunas simples (score/data + CP) para fácil leitura humana ou consumo em scripts.

## Uso Básico
```bash
./portage-unused-ranker.sh          # @selected, ordenado pelo menor uso primeiro
./portage-unused-ranker.sh --world  # expande @world (pode demorar mais)
./portage-unused-ranker.sh -nd      # apenas pacotes sem dependentes instalados
watch -n 60 ./portage-unused-ranker.sh -j 16
```

## Opções
| Flag | Descrição |
|------|-----------|
| `-h, --help` | Mostra ajuda resumida e sai. |
| `-v, --version` | Exibe versão do script + versões das dependências principais. |
| `-a, --alphabetical` | Ordena alfabeticamente por `categoria/pacote`. |
| `-r, --reverse` | Inverte a ordem do sort ativo. |
| `-c, --chronological` | Ordena por data de instalação (`BUILD_TIME`, mais recentes primeiro por padrão). |
| `-nd, --no-dependency` | Filtra apenas pacotes com `usage_score == 0`. |
| `-w, --world` | Usa `@world` em vez de `@selected`. |
| `-j N, --jobs N` | Define quantos workers paralelos usar no `xargs`. Default: `nproc`. |

### Prioridade das flags de ordenação
1. `-c/--chronological` tem precedência total (ignora `usage` e `alphabetical`).
2. `-a/--alphabetical` vale se `-c` não estiver ativo.
3. Sem `-c` ou `-a`, o sort é por `usage_score` crescente.
4. `-r/--reverse` apenas inverte o resultado final (ex.: `-c -r` = mais antigos primeiro).

## Exemplos Comentados
| Cenário | Comando | Resultado |
|---------|---------|-----------|
| Limpeza rápida do mundo selecionado | `./portage-unused-ranker.sh` | Lista menor uso primeiro; topo = candidatos a remoção.
| Monitoramento contínuo | `watch -n 120 ./portage-unused-ranker.sh -nd` | Atualiza a cada 2 min, mostrando só pacotes órfãos. |
| Revisão geral do sistema | `./portage-unused-ranker.sh --world -j 8` | Considera @world inteiro; limita para 8 processos paralelos. |
| Auditoria por data | `./portage-unused-ranker.sh -c -r` | Ordena por `BUILD_TIME`, mais antigos no topo (útil pra revisitar merges antigos). |

## Performance & Paralelismo
- Cada chamada a `equery depends` é relativamente pesada (Python + leitura do VDB). Em média, ~0,3–0,8 s por pacote em single-core.
- Com `xargs -P $(nproc)` o tempo cai quase linearmente. Ex.: 200 pacotes em um Ryzen 5950X (~32 threads) terminam em ~3–8 s.
- `--jobs` permite limitar quando a máquina estiver ocupada.
- A etapa cronológica (`BUILD_TIME`) é leve (somente `cat` em arquivos pequenos), então permanece sequencial para manter lógica simples.

## Limitações e Observações
- A expansão de `selected-sets` depende de `emerge --pretend --emptytree @set`. Se falhar, o script avisa e ignora aquele set (usa apenas `world`).
- `@world` completo também usa `emerge --emptytree`; pode ser lento em máquinas com muitos pacotes.
- A métrica considera **apenas dependências diretas** instaladas (`equery depends` sem `-D`). Isso evita falsos positivos pesados, mas não pega cadeias profundas. Ajuste manualmente se precisar olhar para dependências indiretas.
- Pacotes listados no world mas não instalados aparecem com score 0 e timestamp `unknown` (como esperado).

## Troubleshooting
- "`ERROR: Missing required command(s)`" → instale os pacotes sugeridos no log (`emerge app-portage/gentoolkit`, etc.).
- "`Cannot read /var/lib/portage/world`" → verifique permissões (precisa rodar como usuário com leitura do world-file; normalmente seu usuário normal já tem).
- Saída vazia mesmo com pacotes instalados → possivelmente filtros muito restritivos (`--no-dependency` + `@world` com quase tudo dependente). Retire `-nd` para validar.
- Performance ruim → ajuste `--jobs`, rode fora de horários críticos, ou limite o escopo a um set menor.

## Roadmap / Ideias Futuras
- Flag para usar `equery depends -D` (dependências indiretas) com cache opcional.
- Exportar resultado em CSV/JSON para dashboards.
- Integração com notificações do AwesomeWM/Waybar.
- Detecção automática de pacotes mascarados/desatualizados para priorizar revisão.