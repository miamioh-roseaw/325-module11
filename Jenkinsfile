// Jenkins Declarative Pipeline to apply the NTP-add Puppet manifest
pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    PUPPET_MANIFEST = "ntp_add.pp"   // <- path to the .pp you committed
  }

  options { timestamps() }

  stages {
    stage('Install Puppet Agent (if needed)') {
      steps {
        sh '''
          bash -lc '
            set -eux
            if ! command -v puppet >/dev/null 2>&1; then
              sudo apt-get update
              sudo apt-get install -y wget gnupg
              wget -q https://apt.puppet.com/puppet7-release-focal.deb
              sudo dpkg -i puppet7-release-focal.deb
              sudo apt-get update
              sudo apt-get install -y puppet-agent
            fi
            puppet --version
          '
        '''
      }
    }
    stage('Pre-Check NTP (all devices)') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds',
                                          usernameVariable: 'CISCO_USER',
                                          passwordVariable: 'CISCO_PASS')]) {
          sh '''
            bash -lc '
              set -u
              : "${ENABLE_PASS:=$CISCO_PASS}"
    
              IPS=(10.10.10.1 10.10.10.2 10.10.10.3 10.10.10.4 10.10.10.5 10.10.10.6 10.10.10.7)
              SSH_OPTS="-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa"
              OUT="ntp_before.txt"
              : > "$OUT"
    
              for ip in "${IPS[@]}"; do
                echo "===== ${ip} (before) =====" | tee -a "$OUT"
                sshpass -p "$CISCO_PASS" ssh $SSH_OPTS "$CISCO_USER@$ip" \
                  "show running-config | include ^ntp server" \
                  2>&1 | tee -a "$OUT" || true
                echo | tee -a "$OUT"
              done
    
              echo "[INFO] Saved pre-check to $OUT"
            '
          '''
        }
      }
    }
    stage('Apply NTP to Cisco Devices') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'cisco-ssh-creds',
            usernameVariable: 'CISCO_USER',
            passwordVariable: 'CISCO_PASS'
          )
        ]) {
          sh '''
            bash -lc '
              set -eux
              # Use same secret for enable unless you store a separate one
              : "${ENABLE_PASS:=$CISCO_PASS}"

              echo "[INFO] Applying ${PUPPET_MANIFEST} ..."
              puppet apply "${PUPPET_MANIFEST}" --logdest console --detailed-exitcodes || ec=$?
              if [ "${ec:-0}" = "0" ] || [ "${ec:-0}" = "2" ]; then
                echo "[INFO] Puppet apply succeeded (exit ${ec:-0})."
                exit 0
              else
                echo "[ERROR] Puppet apply failed (exit ${ec})."
                exit "${ec}"
              fi
            '
          '''
        }
      }
    }
    stage('Post-Check NTP (all devices)') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds',
                                          usernameVariable: 'CISCO_USER',
                                          passwordVariable: 'CISCO_PASS')]) {
          sh '''
            bash -lc '
              set -u
              : "${ENABLE_PASS:=$CISCO_PASS}"
    
              IPS=(10.10.10.1 10.10.10.2 10.10.10.3 10.10.10.4 10.10.10.5 10.10.10.6 10.10.10.7)
              SSH_OPTS="-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa"
              OUT="ntp_after.txt"
              : > "$OUT"
    
              for ip in "${IPS[@]}"; do
                echo "===== ${ip} (after) =====" | tee -a "$OUT"
                sshpass -p "$CISCO_PASS" ssh $SSH_OPTS "$CISCO_USER@$ip" \
                  "show running-config | include ^ntp server" \
                  2>&1 | tee -a "$OUT" || true
                echo | tee -a "$OUT"
              done
    
              echo "[INFO] Saved post-check to $OUT"
            '
          '''
        }
      }
}
  }

  post {
    always { echo "Build finished." }
  }
}
