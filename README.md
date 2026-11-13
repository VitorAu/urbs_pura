# Urbs Pura

O **Urbs Pura** é um projeto acadêmico desenvolvido como trabalho universitário. O sistema tem como objetivo permitir o registro e o gerenciamento de denúncias relacionadas a problemas urbanos, facilitando seu acompanhamento e organização.

O projeto é composto por um aplicativo mobile, utilizado pelos cidadãos para registrar e consultar denúncias, e uma API REST, responsável pelas regras de negócio, autenticação, persistência dos dados e gerenciamento de mídias.

## Estrutura do Projeto

O projeto está organizado em dois componentes principais: o aplicativo mobile e a API.

```text
urbs_pura/
├── app/
│   ├── lib/
│   │   ├── config/
│   │   ├── interfaces/
│   │   ├── models/
│   │   ├── pages/
│   │   ├── repositories/
│   │   └── widgets/
│   └── pubspec.yaml
├── api/
│   ├── bin/
│   ├── lib/
│   │   ├── config/
│   │   ├── handlers/
│   │   ├── interfaces/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   └── pubspec.yaml
├── docker-compose.yml
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── urbs_pura_entity_relation.png
└── README.md
```

## Aplicativo Mobile

O aplicativo permite que os usuários registrem denúncias de problemas urbanos e acompanhem as ocorrências por meio de uma interface baseada em mapas.

### Funcionalidades

- Visualização de denúncias em um mapa interativo.
- Identificação das ocorrências por marcadores geográficos.
- Registro de denúncias a partir de uma localização selecionada no mapa.
- Seleção de categorias para classificar as ocorrências.
- Criação de novas categorias.
- Envio de fotografias relacionadas às denúncias.
- Visualização dos detalhes de uma denúncia, incluindo descrição, categoria, status, localização e fotografias.

### Tecnologias

- Flutter
- Dart
- Dio
- flutter_map
- OpenStreetMap
- image_picker

## API

A API REST é responsável por disponibilizar os recursos utilizados pelo aplicativo, centralizando as regras de negócio e a comunicação com os serviços de infraestrutura.

### Funcionalidades

- Autenticação e autorização de usuários.
- Gerenciamento de usuários.
- Gerenciamento de categorias de denúncias.
- Criação e gerenciamento de denúncias.
- Armazenamento de coordenadas geográficas.
- Envio e consulta de imagens.
- Associação de mídias às denúncias.

### Tecnologias

- Dart
- Shelf
- PostgreSQL
- PostGIS
- SeaweedFS
- Docker
- Docker Compose

## Arquitetura do Sistema

O aplicativo mobile se comunica com a API REST por meio de requisições HTTP. A API realiza o processamento das operações, acessa o banco de dados PostgreSQL com suporte geoespacial do PostGIS e utiliza o SeaweedFS para armazenamento de arquivos de mídia.

### Diagrama Entidade-Relacionamento

O diagrama abaixo representa a estrutura do banco de dados e os relacionamentos entre suas entidades.

![Diagrama Entidade-Relacionamento do Urbs Pura](urbs_pura_entity_relation.png)

## Variáveis de Ambiente

O projeto utiliza arquivos de ambiente separados para configurar a API, o aplicativo mobile e os serviços da infraestrutura.

### API (`api/.env`)

```env
DART_ENV=

DATABASE_PORT=
DATABASE_HOST=
DATABASE_NAME=
DATABASE_USER=
DATABASE_PASSWORD=
DATABASE_URL=

SERVER_PORT=
SERVER_JWT_SECRET=
SERVER_JWT_ACCESS_TOKEN_EXPIRATION=
SERVER_JWT_REFRESH_TOKEN_EXPIRATION=

S3_ENDPOINT=
S3_PUBLIC_ENDPOINT=
S3_ACCESS_KEY=
S3_SECRET_KEY=
S3_BUCKET=
S3_REGION=
```

### Aplicativo Mobile (`app/.env`)

Configure as variáveis utilizadas pelo aplicativo, como o endereço da API:

```env
API_URL=
```

## Executando o Projeto

Certifique-se de que o Docker e o Docker Compose estejam instalados.

### Ambiente de Desenvolvimento

Para iniciar os serviços da infraestrutura e a API em ambiente de desenvolvimento:

```bash
docker compose \
-f docker-compose.yml \
-f docker-compose.dev.yml \
--env-file .env.dev \
watch
```

Para visualizar os logs:

```bash
docker compose \
-f docker-compose.yml \
-f docker-compose.dev.yml \
--env-file .env.dev \
logs -f
```

Para encerrar os containers:

```bash
docker compose down
```

### Aplicativo Mobile

O aplicativo requer o Flutter SDK instalado e configurado.

A partir do diretório do aplicativo:

```bash
cd app
flutter pub get
flutter run
```

Configure o endereço da API no aplicativo para que ele consiga se comunicar com o servidor em execução.

## Objetivos do Projeto

- Aplicar conceitos de engenharia de software em um projeto prático.
- Desenvolver uma API REST utilizando Dart.
- Desenvolver um aplicativo mobile utilizando Flutter.
- Trabalhar com bancos de dados relacionais e geoespaciais.
- Implementar autenticação e autorização.
- Integrar armazenamento de objetos para arquivos de mídia.
- Praticar conteinerização e orquestração de serviços.
