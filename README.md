# Local AWS Lambda dev + Github Actions

This cookiecutter project is a way to kickstart your development of [AWS Lambda][lambda] functions.

Using [Localstack][localstack] and [AWS CLI][cli] the development stays in a container.

AWS CLI is used to create the Lambda function on your AWS account.

When you are comfortable with your function, a Github Action will take care of building everything necessary, and will deploy (update) the code.

The expected workflow is to checkout a new branch and use pull requests to the master branch.

Action defined in the template will trigger on pull request to the master branch, but that is easily changed if you are not expecting a review or if you are working alone on the project.

The Python version in the template is 3.8 because it is available as a Lambda runtime.

In theory, if the project is simple enough, you would not need to open the AWS Management Console.

## Requirements

- Python + Poetry + Cookiecutter
- Docker
- AWS CLI
- AWS Account (if deploying to AWS)

## Cookiecutter

Parameters defined in the cookiecutter.json are:
- project_name  - used as the Lambda function name as well as the input for the projet_slug to replace spaces and dashes in the python module names
- author
- description
- version
- aws_services - additional services used by the lambda, separated by a comma (e.g. s3,dynamodb)
- AWS_ACCESS_KEY_ID - access key for Localstack
- AWS_SECRET_ACCESS_KEY - secret key for Localstack
- AWS_DEFAULT_REGION - default region for Localstack
- output_format - the format of the output file created by the Lambda invocation

## Setup

### AWS CLI

For local development, it is recommended to create an additional named AWS CLI profile with fake credentials.

The credentials from this profile will be used in Localstack container to set the `AWS_ACCESS_KEY_ID` , `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION`.

The steps necessary to do this are described at [link][named].

### Github Secrets

The Github Actions in the project require secrets related to your AWS account. The secrets used are `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION`. Set them up in the `Settings` tab of your repository, under `Secrets`.
Once you define secrets, you will not be able to see the values, only the names.


## Description

### Github Actions

The `.github/workflow/lambda.yml` file describes one job that is used for the next steps:
- checkout the code in the project and setup python
- use poetry and pyproject.toml to get the requirements
- use pip install and install the requirements in a folder created for the purpose of containing all files for the Lambda 
- zip the packages and the code
- use the zip file to update the code in a Lambda created prior to these steps

### Python

#### src + test

The `src` and `test` folders contain your code.

The `src` folder is used to copy and zip all code related to the Lambda.

Inside is a template `lambda_function.py` file with boilerplate code containing the `lambda_handler` function as an entrypoint.

#### pyproject.toml

Poetry is used for Python packaging and dependency management.

This makes it easier to separate the development from the production environment.

### Docker

#### docker-compose.yml

The basic description of the Localstack container is set in the compose file.

Additional services can be added when creating the project.Image tag is `0.11.4`, and is using the edge port `4566` for all services.

This is important to set if defining url_endpoint for AWS services in the Localstack container.

#### Dockerfile

The Dockerfile is used to install wanted packages for the Localstack container.

AWS uses Linux to run Lambda functions, and this is a way to build and zip all packages in a similar environment and not worry about using a different OS.

## Example

The example folder is a project created from the cookiecutter, with the name `example`.

The relevant cookiecutter input is the project_name `example` and aws_services `s3`.

An additional script is added as a wrapper around s3 api.

### Local
The steps to run everything in the Localstack are:

```bash
$ docker-compose up -d
$
$ chmod +x /scripts/lambda.sh
$ chmod +x /scripts/bucket.sh
$
$ scripts/bucket.sh setup
$
$ scripts/lambda.sh build
$ scripts/lambda.sh create
$ scripts/lambda.sh invoke
```

### Production
To get everything working on AWS, check if the deployed Lambda has `permission to read` from the `s3 bucket`. If you don't have a bucket, create it and upload the example csv file in the data folder. After this and a pull request to the master branch of the project, you will be able to invoke the deployed Lambda with the proper bucket and file name in the event.json.


## Notes

### Localstack

The Localstack will execute everything locally.

So if you want to have a playground to test AWS related things, you don't have to do put anything on your AWS account.

The not so great thing is that this is the FREE version of the Localstack and is limited in functionality.

E.g. you will not be able to add layers to your Lambda in the container. The solution for this is to install NumPy or SciPy in your development environment and zip it along with the rest of your code when in container. The Lambda in production will still have a layer, and you can skip these steps.

### Poetry and pip

As good as Poetry is for package management, to have all requirements and code in one place, it is easier to use `pip` with `--target` argument.

This way we have everything we need in one place and can create a zip to update the Lambda.

That is way the defined Github Action uses poetry to lock the package versions and create a requirements.txt used by pip.

[lambda]: https://aws.amazon.com/lambda/
[localstack]: https://github.com/localstack/localstack
[cli]: https://aws.amazon.com/cli/
[named]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
