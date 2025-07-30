class cisco_banner (
  String $cisco_user,
  String $cisco_pass,
) {

  notify { "Setting banner with user ${cisco_user}":
  }

  exec { 'set-banner':
    command => "sshpass -p '${cisco_pass}' ssh -o StrictHostKeyChecking=no ${cisco_user}@10.10.10.1 'conf t ; banner motd ^Authorized Access Only^'",
    path    => ['/usr/bin', '/bin'],
  }

}
include cisco_banner
