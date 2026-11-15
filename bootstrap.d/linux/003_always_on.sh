#!/bin/sh
## Keep the machine always on and reachable (24/7 laptop on AC, battery as UPS)
##
## - Masks every sleep target (no suspend/hibernate, whatever triggers it)
## - logind ignores lid close, suspend/hibernate keys and idle
## - Disables Wi-Fi power saving (avoids SSH timeouts on an idle link)
## - UPower powers off cleanly on critical battery instead of sleeping
## - Ensures the SSH server is enabled
##
## Idempotent: safe to re-run. Revert with:
##   sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
##   sudo rm /etc/systemd/logind.conf.d/always-on.conf /etc/NetworkManager/conf.d/99-wifi-powersave-off.conf

set -eu

SLEEP_TARGETS="sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target"
LOGIND_CONF=/etc/systemd/logind.conf.d/always-on.conf
NM_CONF=/etc/NetworkManager/conf.d/99-wifi-powersave-off.conf
UPOWER_CONF=/etc/UPower/UPower.conf

echo "==> Masking sleep targets"
# shellcheck disable=SC2086
sudo systemctl mask $SLEEP_TARGETS

echo "==> Configuring logind (lid, keys, idle)"
sudo mkdir -p "$(dirname "$LOGIND_CONF")"
sudo tee "$LOGIND_CONF" >/dev/null <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
HandleSuspendKey=ignore
HandleHibernateKey=ignore
IdleAction=ignore
EOF
echo "    (applied at next reboot — restarting logind would kill the desktop session)"

echo "==> Disabling Wi-Fi power saving"
sudo apt-get install -qy iw >/dev/null
sudo tee "$NM_CONF" >/dev/null <<'EOF'
[connection]
wifi.powersave = 2
EOF
sudo systemctl reload NetworkManager
# Apply immediately on every wireless interface, without reconnecting
for dev in /sys/class/net/*/wireless; do
	[ -e "$dev" ] || continue
	iface=$(basename "$(dirname "$dev")")
	sudo iw dev "$iface" set power_save off
done

echo "==> Critical battery action: PowerOff"
if [ -f "$UPOWER_CONF" ]; then
	sudo sed -i 's/^CriticalPowerAction=.*/CriticalPowerAction=PowerOff/' "$UPOWER_CONF"
	sudo systemctl restart upower
fi

echo "==> Enabling SSH server"
sudo apt-get install -qy openssh-server >/dev/null
sudo systemctl enable --now ssh

echo
echo "==> Verification"
fail=0
check() {
	label=$1
	shift
	if "$@" >/dev/null 2>&1; then
		echo "  [ok]   $label"
	else
		echo "  [FAIL] $label"
		fail=1
	fi
}

for t in $SLEEP_TARGETS; do
	check "$t masked" sh -c "systemctl is-enabled $t 2>/dev/null | grep -qx masked"
done
check "logind drop-in present" test -f "$LOGIND_CONF"
for dev in /sys/class/net/*/wireless; do
	[ -e "$dev" ] || continue
	iface=$(basename "$(dirname "$dev")")
	check "Wi-Fi power save off on $iface" sh -c "iw dev $iface get power_save | grep -q off"
done
check "UPower CriticalPowerAction=PowerOff" grep -qx 'CriticalPowerAction=PowerOff' "$UPOWER_CONF"
check "ssh active" systemctl is-active --quiet ssh
check "ssh enabled at boot" systemctl is-enabled --quiet ssh

if [ -r /sys/class/power_supply/BAT0/charge_control_end_threshold ]; then
	echo "  [info] battery charge thresholds: $(cat /sys/class/power_supply/BAT0/charge_control_start_threshold)-$(cat /sys/class/power_supply/BAT0/charge_control_end_threshold)%"
fi

exit $fail
