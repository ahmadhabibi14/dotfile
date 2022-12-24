#!/usr/bin/env bash
# Dependencies: bash>=3.2, bleachbit(optional), coreutils, file, gawk)

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/disk/folder.svg"

# Command to grab current HDD's temperature
# Change --unit to F if you don't want Celsius as default
GET_TEMP=$(sudo hddtemp --unit=C --wake-up --quiet --numeric /dev/sda)

# To determine if colors are applied
OVERHEAT=0

# Panel
#if hash bleachbit &> /dev/null; then
#  INFO="<click>bleachbit &> /dev/null</click>"
#fi

if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO+="<img>${ICON}</img>"
#  if hash xfce4-taskmanager &> /dev/null; then
#    INFO+="<click>xfce4-taskmanager</click>"
#  fi
  INFO+="<txt>"
else
  INFO+="<txt>"
fi

 [[ "${GET_TEMP}" -gt 42 ]] && \
 OVERHEAT=1 && \
    INFO+="<span weight='Bold' fgcolor='#FF5D5D'>"

INFO+=" $(awk '{$1 = $1 / 1048576; printf "%.2f", $1}' <<< $(df / | awk '/\/dev/{print $3}'))"
# INFO+="／"
# INFO+="$(awk '{$1 = $1 / 1048576; printf "%.2f", $1}' <<< $(df / | awk '/\/dev/{print $2}'))"
INFO+=" GB"

# Close span tag if warning colors are applied
[[ "${OVERHEAT}" -eq 1 ]] && \
  INFO+="</span>"

INFO+=" </txt> "

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ $(df -h / | awk '/\/dev/{print $1}' | head -n1)\n"
MORE_INFO+="├─ Vendor:\t\t$(awk '/[V]endor:/{print $2}' /proc/scsi/scsi)\n"
MORE_INFO+="├─ Model:\t\t$(awk '/[Mm]odel:/{print $4, $5}' /proc/scsi/scsi)\n"
MORE_INFO+="├─ Revision:\t\t$(awk '/[Rr]ev:/{print $7}' /proc/scsi/scsi)\n"
MORE_INFO+="├─ Type:\t\t\t$(awk '/[Tt]ype:/{print $2, $3, $4}' /proc/scsi/scsi)\n"

############# !!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!! ####################
# Append the following line to /etc/sudoers (Recommended: edit with visudo)
# %wheel ALL=(ALL) NOPASSWD: /usr/bin/hddtemp
# If you don't do the above, xfce4-panel will freeze and
# eventually will freeze X too. So, be careful!
MORE_INFO+="└─ Temperature:\t${GET_TEMP} ℃"

MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
