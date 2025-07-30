pipeline {
  agent any

  environment {
    SUDO_PASS = credentials('jenkins-sudo-creds')
  }

  stages {
    stage('Install Puppet') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'jenkins-sudo-creds', passwordVariable: 'SUDO_PASS', usernameVariable: 'SUDO_USER')]) {
          sh '''
            echo "[INFO] Installing Puppet..."
            echo "$SUDO_PASS" | sudo -S apt-get update
            echo "$SUDO_PASS" | sudo -S apt-get install -y wget gnupg
            wget https://apt.puppet.com/puppet7-release-focal.deb
            echo "$SUDO_PASS" | sudo -S dpkg -i puppet7-release-focal.deb
            echo "$SUDO_PASS" | sudo -S apt-get update
            echo "$SUDO_PASS" | sudo -S apt-get install -y puppet-agent
            echo "export PATH=\"/opt/puppetlabs/bin:$PATH\"" >> ~/.bashrc
            export PATH="/opt/puppetlabs/bin:$PATH"
          '''
        }
      }
    }

    stage('Run Puppet Manifest') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS')]) {
          sh '''
            echo "[INFO] Applying Puppet Manifest to configure banner..."
            export PATH="/opt/puppetlabs/bin:$PATH"
            FACTER_cisco_user=$CISCO_USER FACTER_cisco_pass=$CISCO_PASS puppet apply set_banner.pp
          '''
        }
      }
    }
  }
}
