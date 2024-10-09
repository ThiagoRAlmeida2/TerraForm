# Configuração de Máquina Virtual com OpenTofu e Azure

Este repositório contém a configuração de uma Máquina Virtual (VM) criada no Azure utilizando o OpenTofu e Terraform. A máquina foi configurada para rodar o Debian 12 "Bookworm" (Gen2) e foi provisionada com as seguintes características:

## Detalhes da VM

- **Nome da VM:** K1ng45
- **Localização:** Brazil South
- **Tamanho da VM:** Standard_D2s_v3 (2 vCPUs, 8 GiB de memória)
- **Sistema Operacional:** Debian 12 "Bookworm" (Gen2)
- **Armazenamento:** Standard_LRS
- **Autenticação:** Chave SSH (autenticação por senha desabilitada)

## Arquitetura

- **Grupo de Recursos:** k1ng45
- **Rede Virtual:** k1ng45-vnet (10.0.0.0/16)
- **Sub-rede:** k1ng45-subnet (10.0.1.0/24)
- **Interface de Rede:** interface-de-rede (IP privado alocado dinamicamente)

## Requisitos

- [OpenTofu](https://opentofu.org)
- Conta no Azure
- Chave SSH configurada para acesso à VM

## Instruções para Recriar a VM

### 1. Instalação do OpenTofu

Certifique-se de que você tenha o OpenTofu instalado. Para mais detalhes, veja [aqui](https://opentofu.org/get-started).

### 2. Configuração do Terraform

O código da VM está descrito no arquivo `main.tf`, que configura:

- Grupo de recursos no Azure
- Rede virtual e sub-rede
- Interface de rede
- Máquina virtual com Debian 12

### 3. Comandos para Inicializar e Aplicar

Execute os seguintes comandos para inicializar e aplicar a configuração da VM:

```bash
# Inicializa o backend e os plugins necessários
tofu init
```
```bahs
# Aplica as configurações
tofu plan
```
```bahs
# Cria os recursos no Azure
tofu apply
```
### 4. Acessando a Máquina Virtual

Após a ciração da VM, você pode acessar usando o IP privado gerado e sua chave SSH:

```bash
ssh adminuser@<IP_PRIVADO_DA_VM>
# Substitua <IP_PRIVADO_DA_VM> pelo IP privado gerado na saída do Terraform.
```
# Estrutura do Repositório 
```bash
.
├── .gitignore         # Arquivos ignorados pelo Git
├── main.tf            # Código principal para provisionamento da VM
├── terraform.tfstate   # Arquivo de estado do Terraform (não incluído no Git)
└── README.md          # Este arquivo de documentação
```

# Arquivo .gitignore

Certifique-se de que o arquivo .gitignore inclua o seguinte para evitar que o diretório .terraform seja versionado:
```bash
.terraform/
```

### Solução de problemas

Se você encontrar erros ao fazer o push para o GitHub devido a arquivos grandes, siga estas etapas para remover o diretório .terraform do controle de versão:

```bash
git rm -r --cached .terraform
git commit -m "Remove .terraform directory from version control"
git push -u origin main
```
## 🔗 Links

[![LinkedIn](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/thiago-ribeiro-139727260/)
[![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:thiagoralmeida23@gmail.com)
[![GitHub](https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/ThiagoRAlmeida2)
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@Thiago.Ralmeida2)
