#!/bin/bash

usage() {
  echo "Usage: $0"
  echo "  and set ENV vars for SIEGE_TARGET"
}

die() {
  local message=$1
  echo "ERROR: $message"
  usage
  exit 1
}
[ -n "$SIEGE_TARGET" ] || die "Please set SIEGE_TARGET"

stopped() {
  echo
  echo "Siege interrupted by user"
  exit 1
}

main() {
  concurrency="${SIEGE_THREADS:-1}"
  timeout="${SIEGE_TIMEOUT:-30}"
  while true; do
    ab -n 10000 -c $concurrency -s $timeout $SIEGE_TARGET
  done
}

trap stopped SIGINT SIGTERM
main
