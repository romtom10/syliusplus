#!/bin/bash

set -e

IS_MIGRATED=0
su www-data -s /bin/bash -c 'php ./bin/console doctrine:migrations:status | grep "Already at latest version"' || IS_MIGRATED=$?

echo IS_MIGRATED=$IS_MIGRATED

if [ $IS_MIGRATED -ne 0 ]; then
  echo FIRST DEPLOYMENT, RUNNING AUTOMATED INSTALL
   su www-data -s /bin/sh -c '
    set -e
    ls -la /var/www/html/var/cache
    rm -rf /var/www/html/var/cache/*
    mkdir -p /var/www/html/public/media/image
    bin/console sylius:install -s plus -n
    cp -fr vendor/sylius/plus/src/Resources/templates/bundles/* templates/bundles
    mkdir -p /var/www/html/templates/bundles/SyliusRefundPlugin
    mkdir -p /var/www/html/templates/bundles/SyliusUiBundle
    yarn install
    yarn build
    bin/console assets:install --ansi --symlink --relative public
    bin/console cache:clear
    bin/console cache:warmup
  '
else
  echo MIGRATIONS DETECTED, SKIPPING AUTOMATED INSTALL
fi
