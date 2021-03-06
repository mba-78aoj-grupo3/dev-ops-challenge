# Final Challenge - DevOps on CloudOps

## Manual para deploy

### S3 Bucket

1 - Antes de rodar o projeto, precisamos que seja criado um bucket no s3. Para criar, entre na pasta `s3_bucket` e edite o arquivo main.tf (caso queira um nome diferente do sugerido), colocando o nome do bucket que gostaria na linha [3](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/s3_bucket/main.tf#L3) e [7](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/s3_bucket/main.tf#L7). Caso já possua um bucket para ser utilizado pelo exercício, pule pro passo 3.

2 - Rode os comandos do terraform:

    1 - terraform init
    2 - terraform plan
    3 - terraform apply -auto-approve
 
 3 - Mude o nome do bucket nos arquivos:
 
  - [state.tf](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/terraform/state.tf#L3).
  - [bucket.py](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/serverless/bucket.py#L14).

4 - Adicione o ARN do bucket criado [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/serverless/serverless.yml#L32).

### Terraform

1 - Antes de começar, garanta que você possui as credenciais corretas no seu arquivo `~/.aws/credentials`.

2 - O arquivo [main.tf](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/main/terraform/main.tf) contém as informações para o deploy do Terraform.

3 - Para mudar a região da AWS, basta trocar na variável de região, presente [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/terraform/main.tf#L9).

4 - Adicione o email que deseja receber a notificação do SNS na seguinte [linha](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/terraform/main.tf#L19).

5 - A configuração inicial do Terraform está pronta pra ser executada, rode os comandos, dentro da pasta do Terraform: 
    
    1 - terraform init
    2 - terraform plan
    3 - terraform apply -auto-approve
    
6 - Após a execução, serão criados:

    1 - Um tópico, no SNS, com o nome: requests-topic
    2 - Uma fila, no SQS, com o nome: requests-queue
    3 - Uma DLQ, no SQS, com o nome: requests-dl-queue
    4 - Um bucket no seu s3, com o nome: final-challenge-bucket ou o nome personalizado que você adicionou
    
7 - Após a criação com sucesso, vá na caixa de entrada do seu e-mail cadastrado. Você deverá receber um e-mail da AWS, pedindo para confirmar a assinatura ao tópico do SNS. Confirme, para que possa testar o recebimento dos e-mails.

### Serverless

A pasta serverless contém os arquivos para deploy das aplicações lambda e API Gateway. 

Os arquivos python presentes dentro dela, são mapeados para o exercício da seguinte forma:

    1 - create.py => Lambda1;
    2 - sell.py => Lambda2;
    3 - bucket.py => Lambda3.
   
Antes de executar o serverless, é preciso adicionar dados do tópico e fila criados no passo do Terraform e adicionar a lib boto3 para uso do nosso código lambda.

1 - Crie uma pasta chamada layer com o comando `mkdir layer` no terminal, dentro da pasta serverless.

2 - Execute o comando `pip3 install -r requirements.txt -t layer/` para que todas as dependências fiquem dentro desta pasta.

3 - Adicione o ARN do seu tópico SNS, [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L22), para permissão de publicar no tópico.

4 - Adicione o ARN da sua fila SQS (a principal, não a DLQ), [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L27), para permissão de receber mensagem.

5 - Adicione o ARN da sua fila SQS (a principal, não a DLQ), [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L57), para que o lambda receba o gatilho da fila.

6 - Adicione o ARN do seu tópico SNS, para a publicação dos dados no tópico, nos seguintes arquivos:

- [create.py](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/serverless/create.py#L9).
- [sell.py](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/8b3ff6e2585568b3bcd7013191ef880272a5bd8a/serverless/sell.py#L9).

7 - Após isso, execute o comando `sls deploy`. Ao final você terá os endpoints para criar e vender os livros.

8 - Execute os comandos a seguir para testar o fluxo, adicionando o payload que preferir:

    curl -H "Content-Type: application/json" -X POST -d '{"book_name": "Harry Potter", "book_id": 34577, "book_preco": 45.87}' https://ciotevw0ib.execute-api.us-east-1.amazonaws.com/dev/create
    
    curl -H "Content-Type: application/json" -X POST -d '{"book_id": 34577, "customer_id": 1234}' https://ciotevw0ib.execute-api.us-east-1.amazonaws.com/dev/sell
    
### Resultados

1 - Após a execução do último passo, você deverá receber uma mensagem no seu e-mail cadastrado, com o payload enviado.

2 - O seu bucket criado deverá conter um arquivo state do Terraform.

3 - O bucket deverá também possuir duas pastas `create` e `sell`, e dentro delas um arquivo txt com o payload.
