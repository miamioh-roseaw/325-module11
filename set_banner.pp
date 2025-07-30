class cisco_banner (
  String $cisco_user = Deferred('environment', ['CISCO_USER']),
  String $cisco_pass = Deferred('environment', ['CISCO_PASS']),
  String $enable_pass = Deferred('environment', ['CISCO_PASS']),
) {

  $devices = ['10.10.10.1', '10.10.10.2', '10.10.10.3', '10.10.10.4', '10.10.10.5', '10.10.10.6', '10.10.10.7']

  $devices.each |String $device| {
    exec { "set_banner_${device}":
      command => "sshpass -p '${cisco_pass}' ssh -o StrictHostKeyChecking=no ${cisco_user}@${device} 'enable ; conf t ; banner motd ^Welcome to ${device}^ ; write memory'",
      path    => ['/usr/bin', '/bin'],
    }
  }
}

include cisco_banner
