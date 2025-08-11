# Ensure required tools are present
package { ['sshpass','openssh-client']:
  ensure => installed,
}

# Configure NTP servers on a Cisco IOS device (single SSH, idempotent)
define cisco::ntp(
  String        $ip,
  Array[String] $servers,
) {
  # Build device-side commands
  $ntp_cmds      = $servers.map |$s| { "ntp server ${s}" }.join(' ; ')
  $servers_str   = join($servers, '|')
  $servers_count = length($servers)
  $ntp_regex     = "^ntp server (${servers_str})$"

  # Keep shell env vars literal
  $d = '$'

  # SSH command templates with legacy algos allowed (helps older IOS/IOS-XE)
  $ssh_opts = '-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa'
  $ssh_tty  = "sshpass -p \"${d}CISCO_PASS\" ssh -tt ${ssh_opts} \"${d}CISCO_USER@${ip}\""
  $ssh      = "sshpass -p \"${d}CISCO_PASS\" ssh     ${ssh_opts} \"${d}CISCO_USER@${ip}\""

  # Apply in one session
  $apply_cmd = "${$ssh_tty} \"enable ; ${d}ENABLE_PASS ; conf t ; ${ntp_cmds} ; end ; write memory\""

  # Idempotence guard: all desired NTP server lines must exist
  $guard_cmd = "${$ssh} \"show running-config\" | awk '/^ntp server /{print \\$0}' | grep -E '${ntp_regex}' | sort -u | wc -l | grep -q '^${servers_count}$'"

  exec { "ntp_${ip}":
    command   => $apply_cmd,
    unless    => $guard_cmd,
    path      => ['/usr/bin','/bin'],
    timeout   => 180,
    logoutput => 'on_failure',
    require   => Package['sshpass','openssh-client'],
  }
}

# -----------------------------
# Apply to all your Cisco boxes
# -----------------------------
$ntp_servers = ['129.6.15.28','129.6.15.29']

cisco::ntp_only { 'mgmt-rtr': ip => '10.10.10.1', servers => $ntp_servers }
cisco::ntp_only { 'reg-rtr':  ip => '10.10.10.2', servers => $ntp_servers }
cisco::ntp_only { 'ham-rtr':  ip => '10.10.10.3', servers => $ntp_servers }
cisco::ntp_only { 'mid-rtr':  ip => '10.10.10.4', servers => $ntp_servers }
cisco::ntp_only { 'mgmt-sw':  ip => '10.10.10.5', servers => $ntp_servers }
cisco::ntp_only { 'ham-sw':   ip => '10.10.10.6', servers => $ntp_servers }
cisco::ntp_only { 'mid-sw':   ip => '10.10.10.7', servers => $ntp_servers }
