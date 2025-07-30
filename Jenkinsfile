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
            echo "[INFO] Templating Puppet manifest with credentials..."
            envsubst < set_banner_template.pp > set_banner.pp

            echo "[INFO] Applying Puppet manifest..."
            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
