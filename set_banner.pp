class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
  String $enable_pass,
) {

  $devices = [
    '10.10.10.1',
    '10.10.10.2',
    '10.10.10.3',
    '10.10.10.4',
    '10.10.10.5',
    '10.10.10.6',
    '10.10.10.7',
  ]

  $devices.each |$ip| {
    exec { "set_banner_${ip}":
      command => "sshpass -p '${cisco_pass}' ssh -o StrictHostKeyChecking=no ${cisco_user}@${ip} 'conf t ; enable ; banner motd ^Welcome to ${ip}!^ ; end ; write memory'",
      path    => ['/bin', '/usr/bin'],
    }
  }
}

include cisco_banner
