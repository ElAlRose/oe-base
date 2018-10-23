#!/usr/bin/env bash

[ -z "${SBC_USER}" ] && exit 0

MSG="$1"
DATE=$(date)

sbc notify "SBC-notify from ${SBC_REMOTE_HOST} at ${DATE}\n${MSG}"
