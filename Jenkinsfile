// Jenkins Declarative Pipeline to install Puppet Agent on the node
// and apply the NTP+Timezone manifest that targets all Cisco devices.
pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    // Adjust if your manifest lives elsewhere in the workspace:
    PUPPET_MANIFEST = "ntp_timezone.pp"
  }

  options {
    timestamps()
  }

  stages {
    stage('Install Puppet Agent') {
      steps {
        sh '''
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
        '''
      }
    }

    stage('Apply NTP + Timezone to Cisco Devices') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'cisco-ssh-creds',
            usernameVariable: 'CISCO_USER',
            passwordVariable: 'CISCO_PASS'
          )
          // If you keep a separate enable secret, add a Secret Text credential and uncomment:
          // ,string(credentialsId: 'cisco-enable-pass', variable: 'ENABLE_PASS')
        ]) {
          sh '''
            set -euxo pipefail
            echo "[INFO] Preparing environment variables for Puppet execs..."
            # Mirror ENABLE_PASS to the SSH password unless you provide a separate secret.
            : "${ENABLE_PASS:=$CISCO_PASS}"

            echo "[INFO] Running puppet apply on ${PUPPET_MANIFEST} ..."
            # --detailed-exitcodes: 0=no changes, 2=changes, 4/6=failures
            # Treat exit code 2 as success for CI.
            puppet apply "${PUPPET_MANIFEST}" --logdest console --detailed-exitcodes || ec=$?
            if [ "${ec:-0}" = "2" ] || [ "${ec:-0}" = "0" ]; then
              echo "[INFO] Puppet apply completed successfully (exit ${ec:-0})."
              exit 0
            else
              echo "[ERROR] Puppet apply failed (exit ${ec})."
              exit "${ec}"
            fi
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Build finished."
    }
  }
}
