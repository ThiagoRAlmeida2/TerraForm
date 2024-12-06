# README - Configuração do Servidor Web com Nginx

Este repositório contém um playbook Ansible para configurar um servidor web utilizando o Nginx e personalizar a página inicial do servidor. Também inclui configurações de firewall e ajustes para rodar o servidor Nginx na porta 8080.

## Pré-requisitos

Antes de executar as tarefas do Ansible, certifique-se de que o ambiente está configurado com as seguintes ferramentas:

- **Ansible**: Utilizado para automação da configuração do servidor.
- **Nginx**: Servidor web utilizado para servir páginas HTML.
- **UFW**: Utilizado para configurar o firewall e permitir o tráfego HTTP na porta 8080.

## Passos para Configuração

### 1. **Configuração do Nginx via Ansible**

Abaixo está o conteúdo do playbook Ansible utilizado para configurar o servidor Nginx:

```yaml
---
- name: Configurar servidor web com Nginx
  hosts: all
  become: true
  tasks:
    - name: Atualizar o cache de pacotes
      ansible.builtin.apt:
        update_cache: true

    - name: Instalar Nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Configurar a página inicial personalizada
      ansible.builtin.copy:
        dest: /var/www/html/index.html
        content: |
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Bem-vindo ao Nginx!</title>
          </head>
          <body>
              <h1>Servidor Nginx configurado via Ansible</h1>
              <p>Este é um exemplo de página inicial personalizada.</p>
          </body>
          </html>
        mode: '0644'

    - name: Habilitar e iniciar o serviço Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

    - name: Permitir tráfego HTTP no UFW
      community.general.ufw:
        rule: allow
        port: 8080
        proto: tcp

    - name: Habilitar o firewall UFW
      ansible.builtin.command: ufw enable
      register: ufw_enable_result
      changed_when: "'Firewall is active' in ufw_enable_result.stdout"

    - name: Reiniciar o Nginx para aplicar as alterações
      ansible.builtin.service:
        name: nginx
        state: restarted
```

## 2. O que o playbook faz

- Atualiza o cache de pacotes: Atualiza os pacotes .
- Disponíveis no repositório.
- Instala o Nginx: Se o Nginx não estiver instalado, o playbook o instala.
- Configura a página inicial personalizada: Cria um arquivo index.html em /var/www/html/ com uma página simples de boas-vindas.
- Habilita e inicia o Nginx: Garante que o serviço Nginx seja iniciado e habilitado para iniciar automaticamente ao reiniciar o sistema.
- Configura o firewall (UFW): Permite o tráfego HTTP na porta 8080.
- Reinicia o Nginx: Após as configurações, o serviço é reiniciado para aplicar todas as alterações.

## 3. Configuração do Nginx para rodar na porta 8080

Para rodar o servidor Nginx na porta 8080, foram feitos os seguintes ajustes no arquivo de configuração do Nginx (/etc/nginx/sites-available/default):

A linha listen 80 default_server; foi alterada para listen 8080 default_server;, para que o servidor escute na porta 8080.
A linha #listen 80; foi mantida comentada, já que a porta 8080 está sendo utilizada.

A configuração final do arquivo /etc/nginx/sites-available/default ficou assim:

```nginx
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}

```

## 4. Habilitação do firewall (UFW)

Para garantir que a porta 8080 esteja acessível, a configuração do firewall foi atualizada para permitir tráfego na porta 8080. Isso foi feito com o seguinte comando:

```cmd
ufw allow 8080/tcp
```

## 5. Verificação de funcionamento

Após a execução do playbook, você pode verificar se o servidor está rodando corretamente usando os seguintes métodos:

Usando ss para verificar a porta:

- Verifique se a porta 8080 está em uso com o seguinte comando:

```cmd
ss -tuln | grep 8080
```

- Usando curl para testar:

Você pode testar o acesso à página personalizada com o curl:

```cmd
curl http://localhost:8080
```

- Acessando pelo navegador

```cmd
http://<Ip_do_container>:8080
```

- Ou, caso esteja acessando de uma máquina diferente, substitua localhost pelo IP da máquina onde o Nginx está configurado:

```cmd
http://<IP_DA_MAQUINA>:8080
```

### Se o servidor estiver funcionando corretamente, você verá a página personalizada criada no passo 2.

## 6. Conclusão

Este playbook configura um servidor Nginx simples, executando na porta 8080, com uma página inicial personalizada. Além disso, configura o firewall para permitir o tráfego HTTP na nova porta e reinicia o Nginx para garantir que todas as mudanças sejam aplicadas.