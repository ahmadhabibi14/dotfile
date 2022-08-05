#!/usr/bin/env bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Icon path
readonly ICON="${DIR}/icons/network/globe.svg"

# Displays network interface dengan ipv4 (local)
readonly TOOLTIP=$(ship --ipv4)

# Offline
ip route | grep ^default &>/dev/null || \
  echo -ne "<txt> Offline</txt>" || \
    echo -ne "<tool> Offline</tool>" || \
      exit

# Interface unknown
test -d "/sys/class/net/wlp3s0" || \
  echo -ne "<txt>Invalid</txt>" || \
    echo -ne "<tool>Interface tidak ditemukan</tool>" || \
      exit
# PRX=$(awk '{print $0}' "/sys/class/net/${INTERFACE}/statistics/rx_bytes")
PTX=$(awk '{print $0}' "/sys/class/net/wlp3s0/statistics/tx_bytes")
sleep 1
# CRX=$(awk '{print $0}' "/sys/class/net/${INTERFACE}/statistics/rx_bytes")
CTX=$(awk '{print $0}' "/sys/class/net/wlp3s0/statistics/tx_bytes")

# BRX=$(( CRX - PRX ))
BTX=$(( CTX - PTX ))

function hasil_untuk_panel () {
  
  local BANDWIDTH="${1}"
  local P=1
  
  while [[ $(echo "${BANDWIDTH}" '>' 1024 | bc -l) -eq 1 ]]; do
    BANDWIDTH=$(awk '{$1 = $1 / 1024; printf "%.2f", $1}' <<< "${BANDWIDTH}")
    P=$(( P + 1 ))
  done
  
  case "${P}" in
    0) BANDWIDTH="${BANDWIDTH} B/s" ;;
    1) BANDWIDTH="${BANDWIDTH} KB/s" ;;
    2) BANDWIDTH="${BANDWIDTH} MB/s" ;;
    3) BANDWIDTH="${BANDWIDTH} GB/s" ;;
  esac
  
  echo -e "${BANDWIDTH}"
  
  return 1
}

# RX=$(hasil_untuk_panel ${BRX})
TX=$(hasil_untuk_panel ${BTX})

# Panel
if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO="<img>${ICON}</img>"
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+=" ${TX}"
INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="${TOOLTIP}"
MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"