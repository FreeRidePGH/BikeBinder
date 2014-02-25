#!/bin/bash
this_dir=`dirname $0`

unset GEM_HOME
unset GEM_PATH

export PATH=$HOME/.rvm/bin:$PATH
source ~/.rvm/scripts/rvm

# export PATH=~/.rbenv/bin:"$PATH"
# eval "$(~/.rbenv/bin/rbenv init -)"

err_log_file="${this_dir}/../log/dispatch_err.log"
exec bundle exec ruby "${this_dir}/dispatch_fcgi.rb" --debug "$@" 2>>"${err_log_file}"
