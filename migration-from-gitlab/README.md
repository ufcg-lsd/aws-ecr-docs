# GitLab Registry para AWS ECR

Este guia fornece os passos necessários para migrar imagens Docker do registry
do GitLab para o AWS Elastic Container Registry (ECR).

## 1. Introdução

Durante a migração, os usuários deverão extrair as imagens existentes do GitLab
Registry e fazer o upload delas para o AWS ECR. Este processo garantirá que
todas as imagens estejam acessíveis no novo repositório.

## 2. Pré-requisitos

Certifique-se de que:

- Você tem acesso ao GitLab Registry.
- As permissões de "push" e "pull" no AWS ECR foram configuradas via IAM
Identity Center.
- Docker CLI e AWS CLI estão instalados e configurados. (veja o
[`README.md`](../README.md) do repositório)
- Você está autenticado no IAM Identity Center (veja o
[`README.md`](../README.md) do repositório)

## 4. Automatização com Script Bash

Use o script Bash [`migrate.sh`](./migrate.sh) presente no repositório para
facilitar a migração.

### Como saber quais imagens e tags um repositório contém?

Acessando a página do repositório, na aba à esquerda, clique na opção `Deploy >
Container Registry` (ou seja, _Deploy_ e depois _Container Registry_).

Você verá uma lista de imagens de container. Ao clicar em uma das imagens você
poderá ver que tags ela tem.

### Uso do Script

Salve o script acima como `migrate.sh` e torne-o executável:

```bash
chmod +x migrate.sh
```

> [!WARNING]
> No script modifique as variáveis `GITLAB_USERNAME`,
> `GITLAB_PASSWORD`, e `NAMESPACE` para autenticação no GitLab e para criação
> de repositórios no ECR.

Execute o script fornecendo os parâmetros necessários:

```bash
./migrate.sh <gitlab_group> <image_name> <tag>
```

Por exemplo, caso você tenha um repositório em: `https://git.lsd.ufcg.edu.br/ops/python`.
Nesse repositório, eu tenho o Registry habilitado com uma imagem `python`.
Para essa imagem digamos que eu tenha a tag `3.14-alpine` associada.  
Então:

- `ops` é o nome do group do GitLab (`<gitlab_group>`)
- `python` é o nome da imagem (`<image_name>`)
- `3.14-alpine` é o nome da imagem (`<tag>`)

O comando para migrar essa imagem com essa tag seria:

```bash
./migrate.sh ops python 3.14-alpine
```

## 5. Validação

Verifique se a imagem está disponível no AWS ECR:

```bash
aws ecr describe-images --repository-name <namespace>/<nome_repositório>
```

## 6. Contato e Suporte

- Para dúvidas sobre permissões ou erros de autenticação, entre em contato com
o administrador.
- Reporte problemas de acesso ao GitLab Registry ou ao AWS ECR para a equipe de suporte.

---

Este guia deve ser seguido para todas as imagens que precisam ser migradas. Em
caso de dificuldades, consulte a documentação oficial ou o suporte técnico.
