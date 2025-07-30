class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
  String $enable_pass,
) {

  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4', '10.10.10.5', '10.10.10.6', '10.10.10.7']

  $devices.each |String $device| {
    exec { "set_banner_${device}":
      command => "sshpass -p ${cisco_pass} ssh -o StrictHostKeyChecking=no ${cisco_user}@${device} 'enable ; conf t ; banner motd ^Welcome to ${device}^ ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

# Declare and execute the class with Jenkins-injected credentials
class { 'cisco_banner':
  cisco_user  => $ENV['CISCO_USER'],
  cisco_pass  => $ENV['CISCO_PASS'],
  enable_pass => $ENV['ENABLE_PASS'],
}
