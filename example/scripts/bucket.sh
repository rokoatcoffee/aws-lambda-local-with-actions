if [ $# -eq 0 ]; then
    echo "No arguments supplied";
    exit 0;
fi

input_file="./data/example_data.csv";
input_key="data.csv";
local_endpoint="http://localhost:4566"
bucket_name="demo-bucket"

check_file_exists() {
    if [ ! -f $input_file ]; then
        echo "File $input_file not found!";
        exit -1;
    fi
}

case $1 in

  "setup")
    aws --endpoint-url $local_endpoint s3api create-bucket --acl public-read-write --bucket $bucket_name;
    check_file_exists
    aws --endpoint-url $local_endpoint s3api put-object --bucket $bucket_name --key $input_key --body $input_file;
    ;;

  "create")
    aws --endpoint-url $local_endpoint s3api create-bucket --acl public-read-write --bucket $bucket_name;
    ;;

  "ls")
    aws --endpoint-url $local_endpoint s3 ls;
    ;;

  "ll")
    aws --endpoint-url $local_endpoint s3 ls s3://$bucket_name;
    ;;

  "put")
    check_file_exists
    aws --endpoint-url $local_endpoint s3api put-object --bucket $bucket_name --key $input_key --body $input_file;
    ;;

  "delete")
    aws --endpoint-url $local_endpoint s3api delete-object --bucket $bucket_name --key $input_key;
    ;;

  *)
    echo -n "unknown";
    exit -1;
    ;;
esac
