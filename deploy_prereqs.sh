#!/bin/bash

check_if_installed(){
    type -P $1 &>/dev/null || { echo "Double check that $1 is installed" >&2; return 1; }
}

echo "Checking Production Deploymet Requirements..."

# Used by capistrano to 
# deploy new instances
check_if_installed git

# We are using Ruby on Rails
check_if_installed ruby

# User solutions must run in SELinux
# sandbox policy. Fedora 13 has one.
check_if_installed sandbox

# Dependencies installed view gem
check_if_installed gem

# We use ruby on rails
check_if_installed rails

# Gem dependencies by bundler
check_if_installed bundle

# User solutions are compiled
# with a C compiler.
check_if_installed gcc

# Deploy via apache
check_if_installed apachectl

# Database
check_if_installed mysql

# Used to kill delayed_job daemon
# when deploying.
check_if_installed pidof
check_if_installed kill

# Used to highlight syntax solution code
check_if_installed pygmentize

# Wget is used by the recomendation engine startup scrip
check_if_installed wget

# Java is used by the recomendation server
check_if_installed java

# Leinegin is used for the Clojure project managment
check_if_installed lein
