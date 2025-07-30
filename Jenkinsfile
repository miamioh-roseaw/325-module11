pipeline {
  agent any

  environment {
    CISCO_CREDS = credentials('cisco-ssh-creds')
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
          export PATH=/opt/puppetlabs/bin:$PATH
          puppet --version
        '''
      }
    }

    stage('Run Puppet Manifest') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS')]) {
          sh '''
            echo "[INFO] Exporting PATH and credentials..."
            export PATH=/opt/puppetlabs/bin:$PATH
            export CISCO_USER=$CISCO_USER
            export CISCO_PASS=$CISCO_PASS

            echo "[INFO] Running Puppet manifest..."
            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
