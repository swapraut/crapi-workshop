#!/bin/bash

# Function to run the first collection every minute
run_first_collection() {
    while true; do
        echo "Running First Collection"
        newman run postman_collection-normal.json --environment postman_environment.json --insecure > /newman-normal.out 2> /newman-normal.err < /dev/null &
        sleep 60
    done
}

# Function to run the second collection at minute 25 past every 2nd hour
run_second_collection() {
    while true; do
        current_minute=$(date +%M)
        current_hour=$(date +%H)

        # Check if it's the 25th minute and the hour is even
        if [ "$current_minute" -eq 25 ] && [ $((current_hour % 2)) -eq 0 ]; then
            echo "Running Second Collection"
            newman run postman_collection-malicious.json --environment postman_environment.json -n 2 --insecure > /newman-malicious.out 2> /newman-malicious.err < /dev/null &
            sleep 3540 # Sleep to avoid retriggering in the same window
        else
            sleep 30 # Check again in 30 seconds
        fi
    done
}

# Start both functions in the background
run_first_collection &
run_second_collection &

# Wait for all background processes to finish
wait
