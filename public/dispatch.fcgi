#!/bin/bash
this_dir=`dirname $0`
config_path=`readlink -f ${this_dir}/../config/`
log_path=`readlink -f ${this_dir}/../log/`

unset GEM_HOME
unset GEM_PATH

export PATH=$HOME/.rvm/bin:$PATH
source ~/.rvm/scripts/rvm

# export PATH=~/.rbenv/bin:"$PATH"
# eval "$(~/.rbenv/bin/rbenv init -)"

err_log_file="${log_path}/dispatch_err.log"
exec bundle exec ruby "${config_path}/dispatch_fcgi.rb" "$@" 2>>"${err_log_file}"
