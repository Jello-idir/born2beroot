arch=$(uname -a)

cpu_physical=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)

virtual_cpus=$(grep "processor" /proc/cpuinfo | wc -l)

memory_usage=$(free --mega | grep "Mem:" | awk '{printf("%d/%dMB (%.2f%%)\n", $3, $2, $3*100/$2)}')

disk_usage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total += $2} {used += $3} END {printf("%dMB/%dMB (%.2f%%)\n", used, total, used * 100 / total)}')

cpu_load=$(mpstat 1 4 | awk 'END {print 100 - $NF"%"}')

last_boot=$(uptime -s | awk -F":" '{print $1":"$2}')

lvm_use=$(lsblk | grep -q lvm && echo "yes" || echo "no")

tcp_connections=$(ss -t | grep ESTAB | wc -l)

logged_users=$(who | awk '{print $1}' | sort -u | wc -l)

network_ip=$(hostname -I | awk '{print $1}')

mac_address=$(ip link | grep link/ether | awk '{print $2}')

sudo_commands=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall 	"
	#Architecture: $arch
	#CPU physical: $cpu_physical
	#vCPU: $virtual_cpus
	#Memory Usage: $memory_usage
	#Disk Usage: $disk_usage
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm_use
	#Connections TCP: $tcp_connections ESTABLISHED
	#User log: $logged_users
	#Network: IP $network_ip ($mac_address)
	#Sudo: $sudo_commands cmd"
