# Ensure required tools are present
package { ['sshpass','openssh-client']:
  ensure => installed,
}

# Configure NTP servers on a Cisco IOS device (idempotent, per-server enforcement)
define cisco::ntp_add(
  String        $ip,
  Array[String] $servers,
) {
  # Build device-side commands
  $enforce_cmds = $servers.map |$s| { "no ntp server ${s} ; ntp server ${s}" }.join(' ; ')

  # Keep shell env vars literal
  $d = '$'

  # SSH command templates with legacy algos allowed (older IOS)
  $ssh_opts = '-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa'
  $ssh_tty  = "sshpass -p \"${d}CISCO_PASS\" ssh -tt ${ssh_opts} \"${d}CISCO_USER@${ip}\""
  $ssh      = "sshpass -p \"${d}CISCO_PASS\" ssh     ${ssh_opts} \"${d}CISCO_USER@${ip}\""

  # Guard: skip only when EVERY desired server is present exactly
  $per_server_checks = $servers.map |$s| { "${ssh} \"show running-config\" | grep -Fx \"ntp server ${s}\" >/dev/null" }
  $guard_cmd = $per_server_checks.join(' && ')

  exec { "ntp_${ip}":
    command   => "${ssh_tty} \"enable ; ${d}ENABLE_PASS ; conf t ; ${enforce_cmds} ; end ; write memory\"",
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

cisco::ntp_add { 'mgmt-rtr': ip => '10.10.10.1', servers => $ntp_servers }
cisco::ntp_add { 'reg-rtr':  ip => '10.10.10.2', servers => $ntp_servers }
cisco::ntp_add { 'ham-rtr':  ip => '10.10.10.3', servers => $ntp_servers }
cisco::ntp_add { 'mid-rtr':  ip => '10.10.10.4', servers => $ntp_servers }
cisco::ntp_add { 'mgmt-sw':  ip => '10.10.10.5', servers => $ntp_servers }
cisco::ntp_add { 'ham-sw':   ip => '10.10.10.6', servers => $ntp_servers }
cisco::ntp_add { 'mid-sw':   ip => '10.10.10.7', servers => $ntp_servers }
