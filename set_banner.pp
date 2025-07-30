class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
  String $enable_pass,
) {

  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4']

  $devices.each |String $device| {
    exec { "set_banner_${device}":
      command => "sshpass -p ${cisco_pass} ssh -o StrictHostKeyChecking=no ${cisco_user}@${device} 'conf t ; banner motd ^Welcome to ${device}^ ; enable ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

include cisco_banner
