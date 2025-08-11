# Assumes Jenkins exports: CISCO_USER, CISCO_PASS, ENABLE_PASS
# (If enable == ssh password, just set: export ENABLE_PASS="$CISCO_PASS")

exec { 'ntp_10.10.10.1':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.1\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.2':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.2\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.3':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.3\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.4':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.4\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.5':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.5\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.6':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.6\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}

exec { 'ntp_10.10.10.7':
  command => "sshpass -p \"$CISCO_PASS\" ssh -tt -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa \"$CISCO_USER@10.10.10.7\" \"enable ; $ENABLE_PASS ; conf t ; no ntp server 129.6.15.28 ; ntp server 129.6.15.28 ; no ntp server 129.6.15.29 ; ntp server 129.6.15.29 ; end ; write memory\"",
  path    => ['/usr/bin','/bin'],
}
