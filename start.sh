sudo service network-manager stop
sudo dmesg -c
clear
yes | rm wpa.log

exec_path=$(readlink -f <where is the wpa_supplicant?>)
data_path=$(readlink -f ./)
tmp_path=$(readlink -f /tmp)

exec=$exec_path/wpa_supplicant

wlan0_conf=$data_path/wlan0.conf
p2p_conf=$data_path/p2p.conf
log_file=$data_path/wpa.log
global_ctrl=$tmp_path/wpa_global
entropy_file=$tmp_path/entropy.bin

echo "Killing all wpa_supplicants"
sudo killall wpa_supplicant
sleep 2

echo "Running wpa_supplicant=$exec"
echo "wlan0 conf=$wlan0_conf"
echo "p2p conf=$p2p_conf"
echo "global control interface=$global_ctrl"

cmd="$exec -Dnl80211 -iwlan0 -c$wlan0_conf -m$p2p_conf -g$global_ctrl -G adm -e$entropy_file -pp2p_device=1 -Bddt -f $log_file"

echo
echo "Running $cmd"
echo
sudo $cmd || exit 1

#Use of of the following
# First option to be a P2P-GO - Activate be default
# Second option to be P2P-Dev (Role will be decided).

echo "Creating a group, This is a P2P-GO"
sudo wpa_cli -g$global_ctrl p2p_group_add
sudo wpa_cli -g$global_ctrl IFNAME=p2p-wlan0-0 wps_pbc any

#sudo wpa_cli -g$global_ctrl

