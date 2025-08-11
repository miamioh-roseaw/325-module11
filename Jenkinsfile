// Jenkinsfile — runs the simple NTP-only Puppet manifest
pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    PUPPET_MANIFEST = "ntp_add.pp"  
  }

  options { timestamps() }

  stages {
    stage('Install Puppet (if needed)') {
      steps {
        sh '''
          bash -lc '
            set -eu
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

    stage('Apply NTP to Cisco devices') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'cisco-ssh-creds',
          usernameVariable: 'CISCO_USER',
          passwordVariable: 'CISCO_PASS',
          enableVariable: 'CISCO_PASS'
        )]) {
          sh '''
            bash -lc '
              set -eu

              echo "[INFO] Applying ${PUPPET_MANIFEST} ..."
              puppet apply "${PUPPET_MANIFEST}" --logdest console --detailed-exitcodes || ec=$?
              if [ "${ec:-0}" = "0" ] || [ "${ec:-0}" = "2" ]; then
                echo "[INFO] Puppet apply succeeded (exit ${ec:-0})."
              else
                echo "[ERROR] Puppet apply failed (exit ${ec})."
                exit "${ec}"
              fi
            '
          '''
        }
      }
    }
  }
stage('Verify banners removed') {
  steps {
    withCredentials([usernamePassword(
      credentialsId: 'cisco-ssh-creds',
      usernameVariable: 'CISCO_USER',
      passwordVariable: 'CISCO_PASS'
    )]) {
      sh '''
        bash -lc '
          set -eu
          : "${ENABLE_PASS:=$CISCO_PASS}"

          IPS=(10.10.10.1 10.10.10.2 10.10.10.3 10.10.10.4 10.10.10.5 10.10.10.6 10.10.10.7)
          SSH_OPTS="-o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa"
          OUT="banner_check.txt"
          : > "$OUT"
          FAIL=0

          for ip in "${IPS[@]}"; do
            echo "===== ${ip} (banner check) =====" | tee -a "$OUT"
            # Look for any banner commands present in running config
            if sshpass -p "$CISCO_PASS" ssh $SSH_OPTS "$CISCO_USER@$ip" \
                 "show running-config | include ^banner\\s+(login|motd|exec|incoming)" \
                 | tee -a "$OUT" | grep -q . ; then
              echo "[WARN] Banner lines found on ${ip}" | tee -a "$OUT"
              FAIL=1
            else
              echo "OK: no banner lines on ${ip}" | tee -a "$OUT"
            fi
            echo | tee -a "$OUT"
          done

          echo "[INFO] Saved banner check to $OUT"
          exit $FAIL
        '
      '''
    }
  }
}
  post {
    always { echo "Build finished." }
  }
}
