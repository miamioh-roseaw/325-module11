package { ['sshpass','openssh-client']: ensure => installed }

define cisco::ntp(
  String        $ip,
  Array[String] $servers,
) {
  $ntp_cmds = $servers.map |$s| { "ntp server ${s}" }.join(' ; ')
  $d = '$'

  $ssh_opts = '-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa'
  $ssh_tty  = "sshpass -p \"${d}CISCO_PASS\" ssh -tt ${ssh_opts} \"${d}CISCO_USER@${ip}\""
  $ssh      = "sshpass -p \"${d}CISCO_PASS\" ssh     ${ssh_opts} \"${d}CISCO_USER@${ip}\""

  # Build a guard that ONLY skips when *all* desired servers are present
  $per_server_checks = $servers.map |$s| { "${ssh} \"show running-config\" | grep -Fx \"ntp server ${s}\" >/dev/null" }
  $guard_cmd = $per_server_checks.join(' && ')

  exec { "ntp_${ip}":
    command   => "${ssh_tty} \"enable ; ${d}ENABLE_PASS ; conf t ; ${ntp_cmds} ; end ; write memory\"",
    unless    => $guard_cmd,
    path      => ['/usr/bin','/bin'],
    timeout   => 180,
    logoutput => 'on_failure',
    require   => Package['sshpass','openssh-client'],
  }
}

# Apply to all devices
$ntp_servers = ['129.6.15.28','129.6.15.29']

cisco::ntp_only { 'mgmt-rtr': ip => '10.10.10.1', servers => $ntp_servers }
cisco::ntp_only { 'reg-rtr':  ip => '10.10.10.2', servers => $ntp_servers }
cisco::ntp_only { 'ham-rtr':  ip => '10.10.10.3', servers => $ntp_servers }
cisco::ntp_only { 'mid-rtr':  ip => '10.10.10.4', servers => $ntp_servers }
cisco::ntp_only { 'mgmt-sw':  ip => '10.10.10.5', servers => $ntp_servers }
cisco::ntp_only { 'ham-sw':   ip => '10.10.10.6', servers => $ntp_servers }
cisco::ntp_only { 'mid-sw':   ip => '10.10.10.7', servers => $ntp_servers }
