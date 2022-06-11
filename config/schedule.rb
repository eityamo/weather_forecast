# makes Rails.root as well as other environment specific Rails.application.config values available
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# In Rails, to get log file into the logs directory you can use
set :output, "#{Rails.root}/log/cron.log"

set :job_template, "/bin/zsh -l -c ':job'"
job_type :rake,
         'source /Users/eityamo/.zshrc; export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; cd /Users/eityamo/Proj/weather_forecast && RAILS_ENV=production bundle exec rake twitter:tweet'

# 1日ごとに動かす
every 1.day, at: ['6:00 pm', '10:00 pm'] do
  rake 'twitter:tweet'
end
