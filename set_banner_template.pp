class cisco_banner {

  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4', '10.10.10.5', '10.10.10.6', '10.10.10.7']

  $devices.each |String $device| {
    exec { "set_banner_${device}":
      command => "sshpass -p '${CISCO_PASS}' ssh -o StrictHostKeyChecking=no ${CISCO_USER}@${device} 'enable ; ${ENABLE_PASS} ; conf t ; banner motd ^Welcome to ${device}^ ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

include cisco_banner
