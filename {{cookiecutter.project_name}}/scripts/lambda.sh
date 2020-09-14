if [ $# -eq 0 ]; then
    echo "No arguments supplied";
    exit 0;
fi

file="app.zip";
func_name="local-dev"
local_endpoint="http://localhost:4566"
event="event.json"
outfile="out.{{ cookiecutter.output_format }}"

check_file_exists() {
    if [ ! -f $file ]; then
        echo "File $file not found!";
        exit -1;
    fi
}

delete_file() {
    check_file_exists;
    rm $file;
}


case $1 in

  "build")
    poetry export --without-hashes -f requirements.txt > requirements.txt
    docker build . --tag=lambda-local-dev;
    docker create --name dummy lambda-local-dev;
    docker cp dummy:/app/app.zip .;
    docker rm -f dummy;
    rm requirements.txt;
    ;;

  "create")
    check_file_exists;
    aws --endpoint-url $local_endpoint lambda create-function --function-name $func_name --runtime python3.8 --role test --handler lambda_function.lambda_handler --zip-file fileb://$file;
    delete_file;
    ;;

  "ls")
    aws --endpoint-url $local_endpoint lambda list-functions;
    ;;

  "update")
    check_file_exists;
    aws --endpoint-url $local_endpoint lambda update-function-code --function-name $func_name --zip-file fileb://$file;
    delete_file;
    ;;

  "delete-func")
    aws --endpoint-url=$local_endpoint lambda delete-function --function-name $func_name;
    ;;

  "delete-file")
    delete_file;
    ;;

  "invoke")
    aws --endpoint-url $local_endpoint lambda invoke --function-name $func_name --payload fileb://$event $outfile;
    ;;

  *)
    echo -n "unknown";
    exit -1;
    ;;
esac
