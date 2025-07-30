pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }

  stages {
    stage('Run Puppet Banner Config') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: 'cisco-ssh-creds', usernameVariable: 'CISCO_USER', passwordVariable: 'CISCO_PASS'),
          string(credentialsId: 'cisco-enable-pass', variable: 'ENABLE_PASS')
        ]) {
          sh '''
            echo "[INFO] Running Puppet manifest..."
            export CISCO_USER=$CISCO_USER
            export CISCO_PASS=$CISCO_PASS
            export ENABLE_PASS=$ENABLE_PASS
            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
