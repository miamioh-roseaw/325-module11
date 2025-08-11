# Ensure required tools are present
package { ['sshpass','openssh-client']:
  ensure => installed,
}

# Timezone + NTP in one SSH session (idempotent)
define cisco::ntp_timezone(
  String        $ip,
  String        $zone,
  Integer       $offset_hours,
  Integer       $offset_minutes = 0,
  Array[String] $servers,
) {
  # Build device-side commands
  $tz_cmd        = "clock timezone ${zone} ${offset_hours} ${offset_minutes}"
  $ntp_cmds      = $servers.map |$s| { "ntp server ${s}" }.join(' ; ')
  $servers_str   = join($servers, '|')
  $servers_count = length($servers)
  $ntp_regex     = "^ntp server (${servers_str})$"

  # Command strings (single-quoted templates => $CISCO_* remain literal),
  # Puppet variables are inserted via sprintf placeholders.
  $ssh_tty = sprintf('sshpass -p "$CISCO_PASS" ssh -tt -o StrictHostKeyChecking=no "$CISCO_USER@%s"', $ip)
  $ssh     = sprintf('sshpass -p "$CISCO_PASS" ssh -o StrictHostKeyChecking=no "$CISCO_USER@%s"',     $ip)

  $apply_cmd = sprintf('%s "enable ; $ENABLE_PASS ; conf t ; %s ; %s ; end ; write memory"',
                       $ssh_tty, $tz_cmd, $ntp_cmds)

  $guard_cmd = sprintf('%s "terminal length 0 ; show running-config" | grep -F %s >/dev/null && ' +
                       '%s "show running-config" | awk \'/^ntp server /{print $0}\' | grep -E %s | sort -u | wc -l | grep -q "^%d"$',
                       $ssh, shellquote($tz_cmd), $ssh, shellquote($ntp_regex), $servers_count)

  exec { "ntp_tz_${ip}":
    command   => $apply_cmd,
    unless    => $guard_cmd,
    path      => ['/usr/bin','/bin'],
    timeout   => 180,
    logoutput => 'on_failure',
    require   => Package['sshpass','openssh-client'],
  }
}

# ------------ Apply to all devices ------------
$ntp_servers = ['129.6.15.28','129.6.15.29']
$tz_zone     = 'EST'
$tz_off_hr   = -5
$tz_off_min  = 0

cisco::ntp_timezone { 'mgmt-rtr':
  ip => '10.10.10.1', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'reg-rtr':
  ip => '10.10.10.2', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'ham-rtr':
  ip => '10.10.10.3', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'mid-rtr':
  ip => '10.10.10.4', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'mgmt-sw':
  ip => '10.10.10.5', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'ham-sw':
  ip => '10.10.10.6', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
cisco::ntp_timezone { 'mid-sw':
  ip => '10.10.10.7', zone => $tz_zone, offset_hours => $tz_off_hr, offset_minutes => $tz_off_min, servers => $ntp_servers,
}
