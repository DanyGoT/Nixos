# Date in ISO format with time
date_formatted=$(date +'%Y-%m-%d %a %H:%M')

# Battery information
battery_path="/sys/class/power_supply/BAT1"
battery_capacity=$(cat "$battery_path/capacity")
battery_state=$(cat "$battery_path/status")  # Full, Charging, Discharging, etc.

# Wifi
INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes')
SSID=$(echo $INFO | cut -d: -f2)
SIGNAL=$(echo $INFO | cut -d: -f3)

# Choose emoji based on battery status
case $battery_state in
    "Charging") emoji="⚡" ;;
    "Discharging") emoji="🔋" ;;
    "Full") emoji="🔌" ;;
    *) emoji="❓" ;;
esac

# Display output
echo "WiFi: $SSID ($SIGNAL%) | $emoji $battery_capacity% ($battery_state) | $date_formatted"
