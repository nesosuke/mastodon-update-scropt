#!/bin/bash
#mastodon-update-script 
#wrote by nesosuke

### 
### Run on only your responsibilitity. 
###

### Conf values 
export $(cat ~/access_token)
SKIP_POST_DEPLOYMENT_MIGRATIONS=true

### Def. func toot ###
#function toot () { curl -X POST -d "access_token=$ACCESS_TOKEN&status=$1" -Ss https://$DOMAIN/api/v1/statuses ; }

### Update pkg(s) 
cd ~/live 
sudo apt update -y 
sudo apt upgrade -y 
cd ~/.rbenv/plugins/ruby-build && git pull && cd -
gem update --system
gem install bundler 
bundle install 
yarn install 

### Migrate  
RAILS_ENV=production bundle exec rails assets:clobber 
RAILS_ENV=production bundle exec rails db:migrate 

sudo systemctl restart mastodon-*.service 

### Precompile
RAILS_ENV=production bundle exec rails assets:precompile 
RAILS_ENV=production bundle exec rails db:migrate  

### Restart mastodon-*.service ###
sudo systemctl restart mastodon-*.service nginx




# EOF
