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

### Uso do Script

Salve o script acima como `migrate.sh` e torne-o executável:

```bash
chmod +x migrate.sh
```

Execute o script fornecendo os parâmetros necessários:

```bash
./migrate.sh <gitlab_group> <image_name> <tag>
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
