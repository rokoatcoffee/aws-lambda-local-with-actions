from {{cookiecutter.project_slug}} import __version__
import json


def lambda_handler(event, context):
    try:
        return {
            'statusCode': 200,
            'body': json.dumps(f"v{__version__}")
        }

    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps(f"Exception: {e}")
        }
