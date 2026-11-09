#!/usr/bin/env bash
rex server start --extra-listen :7297 --allow-anonymous 1>/dev/null
echo "export NEURALWATT_API_KEY=$NEURALWATT_API_KEY" >> ~/.bashrc
SESSION_ID=$(rex session new --interactive --shell bash "$1 - $HOST_WORKDIR" -- $@)
while rex client ls --json | jq -e 'any(.clients[]; .info.kind == "app") | not' > /dev/null; do
    sleep 0.5
done
rex do session.select session_id="$SESSION_ID"
while pgrep -x "$1" > /dev/null; do
    sleep 1;
done
