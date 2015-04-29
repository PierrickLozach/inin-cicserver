. Download Jenkins
. Install Java
. Go to http://localhost:8080
. Install Git plugin
. Install Authorize plugin (https://wiki.jenkins-ci.org/display/JENKINS/Authorize+Project+plugin)
. Install Categorize Jobs View plugin
. Install Warnings plugin
. Make the jenkins user an admin (sudo dseditgroup -o edit -a jenkins -t user admin)
. Add your user to the jenkins group (sudo dseditgroup -o edit -a <username> -t user jenkins)
. sudo gem install puppet-lint