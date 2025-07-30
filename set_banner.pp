class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
) {
  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4',
              '10.10.10.5', '10.10.10.6', '10.10.10.7']

  $devices.each |$ip| {
    exec { "set_banner_${ip}":
      command => "sshpass -p '${cisco_pass}' ssh -o StrictHostKeyChecking=no ${cisco_user}@${ip} 'conf t ; banner motd ^Welcome to ${ip}^ ; end ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

# Apply the class with passed-in values
class { 'cisco_banner':
  cisco_user => $::cisco_user,
  cisco_pass => $::cisco_pass,
}
