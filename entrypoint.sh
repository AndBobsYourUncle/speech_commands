#!/bin/bash

signalListener() {
    "$@" &
    pid="$!"
    trap "echo 'Stopping PID $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

    # A signal emitted while waiting will make the wait command return code > 128
    # Let's wrap it in a loop that doesn't end before the process is indeed stopped
    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
}

signalListener ./speech_commands -c $CAPTURE_DEVICE_ID -pms $PROMPT_DURATION -cms $COMMAND_DURATION -p "$PROMPT" -t $THREADS -g "$GET_ENDPOINT"
