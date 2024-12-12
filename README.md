# PinPeople Challenge

Este projeto foi desenvolvido para criar e gerenciar pesquisas, permitindo enviá-las para pessoas responderem. A API possibilita criar questionários personalizados.

## Funcionalidades

- Criação de pesquisas com temas variados.
- Envio de pesquisas para participantes.
- Gerenciamento de respostas recebidas.
- Documentação da API com Swagger.

## Tecnologias Utilizadas

- **Ruby**: 3.3.5
- **Rails**: 7.2.2
- **PostgreSQL**: Banco de dados.
- **Swagger**: Para documentação da API.
- **Gems**: Utilização de gems adicionais para suporte ao projeto.

## Pré-requisitos

- Ruby 3.3.5.
- PostgreSQL.

## Configuração do Projeto

### Clone o repositório
```bash
git clone https://github.com/seu-usuario/pinpeople-challenge.git
cd pinpeople-challenge
```

### Instale as dependências
```bash
bin/bundle install
```

### Configure o banco de dados
```bash
bin/rails db:create db:migrate
```

### Execute o servidor Rails
```bash
bin/rails server
```

### Execute os testes
Se o projeto contiver testes automatizados, execute-os com o seguinte comando:
```bash
bin/rspec
```

## Documentação da API

A documentação da API está disponível via Swagger. Acesse-a após iniciar o servidor em:
```
http://localhost:3000/api-docs
```

## Comandos Úteis

- **Iniciar o servidor Rails**:
  ```bash
  bin/rails s
  ```
- **Executar migrações**:
  ```bash
  bin/rails db:migrate
  ```
- **Testes com RSpec**:
  ```bash
  bin/rspec
  ```


