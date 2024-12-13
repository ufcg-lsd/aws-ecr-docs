# Documentação AWS

## 1. Introdução

Esta documentação tem como objetivo orientar o uso do AWS CLI para acessar e
gerenciar o AWS Elastic Container Registry (ECR). Aqui você encontrará boas
práticas, comandos essenciais e informações sobre a organização de usuários e
permissões.

## 2. Organização de Usuários e Permissões

### Projetos

Para agrupar repositórios semelhantes, a AWS oferece o conceito de
`namespaces`. Assim, o path de uma imagem seria:

```text
<namespace>/<nome_repositório>:<tag>
```

Cada projeto teria um namespace próprio e, dentro desse namespace, seus
usuários poderiam criar repositórios a fim de armazenar imagens de container.

Por exemplo, para o projeto `suporte`, um possível _path_ para uma imagem
seria:

```text
suporte/nginx:alpine
```

> [!WARNING]
> É importante que o nome do `namespace` seja genérico, de modo a evitar a
> fragmentação de um projeto em times. Em vez de termos dois projetos com
> `suporte-cloud` e `suporte-services`, o recomendado seria um único namespace
> `suporte`. Dessa forma, o time de `cloud` poderia criar repositórios em
> `suporte/cloud/*` e o time de `services` em `suporte/services/*`.

### Permissões

#### ECR (Amazon Elastic Container Registry)

Todo usuário pertencente a um projeto possui a seguintes permissões dentro de
seu namespace:

- criar repositórios
- listar imagens de seus repositórios
- atribuir tags a suas imagens
- dar `pull` em imagens
- dar `push` em imagens
- deletar imagens
- deletar repositórios

Adicionalmente, todos os usuários podem listar os repositórios de todos os
projetos, **sem** a permissão das ações acima.

### Quando é necessário criar um ticket?

É necessário criar um ticket **apenas** para criação de projetos na AWS e
adição/remoção de usuários em projetos. Recomendamos que o professor
responsável pelo projeto crie um ticket pedindo a criação do projeto,
fornecendo uma lista de emails com domínio `lsd` (e.g.,
`fulano.silva@lsd.ufcg.edu.br`, etc).

## 3. Pré-requisitos

- **Requisitos de Acesso**:
  - Login no IAM Identity Center.
    - <https://lsd-ufcg.awsapps.com/start>
  - Permissões necessárias configuradas.
- **Ferramentas Necessárias**:
  - AWS CLI instalado e configurado.
    - [Documentação oficial](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - Docker instalado.
    - [Documentação oficial](https://docs.docker.com/engine/install/)

> [!NOTE]
> Nos nossos exemplos usamos `docker`, mas você pode usar qualquer container
> engine que siga a OCI ([Podman](https://podman.io/), etc.)

## 4. Configurando o AWS CLI

Acesse o portal da AWS no link:

- <https://lsd-ufcg.awsapps.com/start>

Ao logar, você verá a conta `AWS-LSD`, expanda seu conteúdo para mais
informações. Você agora verá um menu com:

```text
<nome_role> | Access Keys 🔑
```

Clique em `Access Keys 🔑` para configurar o acesso à conta.

> [!TIP]
> Ao configurar o `profile` engine que siga a OCI
> ([Podman](https://podman.io/), etc.)

## 5. Trabalhando com o AWS ECR

> [!TIP]
> Para operações com repositórios públicos, use o comando `aws ecr-public`
> (e.g., `aws ecr-public describe-repositories`)

### Listando Repositórios

```bash
aws ecr describe-repositories
```

### Construindo e Tagueando Imagens Docker

1. Construa sua imagem:

   ```bash
   docker build -t <nome_imagem> .
   ```

2. Tagueie a imagem com a URI do repositório:

   ```bash
   docker tag <nome_imagem>:<tag> 851296927411.dkr.ecr.us-east-1.amazonaws.com/<namespace>/<nome_repositório>:<tag>
   ```

## 6. Enviando Imagens Docker para o ECR

1. Autentique o Docker no ECR:

   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS
   --password-stdin 851296927411.dkr.ecr.us-east-1.amazonaws.com
   ```

> [!WARNING]
> Certifique-se que `<namespace>/<nome_repositório>` existe no AWS ECR. Para
> criar repositórios rode:
>
> ```bash
> aws ecr create-repository --repository-name <namespace>/<nome_repositório>
> ```
>
2. Envie a imagem:

   ```bash
   docker push 851296927411.dkr.ecr.us-east-1.amazonaws.com/<namespace>/<nome_repositório>:<tag>
   ```

## 7. Baixando Imagens Docker do ECR

```bash
docker pull 851296927411.dkr.ecr.us-east-1.amazonaws.com/<namespace>/<nome_repositório>:<tag>
```

## 8. Solução de Problemas

- **Erros comuns**:
  - Problemas de autenticação: Verifique seu login no IAM Identity Center.
  - Permissões ausentes: Confirme se sua conta tem permissões adequadas.
  - Problemas no Docker: Verifique se o Docker está instalado e configurado corretamente.

## 9. Boas Práticas

- Use tags consistentes para as imagens.
- Exclua imagens antigas ou não utilizadas regularmente.

## 10. Referências

- [Documentação oficial do AWS ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)

## 11. Contato e Suporte

- Entre em contato com o suporte para questões relacionadas ao IAM Identity
Center ou ECR.
