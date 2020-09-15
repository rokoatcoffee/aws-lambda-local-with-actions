import storage
import json


def lambda_handler(event, context):
    try:

        bucket_name, bucket_key = get_keys(event)
        out = get_csv_data(bucket_name, bucket_key)

        return {
            'statusCode': 200,
            'body': json.dumps(out)
        }

    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps(f"Exception: {e}")
        }


def get_keys(event):
    s3_event_data = event['Records'][0]['s3']
    bucket_name = s3_event_data['bucket']['name']
    bucket_key = s3_event_data['object']['key']

    return bucket_name, bucket_key


def get_csv_data(bucket_name, bucket_key):
    csv_file_reader = storage.get_object(
        bucket_name=bucket_name, bucket_key=bucket_key)
    header, items = storage.read_csv_data(csv_file_reader)

    out = []
    for item in items:
        out.append(dict(zip(header, item)))

    return out
