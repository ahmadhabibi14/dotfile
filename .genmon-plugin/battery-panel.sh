#!/usr/bin/env bash
# Dependencies: acpi, bash>=3.2, coreutils, file, gawk, grep, xfce4-power-manager

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icons to display before the text
# Insert the absolute path of the icons
# Recommended size is 24x24 px
declare -ra ICON_ARRAY=(
  "${DIR}/icons/battery/battery-unknown.png"      # unknown state
  "${DIR}/icons/battery/battery-0.png"            # less than 10%
  "${DIR}/icons/battery/battery-10.png"           # 10%
  "${DIR}/icons/battery/battery-20.png"           # 20%
  "${DIR}/icons/battery/battery-30.png"           # 30%
  "${DIR}/icons/battery/battery-40.png"           # 40%
  "${DIR}/icons/battery/battery-50.png"           # 50%
  "${DIR}/icons/battery/battery-60.png"           # 60%
  "${DIR}/icons/battery/battery-70.png"           # 70%
  "${DIR}/icons/battery/battery-80.png"           # 80%
  "${DIR}/icons/battery/battery-90.png"           # 90%
  "${DIR}/icons/battery/battery-100.png"          # 100%
  "${DIR}/icons/battery/battery-charging-20.png"  # battery charging, 20%
  "${DIR}/icons/battery/battery-charging-30.png"  # battery charging, 30%
  "${DIR}/icons/battery/battery-charging-40.png"  # battery charging, 40%
  "${DIR}/icons/battery/battery-charging-60.png"  # battery charging, 60%
  "${DIR}/icons/battery/battery-charging-80.png"  # battery charging, 80%
  "${DIR}/icons/battery/battery-charging-90.png"  # battery charging, 90%
  "${DIR}/icons/battery/battery-charging-100.png" # battery charging, 100%
)

# As of Linux kernel 2.6.x you need to use /sys/class/power_supply/BATX (X=integer)
readonly MANUFACTURER=$(awk '{print $1}' /sys/class/power_supply/BAT*/manufacturer)
readonly MODEL=$(awk '{print $1}' /sys/class/power_supply/BAT*/model_name)
readonly SERIAL_NUMBER=$(awk '{print $1}' /sys/class/power_supply/BAT*/serial_number)
readonly TECHNOLOGY=$(awk '{print $1}' /sys/class/power_supply/BAT*/technology)
readonly TYPE=$(awk '{print $1}' /sys/class/power_supply/BAT*/type)
readonly ENERGY_FULL=$(awk '{$1 = $1 / 1000000; print $1}' /sys/class/power_supply/BAT*/energy_full)
readonly ENERGY_DESIGN=$(awk '{$1 = $1 / 1000000; print $1}' /sys/class/power_supply/BAT*/energy_full_design)
readonly ENERGY=$(awk '{$1 = $1 / 1000000; print $1}' /sys/class/power_supply/BAT*/energy_now)
readonly VOLTAGE=$(awk '{$1 = $1 / 1000000; print $1}' /sys/class/power_supply/BAT*/voltage_now)
readonly RATE=$(awk '{$1 = $1 / 1000000; print $1}' /sys/class/power_supply/BAT*/power_now)
readonly BATTERY=$(awk '{print $1}' /sys/class/power_supply/BAT*/capacity)
readonly TEMPERATURE=$(acpi -t | awk '{print $4}')
readonly TIME_UNTIL=$(acpi | awk '{print $5}')

# Panel
# Proper icon handling
INFO=
if acpi -a | grep -i "off-line" &> /dev/null; then # if AC adapter is offline
  if [ "${BATTERY}" -lt 10 ]; then # if battery is less than 10%
    if [[ $(file -b "${ICON_ARRAY[1]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[1]}</img>"
    fi
  elif [ "${BATTERY}" -ge 10 ] && [ "${BATTERY}" -lt 20 ]; then # if battery is >= 10% and < 20%
    if [[ $(file -b "${ICON_ARRAY[2]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[2]}</img>"
    fi
  elif [ "${BATTERY}" -ge 20 ] && [ "${BATTERY}" -lt 30 ]; then # if battery is >= 20% and < 30%
    if [[ $(file -b "${ICON_ARRAY[3]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[3]}</img>"
    fi
  elif [ "${BATTERY}" -ge 30 ] && [ "${BATTERY}" -lt 40 ]; then # if battery is >= 30% and < 40%
    if [[ $(file -b "${ICON_ARRAY[4]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[4]}</img>"
    fi
  elif [ "${BATTERY}" -ge 40 ] && [ "${BATTERY}" -lt 50 ]; then # if battery is >= 40% and < 50%
    if [[ $(file -b "${ICON_ARRAY[5]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[5]}</img>"
    fi
  elif [ "${BATTERY}" -ge 50 ] && [ "${BATTERY}" -lt 60 ]; then # if battery is >= 50% and < 60%
    if [[ $(file -b "${ICON_ARRAY[6]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[6]}</img>"
    fi
  elif [ "${BATTERY}" -ge 60 ] && [ "${BATTERY}" -lt 70 ]; then # if battery is >= 60% and < 70%
    if [[ $(file -b "${ICON_ARRAY[7]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[7]}</img>"
    fi
  elif [ "${BATTERY}" -ge 70 ] && [ "${BATTERY}" -lt 80 ]; then # if battery is >= 70% and < 80%
    if [[ $(file -b "${ICON_ARRAY[8]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[8]}</img>"
    fi
  elif [ "${BATTERY}" -ge 80 ] && [ "${BATTERY}" -lt 90 ]; then # if battery is >= 80% and < 90%
    if [[ $(file -b "${ICON_ARRAY[9]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[9]}</img>"
    fi
  elif [ "${BATTERY}" -ge 90 ] && [ "${BATTERY}" -lt 100 ]; then # if battery is >= 90% and < 100%
    if [[ $(file -b "${ICON_ARRAY[10]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[10]}</img>"
    fi
  elif [ "${BATTERY}" -eq 100 ]; then # if battery is fully charged
    if [[ $(file -b "${ICON_ARRAY[11]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[11]}</img>"
    fi
  fi
elif acpi -a | grep -i "on-line" &> /dev/null; then # if AC adapter is online
  if [ "${BATTERY}" -lt 15 ]; then # if battery is less than 15%
    if [[ $(file -b "${ICON_ARRAY[12]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[12]}</img>"
    fi
  elif [ "${BATTERY}" -ge 15 ] && [ "${BATTERY}" -lt 30 ]; then # if battery is >= 15% and < 30%
    if [[ $(file -b "${ICON_ARRAY[13]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[13]}</img>"
    fi
  elif [ "${BATTERY}" -ge 30 ] && [ "${BATTERY}" -lt 55 ]; then # if battery is >= 30% and < 55%
    if [[ $(file -b "${ICON_ARRAY[14]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[14]}</img>"
    fi
  elif [ "${BATTERY}" -ge 55 ] && [ "${BATTERY}" -lt 70 ]; then # if battery is >= 55% and < 70%
    if [[ $(file -b "${ICON_ARRAY[15]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[15]}</img>"
    fi
  elif [ "${BATTERY}" -ge 70 ] && [ "${BATTERY}" -lt 85 ]; then # if battery is >= 60% and < 85%
    if [[ $(file -b "${ICON_ARRAY[16]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[16]}</img>"
    fi
  elif [ "${BATTERY}" -ge 85 ] && [ "${BATTERY}" -lt 100 ]; then # if battery is >= 85% and < 100%
    if [[ $(file -b "${ICON_ARRAY[17]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[17]}</img>"
    fi
  elif [ "${BATTERY}" -eq 100 ]; then # if battery is fully charged
    if [[ $(file -b "${ICON_ARRAY[18]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
      INFO="<img>${ICON_ARRAY[18]}</img>"
    fi
  fi
else # if battery is in unknown state (no battery at all, throttling, etc.)
  if [[ $(file -b "${ICON_ARRAY[0]}") =~ PNG|SVG ]]; then # check if the icon exists and it is a .png or .svg image
    INFO="<img>${ICON_ARRAY[0]}</img>"
  fi
fi

if hash xfce4-power-manager-settings &> /dev/null; then
  INFO+="<click>xfce4-power-manager-settings</click>"
fi

INFO+="<txt>"
if acpi -a | grep -i "off-line" &> /dev/null; then # if AC adapter is offline
  if [ "${BATTERY}" -lt 10 ]; then # if battery is less than 10%
    INFO+="<span weight='Bold' fgcolor='White' bgcolor='Red'>" # make the text bold red
  else
    INFO+="<span weight='Regular' fgcolor='White'>" # make the text white
  fi
elif acpi -a | grep -i "on-line" &> /dev/null; then # if AC adapter is online
  INFO+="<span weight='Bold' fgcolor='Light Green'>" # make the text bold light green
else # if battery is in unknown state (no battery at all, throttling, etc.)
  INFO+="<span weight='Bold' fgcolor='Yellow'>" # make the text bold yellow
fi
INFO+="${BATTERY}%"
INFO+="</span>"
INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ ${MANUFACTURER} ${MODEL}\n"
MORE_INFO+="├─ Serial number: ${SERIAL_NUMBER}\n"
MORE_INFO+="├─ Technology: ${TECHNOLOGY}\n"
MORE_INFO+="├─ Temperature: +${TEMPERATURE}℃\n"
MORE_INFO+="├─ Energy: ${ENERGY} Wh\n"
MORE_INFO+="├─ Energy when full: ${ENERGY_FULL} Wh\n"
MORE_INFO+="├─ Energy (design): ${ENERGY_DESIGN} Wh\n"
MORE_INFO+="├─ Rate: ${RATE} W\n"
if acpi -a | grep -i "off-line" &> /dev/null; then # if AC adapter is offline
  if [ "${BATTERY}" -eq 100 ]; then # if battery is fully charged
    MORE_INFO+="└─ Voltage: ${VOLTAGE} V"
  else
    MORE_INFO+="└─ Remaining Time: ${TIME_UNTIL}"
  fi
elif acpi -a | grep -i "on-line" &> /dev/null; then # if AC adapter is online
  if [ "${BATTERY}" -eq 100 ]; then # if battery is fully charged
    MORE_INFO+="└─ Voltage: ${VOLTAGE} V"
  else
    MORE_INFO+="└─ Time to fully charge: ${TIME_UNTIL}"
  fi
else # if battery is in unknown state (no battery at all, throttling, etc.)
  MORE_INFO+="└─ Voltage: ${VOLTAGE} V"
fi
MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
