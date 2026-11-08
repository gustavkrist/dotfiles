#!/usr/bin/env bash
rex server start --extra-listen :7297 --allow-anonymous 1>/dev/null
echo "export NEURALWATT_API_KEY=$NEURALWATT_API_KEY" > ~/.bashrc
SESSION_ID=$(rex session new --shell bash "PI - $(pwd | sed -s "s:$HOME:~:")" -- pi $@)
while rex client ls --json | jq -e 'any(.clients[]; .info.kind == "app") | not' > /dev/null; do
    sleep 0.5
done
rex do session.select session_id="$SESSION_ID"
while pgrep -x pi > /dev/null; do
    sleep 1;
done
