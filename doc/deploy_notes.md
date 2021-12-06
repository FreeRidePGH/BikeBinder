# Installing gem depencies on Ubuntu 20.04
  * Removed the Gemfile.lock file and ran
    ```
    gem install bundler -v 1.17.3
    sudo apt install libfcgi libfcgi-dev libmysqlclient-dev libsqlite3-dev
    bundle _1.17.3_ install
    ```
  * Fixed a number of dependency issues on the newer version of ruby by updating gems by minor version updates.
# Deploy
  * Install updated ruby with rvm then install bundler on the server
    ```
    rvm install 2.6.9
    rvm use 2.6.9 --default
    ~/.rvm/bin/rvm default do gem install bundler:1.17.3
    ```
  * Deploy to staging
    ```
    bundle _1.17.3_ exec cap staging deploy
    ```
