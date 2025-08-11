# Ensure required tools are present (Debian/Ubuntu names)
package { ['sshpass','openssh-client']:
  ensure => installed,
}

# Configure timezone + NTP on a Cisco IOS device (single SSH, idempotent)
define cisco::ntp_timezone(
  String        $ip,
  String        $zone,
  Integer       $offset_hours,
  Integer       $offset_minutes = 0,
  Array[String] $servers,
) {
  # Commands we want on the device
  $tz_cmd          = "clock timezone ${zone} ${offset_hours} ${offset_minutes}"
  $ntp_cmds        = $servers.map |$s| { "ntp server ${s}" }.join(' ; ')

  # For the guard: build regex and expected count using Puppet functions
  $servers_str     = join($servers, '|')
  $servers_count   = length($servers)
  $ntp_regex       = "^ntp server (${servers_str})$"

  # SSH command templates (escape $ so Puppet doesn't interpolate shell vars)
  $ssh_tty = "sshpass -p \"\\$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no \"\\$CISCO_USER@${ip}\""
  $ssh     = "sshpass -p \"\\$CISCO_PASS\" ssh -o StrictHostKeyChecking=no \"\\$CISCO_USER@${ip}\""

  exec { "ntp_tz_${ip}":
    # Use the ENABLE_PASS exported by Jenkins. (If you mirror it from CISCO_PASS, that's fine.)
    command => "${$ssh_tty} \"enable ; \\$ENABLE_PASS ; conf t ; ${tz_cmd} ; ${ntp_cmds} ; end ; write memory\"",

    # Idempotence guard:
    # 1) timezone line present
    # 2) number of desired NTP server lines present equals $servers_count
    unless  => "${$ssh} \"terminal length 0 ; show running-config\" | grep -F '${tz_cmd}' >/dev/null \
                && ${$ssh} \"show running-config\" \
                   | awk '/^ntp server /{print \\$0}' \
                   | grep -E '${ntp_regex}' \
                   | sort -u | wc -l | grep -q '^${servers_count}$'",

    path      => ['/usr/bin','/bin'],
    timeout   => 180,
    logoutput => 'on_failure',
    require   => Package['sshpass','openssh-client'],
  }
}

# -----------------------------
# Apply to all your Cisco boxes
# -----------------------------
$ntp_servers = ['129.6.15.28','129.6.15.29']  # adjust as needed
$tz_zone     = 'EST'
$tz_off_hr   = -5
$tz_off_min  = 0

cisco::ntp_timezone { 'mgmt-rtr':
  ip             => '10.10.10.1',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'reg-rtr':
  ip             => '10.10.10.2',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'ham-rtr':
  ip             => '10.10.10.3',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'mid-rtr':
  ip             => '10.10.10.4',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'mgmt-sw':
  ip             => '10.10.10.5',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'ham-sw':
  ip             => '10.10.10.6',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
cisco::ntp_timezone { 'mid-sw':
  ip             => '10.10.10.7',
  zone           => $tz_zone,
  offset_hours   => $tz_off_hr,
  offset_minutes => $tz_off_min,
  servers        => $ntp_servers,
}
