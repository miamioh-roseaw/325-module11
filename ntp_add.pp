# ------------------------------------------------------------------------------
# Puppet manifest to remove banners and set NTP servers on Cisco devices.
# HOW TO MODIFY COMMANDS:
#   - Edit ONLY the lines inside the HEREDOC (<<'EOF' ... EOF) below.
#   - Each Cisco command is on its own line — keep "\n" automatically handled.
#   - Do NOT remove:
#       terminal length 0
#       enable
#       $ENABLE_PASS
#       conf t
#       end
#       write memory
#       exit
#   - You can add/remove other Cisco CLI commands between "conf t" and "end".
#   - $ENABLE_PASS and $CISCO_PASS come from Jenkins credentials injection.
# ------------------------------------------------------------------------------

package { ['sshpass','openssh-client']:
  ensure => installed,
}

# List of target Cisco device IPs
$device_ips = [
  '10.10.10.1', # mgmt-rtr
  '10.10.10.2', # reg-rtr
  '10.10.10.3', # ham-rtr
  '10.10.10.4', # mid-rtr
  '10.10.10.5', # mgmt-sw
  '10.10.10.6', # ham-sw
  '10.10.10.7', # mid-sw
]

# Cisco CLI commands to run on each device
$cmds = @("EOF")
terminal length 0
enable
$ENABLE_PASS
conf t
no banner login
no banner motd
no banner exec
no banner incoming
ntp server 129.6.15.28
ntp server 129.6.15.29
end
write memory
exit
EOF

# Apply commands to each device in the list
$device_ips.each |$ip| {
  exec { "cfg_${ip}":
    command => "printf \"%s\\n\" ${cmds} | sshpass -p \\\"$CISCO_PASS\\\" ssh -tt \
      -o ConnectTimeout=20 \
      -o ServerAliveInterval=5 -o ServerAliveCountMax=3 \
      -o StrictHostKeyChecking=no \
      -o KexAlgorithms=+diffie-hellman-group1-sha1 \
      -o HostKeyAlgorithms=+ssh-rsa \
      \\\"$CISCO_USER@${ip}\\\"",
    path    => ['/usr/bin','/bin'],
    timeout => 180,
    require => Package['sshpass','openssh-client'],
  }
}
