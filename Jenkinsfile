// Jenkins Declarative Pipeline that installs Puppet Agent on the build node
// and applies a Puppet manifest (rendered from a template using env vars).
pipeline {
  // Run on any available agent/worker. If you have a specific label (e.g., "ubuntu"),
  // replace `any` with: agent { label 'ubuntu' }
  agent any

  // Ensure the Puppet bin directory is in PATH so `puppet` is found without absolute paths.
  environment {
    // PATH is set for all `sh` steps below (and any tools they spawn).
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }

  stages {

    stage('Install Puppet') {
      steps {
        // Install Puppet Agent on the Jenkins agent at runtime.
        // This assumes a Debian/Ubuntu-based agent (uses apt, .deb).
        sh '''
          set -e
          echo "[INFO] Installing Puppet..."

          # Refresh package metadata; install prerequisites for adding Puppet repo
          sudo apt-get update
          sudo apt-get install -y wget gnupg

          # Add the Puppet APT repo by installing the release package for Ubuntu 20.04 (focal).
          # NOTE: If your agent OS is not focal, use the matching release package for your distro.
          wget https://apt.puppet.com/puppet7-release-focal.deb

          # Register the Puppet repository (adds the apt source + GPG keys).
          sudo dpkg -i puppet7-release-focal.deb

          # Update again so apt can see the newly added Puppet repo.
          sudo apt-get update

          # Install the Puppet Agent binaries (puts puppet at /opt/puppetlabs/bin/puppet).
          sudo apt-get install -y puppet-agent
        '''
      }
    }

    stage('Run Puppet Banner Config') {
      steps {
        // Pull Cisco SSH credentials from Jenkins Credentials store at runtime.
        // - credentialsId: the ID you created under Jenkins -> Manage Credentials
        // - usernameVariable/passwordVariable: environment variable names to expose to the shell
        withCredentials([
          usernamePassword(
            credentialsId: 'cisco-ssh-creds',
            usernameVariable: 'CISCO_USER',
            passwordVariable: 'CISCO_PASS'
          )
        ]) {
          // Render the Puppet manifest from a template using environment variables,
          // then apply it with `puppet apply`.
          sh '''
            set -e
            echo "[INFO] Running Puppet manifest..."

            # Some manifests/execs may expect an enable/privileged password separate from the SSH pass.
            # Here we simply mirror the Cisco password into ENABLE_PASS for templating convenience.
            export ENABLE_PASS="$CISCO_PASS"

            # Render the manifest from a template:
            # - set_banner_template.pp should reference variables like ${CISCO_USER} and ${ENABLE_PASS}
            # - envsubst substitutes ${VAR} tokens from the current shell environment
            #   (envsubst is typically provided by the "gettext-base" package on Debian/Ubuntu)
            envsubst < set_banner_template.pp > set_banner.pp

            # Apply the rendered manifest locally on this agent.
            # --logdest console ensures logs stream into the Jenkins build log.
            puppet apply set_banner.pp --logdest console
          '''
        }
      }
    }
  }
}
