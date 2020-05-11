#!/bin/bash
# This script can be runned by docker or directly by provide the parameter
# ./start_myapp.sh -m "development" or
# ./start_myapp.sh -m "production"

# Restrat Web server(here Apache)
service apache2 restart

# start MyApp
while getopts "m:" opt; do
    case ${opt} in
        m)
            mode="${OPTARG}"
            echo "Running in '$mode' mode"
            if [ "$mode" == "development" ]; then
                # Since we are using uwsgi, hence it is commented
                #exec morbo -l "https://*:7070" script/myapp
                exec uwsgi --ini etc/uwsgi.conf:$mode
            elif [[ "$mode" = "production" || "$mode" = "staging" ]]; then
                #exec hypnotoad -f script/myapp
                exec uwsgi --ini etc/uwsgi.conf:$mode
            else 
                echo "Wrong mode provided. Accepted value - development, staging or production" 1>&2
            fi
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
    esac
done
