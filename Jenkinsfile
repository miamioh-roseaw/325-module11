pipeline {
  agent any

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          wget https://apt.puppet.com/puppet7-release-focal.deb -O puppet-release.deb
          sudo dpkg -i puppet-release.deb
          sudo apt-get update
          sudo apt-get install -y puppet-agent sshpass
        '''
      }
    }

    stage('Run Puppet Manifest') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS')]) {
          sh '''
            echo "[INFO] Running Puppet manifest..."
            export PATH=/opt/puppetlabs/bin:$PATH
            export FACTER_cisco_user=$CISCO_USER
            export FACTER_cisco_pass=$CISCO_PASS

            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
