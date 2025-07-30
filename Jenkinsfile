pipeline {
  agent any

  stages {
    stage('Run Puppet Banner Config') {
      steps {
        echo "[INFO] Running Puppet manifest..."

        withCredentials([
          usernamePassword(
            credentialsId: 'cisco-ssh-creds',
            usernameVariable: 'CISCO_USER',
            passwordVariable: 'CISCO_PASS'
          )
        ]) {
          sh '''
            export PATH=/opt/puppetlabs/bin:$PATH
            echo "[INFO] Executing Puppet manifest..."
            puppet apply set_banner.pp --logdest console --execute "
              class { 'cisco_banner':
                cisco_user  => '${CISCO_USER}',
                cisco_pass  => '${CISCO_PASS}',
                enable_pass => '${CISCO_PASS}',
              }"
          '''
        }
      }
    }
  }
}
