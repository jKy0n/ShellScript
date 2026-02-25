#!/bin/bash

# ==============================================================================
#
#          FILE: bulk-ocr.sh
#
#         USAGE: bulk-ocr [OPTIONS] INPUT_DIR [OUTPUT_DIR]
#
#   DESCRIPTION: Processa um lote de arquivos PDF em um diretório de entrada,
#                aplica OCR com Tesseract e salva os resultados em uma pasta
#                "ocr-processed" dentro do diretório de saída. Otimizado para
#                paralelismo e segurança contra sobrescrita de arquivos.
#
#       OPTIONS: --- veja a função show_help ---
#  REQUIREMENTS: ocrmypdf, gnu-parallel
#        AUTHOR: jKyon & Manus AI
#       VERSION: 2.0
#       CREATED: 2026-02-24
#      REVISION: 2.0 (Lógica de diretórios melhorada)
#
# ==============================================================================

VERSION="2.0"

# --- Função de Ajuda ---
show_help() {
    cat << 'EOF'
Uso: bulk-ocr [OPÇÕES] INPUT_DIR [OUTPUT_DIR]

Aplica OCR em um lote de PDFs de forma paralela e eficiente. Os arquivos
processados são salvos em uma pasta "ocr-processed" para evitar sobrescrita
de arquivos originais.

Argumentos Posicionais:
  INPUT_DIR       Pasta contendo os PDFs originais (obrigatório)
  OUTPUT_DIR      Pasta onde a "ocr-processed" será criada. Se não especificado,
                  usa o mesmo diretório que INPUT_DIR.

Opções:
  -j, --jobs NUM      Define o número de processos paralelos.
                      Padrão: (Total de Threads - 2)
  -l, --lang LANG     Define o idioma para o OCR (ex: por, eng, por+eng).
                      Padrão: 'por'
  -v, --version       Mostra a versão do script e do ocrmypdf.
  -h, --help          Mostra esta mensagem de ajuda.

Exemplos:
  # Processa PDFs de ./originais, salva em ./originais/ocr-processed
  bulk-ocr ./originais

  # Processa PDFs de ./originais, salva em /backup/ocr-processed
  bulk-ocr ./originais /backup

  # Com opções customizadas
  bulk-ocr -j 8 --lang=eng /dados/scans /dados/backup
EOF
}

# --- Valores Padrão ---
# Calcula o número de jobs padrão deixando 2 threads para o sistema
DEFAULT_JOBS=$(($(nproc) - 2))
# Garante que o valor seja no mínimo 1
if [ "$DEFAULT_JOBS" -lt 1 ]; then
    DEFAULT_JOBS=1
fi

JOBS=$DEFAULT_JOBS
LANGUAGE="por"
INPUT_DIR=""
OUTPUT_DIR=""

# --- Análise dos Argumentos ---
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
        show_help
        exit 0
        ;;
        -v|--version)
        echo "bulk-ocr versão $VERSION"
        echo "OCRmyPDF versão $(ocrmypdf --version)"
        exit 0
        ;;
        -j|--jobs)
        JOBS="$2"
        shift 2
        ;;
        -l|--lang)
        LANGUAGE="$2"
        shift 2
        ;;
        --lang=*)
        LANGUAGE="${1#*=}"
        shift
        ;;
        --jobs=*)
        JOBS="${1#*=}"
        shift
        ;;
        *)
        # Argumentos posicionais (diretórios)
        if [[ ! "$1" =~ ^- ]]; then
            if [ -z "$INPUT_DIR" ]; then
                INPUT_DIR="$1"
            elif [ -z "$OUTPUT_DIR" ]; then
                OUTPUT_DIR="$1"
            fi
            shift
        else
            echo "Erro: Opção inválida '$1'"
            show_help
            exit 1
        fi
        ;;
    esac
done

# --- Validações ---
if [ -z "$INPUT_DIR" ]; then
    echo "Erro: INPUT_DIR é obrigatório."
    show_help
    exit 1
fi

if ! command -v ocrmypdf &> /dev/null; then
    echo "Erro: 'ocrmypdf' não encontrado. Por favor, instale-o."
    exit 1
fi

if ! command -v parallel &> /dev/null; then
    echo "Erro: 'parallel' (GNU Parallel) não encontrado. Por favor, instale-o."
    exit 1
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "Erro: O diretório de entrada '$INPUT_DIR' não existe."
    exit 1
fi

# Se OUTPUT_DIR não foi especificado, usa INPUT_DIR
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="$INPUT_DIR"
fi

# Cria o diretório de saída se não existir
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    if [ $? -ne 0 ]; then
        echo "Erro: Não foi possível criar o diretório de saída '$OUTPUT_DIR'."
        exit 1
    fi
fi

# Define o caminho final onde os PDFs processados serão salvos
FINAL_OUTPUT_DIR="$OUTPUT_DIR/ocr-processed"

# Cria a pasta ocr-processed se não existir
mkdir -p "$FINAL_OUTPUT_DIR"
if [ $? -ne 0 ]; then
    echo "Erro: Não foi possível criar o diretório '$FINAL_OUTPUT_DIR'."
    exit 1
fi

# --- Validação de Argumentos Numéricos ---
if ! [[ "$JOBS" =~ ^[0-9]+$ ]]; then
    echo "Erro: O valor de --jobs deve ser um número inteiro positivo. Recebido: '$JOBS'"
    exit 1
fi

# --- Execução ---
echo "-----------------------------------------------------"
echo "Iniciando processamento OCR em lote..."
echo "- Idioma(s):              $LANGUAGE"
echo "- Processos Paralelos:    $JOBS"
echo "- Diretório de Entrada:   $INPUT_DIR"
echo "- Diretório de Saída:     $FINAL_OUTPUT_DIR"
echo "- Modelo de Precisão:     best (instalado no sistema)"
echo "-----------------------------------------------------"
echo ""

# Conta quantos PDFs serão processados
PDF_COUNT=$(find "$INPUT_DIR" -maxdepth 1 -type f -name "*.pdf" | wc -l)

if [ "$PDF_COUNT" -eq 0 ]; then
    echo "Aviso: Nenhum arquivo PDF encontrado em '$INPUT_DIR'."
    exit 0
fi

echo "Encontrados $PDF_COUNT arquivo(s) PDF para processar."
echo ""

# Comando principal: encontra os PDFs e os processa em paralelo
find "$INPUT_DIR" -maxdepth 1 -type f -name "*.pdf" | parallel -j "$JOBS" --eta \
  ocrmypdf --force-ocr -l "$LANGUAGE" {} "$FINAL_OUTPUT_DIR/{/}"

echo ""
echo "-----------------------------------------------------"
echo "Processamento em lote concluído com sucesso!"
echo "Arquivos salvos em: $FINAL_OUTPUT_DIR"
echo "-----------------------------------------------------"