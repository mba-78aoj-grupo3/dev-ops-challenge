# Final Challenge - DevOps on CloudOps

## Manual para deploy

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
    4 - Um bucket no seu s3, com o nome: final-challenge-bucket
    
7 - Após a criação com sucesso, vá na caixa de entrada do seu e-mail cadastrado. Você deverá receber um e-mail da AWS, pedindo para confirmar a assinatura ao tópico do SNS. Confirme, para que possa testar o recebimento dos e-mails.

### Serverless

A pasta serverless contém os arquivos para deploy das aplicações lambda e API Gateway. 

Os arquivos python presentes dentro dela, são mapeados para o exercício da seguinte forma:

    1 - create.py => Lambda1;
    2 - sell.py => Lambda2;
    3 - bucket.py => Lambda3.
   
Antes de executar o serverless, é preciso adicionar dados do tópica e fila criados no passo do Terraform.

1 - Adicione o ARN do seu tópico SNS, [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L22), para permissão de publicar no tópico.

2 - Adicione o ARN da sua fila SQS (a principal, não a DLQ), [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L27), para permissão de receber mensagem.

3 - Adicione o ARN da sua fila SQS (a principal, não a DLQ), [aqui](https://github.com/mba-78aoj-grupo3/dev-ops-challenge/blob/86112c265692dec73a99a81986e08adfdec903bf/serverless/serverless.yml#L57), para que o lambda receba o gatilho da fila.

4 - Após isso, execute o comando `sls deploy`. Ao final você terá os endpoints para criar e vender os livros.

5 - Execute os comandos a seguir para testar o fluxo, adicionando o payload que preferir:

    curl -H "Content-Type: application/json" -X POST -d '{"book_name": "Harry Potter", "book_id": 34577, "book_preco": 45.87}' https://ciotevw0ib.execute-api.us-east-1.amazonaws.com/dev/create
    
    curl -H "Content-Type: application/json" -X POST -d '{"book_id": 34577, "customer_id": 1234}' https://ciotevw0ib.execute-api.us-east-1.amazonaws.com/dev/sell
    
### Resultados

1 - Após a execução do último passo, você deverá receber uma mensagem no seu e-mail cadastrado, com o payload enviado.

2 - O seu bucket criado deverá conter um arquivo state do Terraform.

3 - O bucket deverá também possuir duas pastas `create` e `sell`, e dentro delas um arquivo txt com o payload.
