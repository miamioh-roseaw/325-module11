exec { 'cfg_10.10.10.1':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.1"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.2':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.2"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.3':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.3"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.4':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.4"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.5':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.5"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.6':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.6"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}

exec { 'cfg_10.10.10.7':
  command => 'printf "terminal length 0\nenable\n$ENABLE_PASS\nconf t\nno banner login\nno banner motd\nno banner exec\nno banner incoming\nno ntp server 129.6.15.28\nntp server 129.6.15.28\nno ntp server 129.6.15.29\nntp server 129.6.15.29\nend\nwrite memory\nexit\n" | sshpass -p "$CISCO_PASS" ssh -tt -o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa "$CISCO_USER@10.10.10.7"',
  path    => ['/usr/bin','/bin'],
  timeout => 180,
}
