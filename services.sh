#!/usr/bin/env bash
for svc in ssh cron nginx; do
if systemctl is-active --quiet "$svc"; then
echo "$svc: running"
else
echo "$svc: NOT running"
fi
done
