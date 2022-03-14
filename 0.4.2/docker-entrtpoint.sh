#!/bin/bash
set -e

if [ "$@" = "java" ]; then
  set -- "$@" -jar /opt/v-systems/bin/v-systems.jar /v-systems.conf
fi

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for v systems"
  set -- java "$@" -jar /opt/v-systems/bin/v-systems.jar /v-systems.conf
fi

echo "$@"

if [ "$(echo "$1" | cut -c1)" = "-" ] || [ "$1" = "java" ]; then

  mkdir -p "$V_SYSTEMS_DATA"
  chmod 700 "$V_SYSTEMS_DATA"
  chown -R vsystems "$V_SYSTEMS_DATA"
fi

if [ "$1" = "java" ]; then
  echo
  exec gosu vsystems "$@"
fi

exec "$@"
