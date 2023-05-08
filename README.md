# Zabbix Docker Compose

Este aplicativo serve para executar o servidor Zabbix usando o Docker Compose. Para executar essa documentação, você precisa instalar o Git CLI na sua máquina (se ainda não estiver instalado). Seguem abaixo os passos para instalação:

1. Para instalar o Git CLI, acesse o site oficial: https://git-scm.com/downloads e baixe o instalador compatível com o seu sistema operacional.
2. Após a instalação, abra o seu terminal e clone este repositório executando o comando: `git clone https://github.com/rafaelsoutto/zabbix-docker-compose`
3. Após clonar o repositório, acesse o diretório `zabbix-docker-compose`
4. Agora execute o comando `bash run.sh` e pronto!

O servidor Zabbix estará executando na porta 8080 e para acessá-lo, abra o seu navegador e digite `http://<IP do servidor>:8080`.

O nome de usuário e senha padrão são:

- Usuário: Admin
- Senha: zabbix
