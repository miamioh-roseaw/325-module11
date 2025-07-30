pipeline {
  agent any

  environment {
    PUPPET_MANIFEST = 'set_banner.pp'
    CISCO_CREDS = credentials('cisco-ssh-creds')
    CISCO_USER = "${CISCO_CREDS_USR}"
    CISCO_PASS = "${CISCO_CREDS_PSW}"
    PUPPET_PATH = "/opt/puppetlabs/bin"
  }

  stages {

    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Checking if Puppet is installed..."
          if ! /opt/puppetlabs/bin/puppet --version > /dev/null 2>&1; then
            echo "[INFO] Installing Puppet..."
            wget https://apt.puppet.com/puppet7-release-focal.deb -O puppet7.deb
            sudo dpkg -i puppet7.deb
            sudo apt-get update
            sudo apt-get install -y puppet-agent
          else
            echo "[INFO] Puppet is already installed."
          fi
        '''
      }
    }

    stage('Run Puppet Banner Config') {
      steps {
        echo "[INFO] Running Puppet Manifest to set Cisco banners..."

        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS')]) {
          sh '''
            export PATH=/opt/puppetlabs/bin:$PATH
            echo "[INFO] Executing Puppet manifest..."
            puppet apply set_banner.pp
          '''
        }
      }
    }
  }

  post {
    always {
      echo '[INFO] Puppet job complete.'
    }
  }
}
