exec { 'set_banner_10.10.10.1':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no \"$CISCO_USER@10.10.10.1\" \"enable ; $ENABLE_PASS ; conf t ; banner motd ^Welcome to 10.10.10.1, configured by puppet.^ ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'set_banner_10.10.10.2':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no \"$CISCO_USER@10.10.10.2\" \"enable ; $ENABLE_PASS ; conf t ; banner motd ^Welcome to 10.10.10.2, configured by puppet.^ ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}
