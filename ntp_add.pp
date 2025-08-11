# Minimal looped manifest: remove banners + set two NTP servers on all devices.
# Edit only the $payload_lines array (one Cisco command per element, end each with \n).

package { ['sshpass','openssh-client']: ensure => installed }

# Target devices
$device_ips = ['10.10.10.1','10.10.10.2','10.10.10.3','10.10.10.4','10.10.10.5','10.10.10.6','10.10.10.7']

# Literal dollar so shell env vars (e.g., $CISCO_PASS) stay literal for the shell
$d = '$'

# --- Commands to run (one per line; keep \n at the end of each string) ---
$payload_lines = [
  "terminal length 0\\n",
  "enable\\n",
  "${d}ENABLE_PASS\\n",
  "conf t\\n",
  "no banner login\\n",
  "no banner motd\\n",
  "no banner exec\\n",
  "no banner incoming\\n",
  "ntp server 129.6.15.28\\n",
  "ntp server 129.6.15.29\\n",
  "end\\n",
  "write memory\\n",
  "exit\\n",
]
$payload = join($payload_lines, '')  # single multiline string

# SSH options (allow legacy algos for older IOS)
$ssh_opts = '-o ConnectTimeout=20 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa'

# Apply to each device
$device_ips.each |$ip| {
  exec { "cfg_${ip}":
    # printf "%b" interprets \n into real newlines
    command => "printf \"%b\" \"${payload}\" | sshpass -p \"${d}CISCO_PASS\" ssh -tt ${ssh_opts} \"${d}CISCO_USER@${ip}\"",
    path    => ['/usr/bin','/bin'],
    timeout => 180,
    require => Package['sshpass','openssh-client'],
  }
}
