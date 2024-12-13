#!/bin/bash

# Variáveis globais
GITLAB_REGISTRY_URL="registry-git.lsd.ufcg.edu.br"
ECR_ACCOUNT_ID="851296927411"
ECR_REGION="us-east-1"

GITLAB_USERNAME=
GITLAB_PASSWORD=

NAMESPACE=

# Parâmetros do usuário
GITLAB_GROUP=$1
IMAGE_NAME=$2
TAG=$3

if [ $# -ne 3 ]; then
  echo "Usage: migrate.sh <gitlab_group> <image_name> <tag>"
  exit 1
fi

# Autenticar no GitLab Registry
echo "Autenticando no GitLab Registry..."
docker login "$GITLAB_REGISTRY_URL" --username "$GITLAB_USERNAME" --password "$GITLAB_PASSWORD"

# Fazer pull da imagem do GitLab Registry
echo "Baixando a imagem do GitLab Registry..."
docker pull "$GITLAB_REGISTRY_URL/$GITLAB_GROUP/$IMAGE_NAME:$TAG"

# Autenticar no AWS ECR
echo "Autenticando no AWS ECR..."
aws ecr get-login-password --region $ECR_REGION | docker login --username AWS --password-stdin $ECR_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com

# Verificar e criar repositório no ECR, se necessário
EXISTING_REPO=$(aws ecr describe-repositories --region "$ECR_REGION" --repository-names "$NAMESPACE/$IMAGE_NAME" 2>/dev/null)
if [ -z "$EXISTING_REPO" ]; then
  echo "Repositório $IMAGE_NAME não encontrado no ECR. Criando..."
  aws ecr create-repository --region "$ECR_REGION" --repository-name "$NAMESPACE/$IMAGE_NAME"
else
  echo "Repositório $IMAGE_NAME já existe no ECR."
fi

# Taguear a imagem para o AWS ECR
echo "Tagueando a imagem para o AWS ECR..."
docker tag "$GITLAB_REGISTRY_URL/$GITLAB_GROUP/$IMAGE_NAME:$TAG" "$ECR_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$NAMESPACE/$IMAGE_NAME:$TAG"

# Fazer push da imagem para o AWS ECR
echo "Enviando a imagem para o AWS ECR..."
docker push "$ECR_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$NAMESPACE/$IMAGE_NAME:$TAG"

# Limpeza opcional
echo "Removendo imagens locais..."
docker rmi "$GITLAB_REGISTRY_URL/$GITLAB_GROUP/$IMAGE_NAME:$TAG"
docker rmi "$ECR_ACCOUNT_ID.dkr.ecr.$ECR_REGION.amazonaws.com/$NAMESPACE/$IMAGE_NAME:$TAG"

echo "Migração concluída com sucesso!"
