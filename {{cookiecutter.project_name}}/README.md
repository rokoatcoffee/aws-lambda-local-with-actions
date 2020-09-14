# {{cookiecutter.project_name}}

{%- if cookiecutter.description != "" %}

## Description

{{cookiecutter.description}}
{%- endif %}

### Prerequisites

- Python + Poetry
- Docker
- AWS CLI

### Setup

To start with the local development crate a Localstack container.

```bash
$ docker-compose up -d
```

Set the default AWS CLI profile to a named profile for the Localstack.

In the start there will be a few packages in the `tool.poetry.dev-dependencies` section file:
- `pytest` used for testing
- `flake8` used as a linter
- `autopep8` used as a formater following PEP8

## How To Run

Use the lambda.sh script to create a Lambda function.

Build the packages and create a zip file used to update the Lambda code.

When creating the Lambda function for the first time you can run

```bash
$ chmod +x scripts/lambda.sh
$ scripts/lambda.sh build
$ scripts/lambda.sh create
$ scripts/lambda.sh invoke
```

The next time - build and update:
```bash
$ scripts/lambda.sh build
$ scripts/lambda.sh update
$ scripts/lambda.sh invoke
```

## Running The Tests

Write tests in the tests directory. Each test should be named using the `test` keyword as a prefix. E.g. `test_version`.

Test everything you wrote by running `pytest` in your command line.
