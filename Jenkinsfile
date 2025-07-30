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
          wget https://apt.puppet.com/puppet7-release-focal.deb -O puppet-release.deb
          sudo dpkg -i puppet-release.deb
          sudo apt-get update
          sudo apt-get install -y puppet-agent
        '''
      }
    }

    stage('Run Puppet Banner Config') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS'),
          string(credentialsId: 'cisco-enable-pass', variable: 'ENABLE_PASS')
        ]) {
          sh '''
            echo "[INFO] Running Puppet manifest..."
            puppet apply set_banner.pp --logdest console \
              --execute " \$cisco_user='${CISCO_USER}' \$cisco_pass='${CISCO_PASS}' \$enable_pass='${ENABLE_PASS}' include cisco_banner"
          '''
        }
      }
    }
  }
}
