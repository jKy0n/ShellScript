# bulk-ocr

Um script de shell robusto para aplicar OCR (Optical Character Recognition) em um grande volume de arquivos PDF de forma rápida e eficiente, utilizando o poder do `ocrmypdf` e do `GNU Parallel`.

Ideal para digitalizar arquivos, automatizar a organização de documentos e preparar um acervo para análise por inteligência artificial.

## Funcionalidades

-   **Processamento Paralelo:** Utiliza múltiplos núcleos da CPU para processar vários PDFs simultaneamente, acelerando drasticamente o trabalho.
-   **Cálculo Automático de Threads:** Por padrão, reserva 2 threads para o sistema operacional, usando o restante para o trabalho pesado, garantindo que a máquina não trave.
-   **Flexível e Configurável:** Permite customizar o número de threads, o idioma do OCR e os diretórios de trabalho através de flags na linha de comando.
-   **Segurança contra Sobrescrita:** Os arquivos processados são sempre salvos em uma pasta `ocr-processed`, evitando qualquer risco de sobrescrita dos originais.
-   **Estrutura Intuitiva:** Basta especificar o diretório de entrada e o script cuida do resto.
-   **Validação e Ajuda:** Inclui verificação de dependências e um menu de ajuda claro e instrutivo.

## Requisitos

-   `ocrmypdf`: O motor que faz a mágica do OCR.
-   `parallel`: A ferramenta GNU Parallel, para executar os processos simultaneamente.
-   Um pacote de dados do Tesseract (ex: `tessdata_best`) com os idiomas desejados.

## Instalação

1.  Clone este repositório:
    ```bash
    git clone <url-do-seu-repositorio>
    cd <nome-do-repositorio>
    ```

2.  Dê permissão de execução ao script:
    ```bash
    chmod +x bulk-ocr.sh
    ```

3.  (Opcional) Crie um alias para facilitar o uso. Adicione esta linha ao seu `~/.bashrc` ou `~/.zshrc`:
    ```bash
    alias bulk-ocr='/caminho/completo/para/bulk-ocr.sh'
    ```

    Depois, recarregue o shell:
    ```bash
    source ~/.bashrc  # ou source ~/.zshrc
    ```

## Como Usar

O script é intuitivo e seguro. Os arquivos processados são sempre salvos em uma pasta chamada `ocr-processed`, garantindo que os originais nunca sejam sobrescritos.

### Sintaxe Básica

```bash
bulk-ocr [OPÇÕES] INPUT_DIR [OUTPUT_DIR]
```

**Argumentos:**
- `INPUT_DIR` (obrigatório): Diretório contendo os PDFs originais
- `OUTPUT_DIR` (opcional): Diretório onde a pasta `ocr-processed` será criada. Se não especificado, usa o mesmo diretório que `INPUT_DIR`.

## Opções

| Flag Curta | Flag Longa  | Descrição                                                                        | Padrão                               |
| :--------- | :---------- | :------------------------------------------------------------------------------- | :----------------------------------- |
| `-j`       | `--jobs`    | Define o número de processos paralelos a serem executados.                         | Nº de Threads do CPU - 2             |
| `-l`       | `--lang`    | Define o(s) idioma(s) para o OCR (ex: `por`, `eng`, `por+eng`).                      | `por`                                |
| `-v`       | `--version` | Mostra a versão do script e a versão do `ocrmypdf` instalada.                      | N/A                                  |
| `-h`       | `--help`    | Exibe a mensagem de ajuda com todas as opções.                                     | N/A                                  |

## Exemplos de Uso

### Exemplo 1: Uso Básico (Padrão)

Processa todos os PDFs em `./originais` e salva os resultados em `./originais/ocr-processed`.

```bash
bulk-ocr ./originais
```

**O que acontece:**
- Lê todos os PDFs de `./originais`
- Cria a pasta `./originais/ocr-processed` (se não existir)
- Salva os PDFs processados lá
- Usa `nproc - 2` threads e idioma português

### Exemplo 2: Especificando Diretório de Saída

Processa PDFs de `/dados/scans` e salva em `/backup/ocr-processed`.

```bash
bulk-ocr /dados/scans /backup
```

**O que acontece:**
- Lê todos os PDFs de `/dados/scans`
- Cria a pasta `/backup/ocr-processed` (se não existir)
- Salva os PDFs processados lá
- Usa `nproc - 2` threads e idioma português

### Exemplo 3: Com Opções Customizadas

Processa PDFs em inglês usando 8 threads, salvando em um diretório específico.

```bash
bulk-ocr -j 8 --lang=eng /dados/scans /backup
```

**O que acontece:**
- Lê todos os PDFs de `/dados/scans`
- Cria a pasta `/backup/ocr-processed` (se não existir)
- Salva os PDFs processados lá
- Usa 8 threads e idioma inglês

### Exemplo 4: Usando com Alias

Se você criou o alias conforme sugerido na instalação:

```bash
bulk-ocr -j 30 --lang=por+eng /mnt/external_drive
```

## Comportamento de Segurança

O script foi projetado com **segurança em primeiro lugar**:

-   **Nunca sobrescreve arquivos originais:** Os PDFs processados são sempre salvos em uma pasta `ocr-processed` separada.
-   **Cria diretórios automaticamente:** Se o diretório de saída não existir, o script o cria.
-   **Validação de entrada:** Verifica se os diretórios existem e se as dependências estão instaladas.
-   **Feedback claro:** Mostra exatamente o que está acontecendo durante o processamento.

## Troubleshooting

### Erro: "ocrmypdf não encontrado"

Instale o `ocrmypdf`:

```bash
# Gentoo
sudo emerge --ask app-text/ocrmypdf

# Debian/Ubuntu
sudo apt install ocrmypdf

# ArchLinux
sudo pacman -S ocrmypdf
```

### Erro: "parallel não encontrado"

Instale o GNU Parallel:

```bash
# Gentoo
sudo emerge --ask sys-apps/parallel

# Debian/Ubuntu
sudo apt install parallel

# ArchLinux
sudo pacman -S parallel
```

### Erro: "tessdata_best não encontrado"

Instale o pacote de dados do Tesseract:

```bash
# Gentoo
sudo emerge --ask app-text/tessdata_best
```

## Performance

A performance do script depende de vários fatores:

-   **Número de threads:** Quanto mais threads, mais rápido (até o limite de núcleos disponíveis).
-   **Qualidade dos PDFs:** PDFs de melhor qualidade são processados mais rápido.
-   **Tamanho dos PDFs:** PDFs maiores levam mais tempo.
-   **Modelo de Tesseract:** O modelo `best` é mais preciso mas mais lento que o `fast`.

### Benchmarks Aproximados

Com documentos de qualidade média (300 DPI, grayscale, português):

| Máquina | Threads | ~PDFs/Minuto |
| :--- | :--- | :--- |
| TheseusMachine (32 cores) | 30 | 15-20 |
| Viamar-PC (12 cores) | 10 | 5-8 |

## Licença

[Defina sua licença aqui, ex: MIT, GPL, etc.]

## Autor

Desenvolvido com ❤️ por jKyon e Manus AI.