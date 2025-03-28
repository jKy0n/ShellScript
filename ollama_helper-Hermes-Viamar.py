import subprocess
import ollama  # Instale com: pip install ollama

def read_file_safely(file_path):
    try:
        content = subprocess.check_output(["./ollama-read.sh", file_path], stderr=subprocess.PIPE)
        return content.decode()
    except subprocess.CalledProcessError:
        return None

file_path = input("Digite o caminho do arquivo para análise: ")
file_content = read_file_safely(file_path)

if file_content:
    response = ollama.generate(
        model="hermes:latest",
        prompt=f"Analise este arquivo e responda minha pergunta:\n{file_content}\n\nO que há de importante aqui?"
    )
    print(response["response"])
else:
    print("Erro: arquivo não acessível ou bloqueado.")
