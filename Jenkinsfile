pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    PUPPET_MANIFEST = "manifests/ntp_timezone.pp"
  }

  options { timestamps() }

  stages {
    stage('Install Puppet Agent') {
      steps {
        sh '''
          bash -lc '
            set -euxo pipefail
            echo "[INFO] Installing Puppet Agent (if needed)..."
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

    stage('Apply NTP + Timezone to Cisco Devices') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'cisco-ssh-creds',
                           usernameVariable: 'CISCO_USER',
                           passwordVariable: 'CISCO_PASS')
          // If you have a separate enable secret, add it:
          // , string(credentialsId: 'cisco-enable-pass', variable: 'ENABLE_PASS')
        ]) {
          sh '''
            bash -lc '
              set -euxo pipefail

              # Mirror ENABLE_PASS to SSH pass unless a separate one is provided
              : "${ENABLE_PASS:=$CISCO_PASS}"

              echo "[INFO] Running puppet apply on ${PUPPET_MANIFEST} ..."
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
  }

  post {
    always { echo "Build finished." }
  }
}
