# Ensure required tools are present (optional but handy)
package { ['sshpass','openssh-client']:
  ensure => installed,
}

# One-shot timezone + NTP (single SSH, idempotent)
define cisco::ntp_timezone(
  String         $ip,
  String         $zone,
  Integer        $offset_hours,
  Integer        $offset_minutes = 0,
  Array[String]  $servers,
) {
  # IOS commands we want to enforce
  $tz_cmd   = "clock timezone ${zone} ${offset_hours} ${offset_minutes}"
  $ntp_cmds = $servers.map |$s| { "ntp server ${s}" }.join(' ; ')
  # For idempotence: ensure ALL desired servers exist
  $ntp_regex = "^ntp server (${servers.join('|')})$"

  exec { "ntp_tz_${ip}":
    command => "sshpass -p \"\\$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no \"\\$CISCO_USER@${ip}\" \"enable ; \\$ENABLE_PASS ; conf t ; ${tz_cmd} ; ${ntp_cmds} ; end ; write memory\"",

    # Guard: require timezone line AND the exact count of desired NTP servers
    unless  => "sshpass -p \"\\$CISCO_PASS\" ssh -o StrictHostKeyChecking=no \"\\$CISCO_USER@${ip}\" \"terminal length 0 ; show running-config\" \
                | tee /dev/fd/3 3>&1 >/dev/null \
                | grep -F '${tz_cmd}' 3>&1 \
                && (sshpass -p \"\\$CISCO_PASS\" ssh -o StrictHostKeyChecking=no \"\\$CISCO_USER@${ip}\" \"show running-config\" \
                    | awk '/^ntp server /{print \\$0}' \
                    | grep -E '${ntp_regex}' \
                    | sort -u | wc -l | grep -q '^${servers.length}$')",

    path      => ['/usr/bin','/bin'],
    timeout   => 120,
    logoutput => 'on_failure',
    require   => Package['sshpass','openssh-client'],
  }
}

# --- Apply to all your Cisco devices ---

# Common NTP servers + timezone (adjust as needed)
$ntp_servers = ['129.6.15.28','129.6.15.29']  # NIST time, example
$tz_zone     = 'EST'
$tz_off_hr   = -5
$tz_off_min  = 0

cisco::ntp_timezone { 'mgmt-rtr':
  ip              => '10.10.10.1',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'reg-rtr':
  ip              => '10.10.10.2',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'ham-rtr':
  ip              => '10.10.10.3',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'mid-rtr':
  ip              => '10.10.10.4',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'mgmt-sw':
  ip              => '10.10.10.5',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'ham-sw':
  ip              => '10.10.10.6',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
cisco::ntp_timezone { 'mid-sw':
  ip              => '10.10.10.7',
  zone            => $tz_zone,
  offset_hours    => $tz_off_hr,
  offset_minutes  => $tz_off_min,
  servers         => $ntp_servers,
}
