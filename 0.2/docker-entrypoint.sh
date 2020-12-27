#!/bin/bash
set -e

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for primecoind"
  set -- primecoind "$@"
fi

if [ "$(echo "$1" | cut -c1)" = "-" ] || [ "$1" = "primecoind" ]; then

  mkdir -p "$XPM_DATA"
  chmod 700 "$XPM_DATA"
  chown -R primecoin "$XPM_DATA"

	if [[ ! -s "$XPM_DATA/primecoin.conf" ]]; then
    cat <<-EOF > "$XPM_DATA/primecoin.conf"
    rpcallowip=::/0
    rpcpassword=${RPC_PASSWORD}
    rpcuser=${RPC_USER}
		EOF
    chown primecoin "$XPM_DATA/primecoin.conf"
	fi

  set -- "$@" -datadir="$XPM_DATA"
fi

if [ "$1" = "primecoind" ] || [ "$1" = "primecoin-cli" ] || [ "$1" = "primecoin-tx" ]; then
  echo
  exec su-exec primecoin "$@"
fi

exec "$@"
