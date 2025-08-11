#  Credentials come from env vars
# (CISCO_USER, CISCO_PASS, ENABLE_PASS) made available by Jenkins.

# Ensure required tools exist (optional but handy)
package { ['sshpass','openssh-client']:
  ensure => installed,
}

define cisco::banner($ip, $banner) {
  exec { "set_banner_${ip}":
    command => "sshpass -p '${CISCO_PASS}' ssh -o StrictHostKeyChecking=no ${CISCO_USER}@${ip} 'enable ; ${ENABLE_PASS} ; conf t ; banner motd ^${banner}^ ; end ; write memory'",

    # Skip if the desired text is already present
    unless  => "sshpass -p '${CISCO_PASS}' ssh -o StrictHostKeyChecking=no ${CISCO_USER}@${ip} \"show run | i banner motd\" | grep -F \"${banner}\"",

    path    => ['/usr/bin','/bin'],
    timeout => 120,
    # Reduce log noise; show command output on failure
    logoutput => 'on_failure',
    require => Package['sshpass','openssh-client'],
  }
}

# Declare your devices here (short and obvious)
cisco::banner { '10.10.10.1':
  ip     => '10.10.10.1',
  banner => 'Welcome to 10.10.10.1, configured by puppet.',
}

cisco::banner { '10.10.10.2':
  ip     => '10.10.10.2',
  banner => 'Welcome to 10.10.10.2, configured by puppet.',
}
