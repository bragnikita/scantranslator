#!/usr/bin/env bash
BASE='/home/ec2-user/service-app'
APP="$BASE/current"
SHARED="$BASE/shared"

cd ${APP}
[ -e "shared" ] && rm -rf shared
[ -e "tmp" ] && rm -rf tmp
[ -e "public/uploads" ] && rm -rf public/uploads
[ -e "log" ] && rm -rf log
[ -e "config/secrets.yml" ] && rm -rf config/secrets.yml

cd ${BASE}
[ ! -e "$APP/node_modules" ] && ln -s ${SHARED}/node_modules ${APP}
ln -s $SHARED/shared ${APP}
ln -s $SHARED/tmp ${APP}
ln -s $SHARED/public/uploads ${APP}/public
ln -s $SHARED/log ${APP}
ln -s $SHARED/shared/secrets.yml ${APP}/config/secrets.yml

[ -e "puma_proc.out" ] && rm "puma_proc.out"

cd ${APP}
export RAILS_ENV=production
export NODE_ENV=production

bundle install
rake db:migrate
rake assets:precompile

nohup bundle exec puma > "${BASE}/puma_proc.out" 2>&1 &