class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
  String $enable_pass,
) {
  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4',
              '10.10.10.5', '10.10.10.6', '10.10.10.7']

  $devices.each |$ip| {
    exec { "set_banner_${ip}":
      command => "sshpass -p '${cisco_pass}' ssh -tt -o KexAlgorithms=+diffie-hellman-group14-sha1,diffie-hellman-group1-sha1 -o StrictHostKeyChecking=no ${cisco_user}@${ip} 'enable ; ${enable_pass} ; conf t ; banner motd ^Welcome to ${ip}^ ; end ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

class { 'cisco_banner':
  cisco_user   => $::cisco_user,
  cisco_pass   => $::cisco_pass,
  enable_pass  => $::enable_pass,
}
