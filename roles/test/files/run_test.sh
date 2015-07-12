

PATH=/var/lib/jenkins/npm_global/bin:$PATH
npm install
npm install karma
npm install karma-coverage
npm install karma-jenkins-reporter
bower install
grunt test:e2e
