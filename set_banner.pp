# set_banner.pp

$devices = {
  'mgmt-rtr' => '10.10.10.1',
  'reg-rtr'  => '10.10.10.2',
  'ham-rtr'  => '10.10.10.3',
  'mid-rtr'  => '10.10.10.4',
  'mgmt-sw'  => '10.10.10.5',
  'ham-sw'   => '10.10.10.6',
  'mid-sw'   => '10.10.10.7',
}

# Credentials (can be overridden by environment variables in Jenkins)
$ssh_user = $ENV['CISCO_USER']
$ssh_pass = $ENV['CISCO_PASS']

# Banner message
$banner_message = 'Welcome to Cisco device - Authorized Users Only!'

$devices.each |$name, $ip| {
  exec { "set_banner_${name}":
    command   => "sshpass -p '${ssh_pass}' ssh -o StrictHostKeyChecking=no ${ssh_user}@${ip} 'conf t ; banner motd ^${banner_message}^ ; end ; write mem'",
    path      => ['/bin', '/usr/bin'],
    unless    => "sshpass -p '${ssh_pass}' ssh -o StrictHostKeyChecking=no ${ssh_user}@${ip} 'show run | include banner'",
    logoutput => true,
  }
}
