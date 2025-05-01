#compdef incusd

# _incusd
#
# Copyright (c) 2020 endaaman
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

_incusd() {
  _arguments -C \
    '1: :__incusd_commands' \
    '*: :__incusd_global_flags'
}


__incusd_global_flags() {
  local -a _c
  _c=(
    {-d,--debug}':Show all debug messages'
    '--group:The group of users that will be allowed to talk to incusd'
    {-h,--help}':Print help'
    '--logfile:Path to the log file'
    '--syslog:Log to syslog'
    '--trace:Log tracing targets'
  )
  _describe -o -t global_options 'Flags' _c
}



__incusd_commands() {
  local -a _c
  _c=(
  'activateifneeded:Check if incusd should be started'
  'cluster:Low-level cluster administration commands'
  'help:Help about any command'
  'import:Import existing containers'
  'init:Configure the incusd daemon'
  'shutdown:Tell incusd to shutdown all containers and exit'
  'version:Show the server version'
  'waitready:Wait for incusd to be ready to process requests'
  )
  _describe -t commands 'Commands' _c
}

compdef _incusd incusd
