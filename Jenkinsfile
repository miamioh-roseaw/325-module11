pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          sudo apt-get update
          sudo apt-get install -y wget gnupg
          wget https://apt.puppet.com/puppet7-release-focal.deb
          sudo dpkg -i puppet7-release-focal.deb
          sudo apt-get update
          sudo apt-get install -y puppet-agent
        '''
      }
    }

    stage('Run Puppet Banner Config') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'cisco-ssh-creds',
            usernameVariable: 'CISCO_USER',
            passwordVariable: 'CISCO_PASS'
          )
        ]) {
          sh '''
            echo "[INFO] Running Puppet manifest..."
            export ENABLE_PASS="$CISCO_PASS"

            # Substitute environment variables into manifest template
            envsubst < set_banner_template.pp > set_banner.pp

            # Apply the final manifest
            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
