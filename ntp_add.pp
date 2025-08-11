# Minimal looped manifest: remove banners + set two NTP servers on all devices.
# Edit the commands in $payload only (between the START/END markers).

package { ['sshpass','openssh-client']: ensure => installed }

# List of target devices
$device_ips = ['10.10.10.1','10.10.10.2','10.10.10.3','10.10.10.4','10.10.10.5','10.10.10.6','10.10.10.7']

# Literal dollar for shell env vars ($CISCO_PASS, $CISCO_USER, $ENABLE_PASS)
$d = '$'

# === START EDIT: Cisco CLI you want to run (one command per line) ===
$payload = "terminal length 0\\n"         +
           "enable\\n"                     +
           "${d}ENABLE_PASS\\n"            +
           "conf t\\n"                     +
           "no banner login\\n"            +
           "no banner motd\\n"             +
           "no banner exec\\n"             +
           "no banner incoming\\n"         +
           "ntp server 129.6.15.28\\n"     +
           "ntp server 129.6.15.29\\n"     +
           "end\\n"                        +
           "write memory\\n"               +
           "exit\\n"
# === END EDIT ===

# SSH options (allow legacy algos for older IOS)
$ssh_opts = '-o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa'

$device_ips.each |$ip| {
  exec { "cfg_${ip}":
    command => "printf \"${payload}\" | sshpass -p \"${d}CISCO_PASS\" ssh -tt ${ssh_opts} \"${d}CISCO_USER@${ip}\"",
    path    => ['/usr/bin','/bin'],
    timeout => 180,
    require => Package['sshpass','openssh-client'],
  }
}
