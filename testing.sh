#!/bin/sh

CURRENT=$(pwd)
PROJECT=$1

output() {
  color="32"
  if [ "$2" = 1 ]; then
    color="31"
  fi
  printf "\033[${color}m"
  echo $1
  printf "\033[0m"
}

git clone https://github.com/bcit-ci/CodeIgniter.git ci
sed -i.bak -e "s/\.\.\//\.\/ci/g" docker-compose.yml
output "Start container."
docker-compose -p ${PROJECT} build
docker-compose -p ${PROJECT} up -d
output "Testing CodeIgniter Web Site."
curl -L http://127.0.0.1 > /dev/null
output "Switch codeigniter stable branch."
docker-compose -p ${PROJECT} run workspace git checkout remotes/origin/3.0-stable
output "Install phpunit command."
docker-compose -p ${PROJECT} run workspace composer require phpunit/phpunit:~4.0 --dev --prefer-dist
output "Download ci-phpunit-test tool."
docker-compose -p ${PROJECT} run workspace composer require kenjis/ci-phpunit-test --dev --prefer-dist
output "Install ci-phpunit-test folder."
docker-compose -p ${PROJECT} run workspace php vendor/kenjis/ci-phpunit-test/install.php
output "Testing CodeIgniter php unit test."
docker-compose -p ${PROJECT} run workspace sh -c "cd application/tests && /var/www/codeigniter/vendor/bin/phpunit"

[ $? -eq 0 ] && output "✨ ✨ ✨ OK - Test done."
[ $? -eq 0 ] || (output "✨ ✨ ✨ Error - Test fail." 1 && exit 1)

# stop all container
docker-compose -p ci down
