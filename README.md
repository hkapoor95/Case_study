## Technologies:
- Terraform
- Github Actions
- Node.js
- Amazon RDS
- AWS EC2
- AWS S3


## Tasks:

- Get access id, secret id from AWS
- Develop a simple api
```py
@app.get("/")
def root():
    return {"message": "Fast API in Python"}

@app.get("/user")
def read_user():
    return api.read_user()

@app.get("/question/{position}", status_code=200)
def read_questions(position: int, response: Response):
    question = api.read_questions(position)
```


- Generate SSH keys for connecting to EC2 instance
- Create a S3 bucket for storing Terraform State file

- Write Terraform Scripts for provisioning EC2 instance

## Write CI/CD pipeline

- Write Github Actions workflow: Set environment variables

```yml
env:
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  TF_STATE_BUCKET_NAME: ${{ secrets.AWS_TF_STATE_BUCKET_NAME }}
  PRIVATE_SSH_KEY: ${{ secrets.AWS_SSH_KEY_PRIVATE }}
  PUBLIC_SSH_KEY: ${{ secrets.AWS_SSH_KEY_PUBLIC }}
  AWS_REGION: us-east-1
```
- Setup backend for S3 bucket with terraform init

```yml
    - name: checkout repo
      uses: actions/checkout@v2
    - name: setup terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_wrapper: false
    - name: Terraform Init
      id: init
      run: terraform init -backend-config="bucket=$TF_STATE_BUCKET_NAME" -backend-config="region=us-east-1"
      working-directory: ./terraform
```

- Pass tf variables with Terraform plan

```yml
- name: Terraform Plan
  id: plan
  run: |-
    terraform plan \
    -var="region=us-east-1" \
    -out=PLAN
  working-directory: ./terraform
```

- Run terraform apply

```yml
- name: Terraform Apply
    id: apply
    run: |-
      terraform apply PLAN
    working-directory: ./terraform
```

- Set RDS Endpoint job output

```yml
- name: Set output
    id: set-dns
    run: |-
        echo "::set-output name=rds_endpoint::${aws_db_instance.postgres_rds.endpoint}"
    working-directory: ./terraform
```

- Run Sonar to detect bugs, code smells

```yml
- name: Checking out
  uses: actions/checkout@main
- name: SonarQube Scan
  uses: kitabisa/sonarqube-action@v1.2.0
  with:
    host: ${{ secrets.SONARQUBE_HOST }}
    login: ${{ secrets.SONARQUBE_TOKEN }}
    projectBaseDir: "codeapp/"
    projectKey: "sonar"
```