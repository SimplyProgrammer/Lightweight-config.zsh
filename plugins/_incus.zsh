#compdef incus

# _incus
#
# Copyright (c) 2017 endaaman
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

_incus() {
  local context curcontext=$curcontext state line
  local selected_container
  declare -A opt_args

  local opt_container_control=(
    '--all[Run command against all containers]' \
    '--stateful[Store the container state (only for stop)]' \
    '--stateless[Ignore the container state (only for start)]' \
  )

  _arguments -C \
    '--all[Print less common commands]' \
    '--version[Show client version]' \
    '1: :__incus_commands' \
    '*:: :->args'
  case $state in
    (args)
      case $words[1] in
        (alias)
          case $words[2] in
            (remove|rename)
              _arguments -C \
                '2:containers:__incus_aliases'
            ;;
          esac
          _arguments -C \
            '1: :__incus_alias_commands'
        ;;
        (cluster)
          _arguments -C \
            '1: :__incus_cluster_commands'
        ;;
        (config)
          case $words[2] in
            (get)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (set)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (unset)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (show)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (edit)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (metadata)
              case $words[3] in
                (show)
                  _arguments -C \
                    '3:containers:__incus_containers_all'
                ;;
                (edit)
                  _arguments -C \
                    '3:containers:__incus_containers_all'
                ;;
              esac
              _arguments -C \
                '2: :__incus_config_metadata_commands'
            ;;
            (template)
              case $words[3] in
                (list)
                  _arguments -C \
                    '3:containers:__incus_containers_all'
                ;;
                (show|edit|delete)
                  if [ $#words[@] -gt 4 ]; then
                    _arguments -C \
                      "*:Templates:($(__get_incus_templates_by_container $words[4]))"
                  fi
                  _arguments -C \
                    '3:containers:__incus_containers_all'
                ;;
                (create)
                  _arguments -C \
                    '3:containers:__incus_containers_all'
                ;;
              esac
              _arguments -C \
                '2: :__incus_config_template_commands'
            ;;
            (device)
              case $words[3] in
                (add)
                  # incus config device add <container> <name> <type> <key1>=<value1>
                  #                   3   4           5      6
                  if [ $#words[@] -gt 6 ]; then
                    _arguments -C \
                      "*:key-values:_sep_parts '$(__get_incus_keys_by_device $words[6])' = '($(ls))'"
                  fi
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                    '4: :_files' \
                    '5:device type:__incus_device_types'
                ;;
                (get|unset)
                  if [ $#words[@] -eq 6 ]; then
                    local type=$(incus config device get $words[4] $words[5] type)
                    _arguments -C "*:key-values:($(__get_incus_keys_by_device $type))"
                  fi
                  selected_container=$words[4]
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                    '4:devices:__incus_devices_by_container' \
                ;;
                # incus config device set <container> <name> <key1>=<value1>
                #                   3   4           5      6
                (set)
                  if [ $#words[@] -eq 6 ]; then
                    local type=$(incus config device get $words[4] $words[5] type)
                    _arguments -C \
                      "*:key-values:_sep_parts '$(__get_incus_keys_by_device $type)' = ($(ls))" \
                      '7:files:_files'
                  fi
                  selected_container=$words[4]
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                    '4:devices:__incus_devices_by_container' \
                ;;
                (override)
                  if [ $#words[@] -gt 5 ]; then
                    local type=$(incus config device get $words[4] $words[5] type)
                    _arguments -C \
                      "*:key-values:_sep_parts '$(__get_incus_keys_by_device $type)' ="
                  fi
                  selected_container=$words[4]
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                    '4:devices:__incus_devices_by_container' \
                ;;
                (show|list)
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                ;;
                (remove)
                  selected_container=$words[4]
                  _arguments -C \
                    '3:containers:__incus_containers_all' \
                    '4:devices:__incus_devices_by_container' \
                ;;
              esac
              _arguments -C \
                '2: :__incus_config_device_commands'
            ;;
            (trust)
              _arguments -C \
                '2: :__incus_config_trust_commands'
              case $words[3] in
                (list|add|remove)
                  # complete remote
                  ;;
              esac
            ;;
          esac
          _arguments -C \
            '1: :__incus_config_commands' \
            '--expanded[Show the expanded configuration]'
        ;;
        (console)
          _arguments -C \
            '1:containers:__incus_containers_running'
        ;;
        (copy)
          _arguments -C \
            {-c,--config}'[Config key/value to apply to the new instance]' \
            {-d,--device}'[New key/value to apply to a specific device]' \
            {-e,--ephemeral}'[Ephemeral instance]' \
            '--instance-only[Copy the instance without its snapshots]' \
            '--mode[Transfer mode. One of pull (default), push or relay (default "pull")]' \
            '--no-rofiles[Create the instance with no profiles applied]' \
            {-p,--profile}'[Profile to apply to the new instance]' \
            '--refresh[Perform an incremental copy]' \
            '--stateless[Copy a stateful instance stateless]' \
            {-s,--storage}'[Storage pool name]' \
            '--target[Cluster member name]' \
            '--target-project[Copy to a project different from the source]'
        ;;
        (delete)
          _arguments -C \
            '*:containers:__incus_containers_stopped'
        ;;
        (exec)
          _arguments -C \
            '1:containers:__incus_containers_running' \
            '--cwd[Directory to run the command in (default /root)]' \
            {-n,--disable-stdin}'[Disable stdin (reads from /dev/null)]' \
            '--env[Environment variable to set (e.g. HOME=/home/foo)]' \
            {-t,--force-interactive}'[Force pseudo-terminal allocation]' \
            {-T,--force-noninteractive}'[Disable pseudo-terminal allocation]' \
            '--group[Group ID to run the command as (default 0)]' \
            '--mode[Override the terminal mode (auto, interactive or non-interactive) (default "auto")]' \
            '--user[User ID to run the command as (default 0)]'
        ;;
        (export)
          _arguments -C \
            '--compression[Define a compression algorithm: for backup or none]' \
            '--instance-only[Whether or not to only backup the instance (without snapshots)]' \
            '--optimized-storage[Use storage driver optimized format (can only be restored on a similar pool)]'
        ;;
        (file)
          case $words[2] in
            (push)
              _arguments -C \
                '2:files:_files' \
                '3:containers:__incus_containers_all'
            ;;
            (pull)
              _arguments -C \
                '2:containers:__incus_containers_all' \
                '3:files:_files'
            ;;
            (edit)
              _arguments -C \
                '2:containers:__incus_containers_all'
            ;;
            (delete)
              _arguments -C \
                '*:containers:__incus_containers_all'
            ;;
          esac
          _arguments -C \
            '1: :__incus_file_commands' \
            "--gid=[Set the file's gid on push]" \
            "--uid=[Set the file's uid on push]" \
            "--mode=[Set the file's perms on push]" \
            ''{-p,--create-dirs}'[Create any directories necessary]' \
            ''{-r,--recursive}'[Recursively push or pull files]'
        ;;
        (help)
          _arguments -C \
            '1: :__incus_commands'
        ;;
        (image)
          case $words[2] in
            (alias)
              case $words[3] in
                (create)
                  _arguments -C \
                    '4: :__incus_images_as_fingerprint'
                ;;
                (list)
                  _arguments -C \
                    '4: :()' \
                    '--format=[Format (csv|json|table|yaml) (default "table")]:Format:(csv json table yaml)'
                ;;
                (delete|rename)
                  _arguments -C \
                    '3: :__incus_images_as_alias'
                ;;
              esac
              _arguments -C \
                '2: :__incus_image_alias_commands'
            ;;
            (delete|refresh)
              _arguments -C \
                '*: :__incus_images_as_fingerprint'
            ;;
            (edit|show|info|export)
              _arguments -C \
                '2: :__incus_images_as_fingerprint'
            ;;
            (copy)
              _arguments -C \
                '2: :__incus_remotes'
            ;;
            (import)
              _arguments -C \
                '2: :_files'
            ;;
            (list)
              l="'Columns' 'l[Shortest image alias (and optionally number of other aliases)]' \
                'L[Newline-separated list of all image aliases]' 'f[Fingerprint]' \
                'p[Whether image is public]' 'd[Description]' 'a[Architecture]' \
                's[Size]' 'u[Upload date]'"
              _arguments -C \
                '3: :()' \
                {-c,--columns=}"[Columns (default lfpdasu)]:Columns:_values -s '' $l" \
                '--format=[Format (csv|json|table|yaml) (default "table")]:Format:(csv json table yaml)'
            ;;
          esac
          _arguments -C \
            '1: :__incus_image_commands'
        ;;
        (import)
          _arguments -C \
            '1: :_files' \
            {-s,--storage=}'[Storage pool name]'
        ;;
        (info)
          _arguments -C \
            '1:containers:__incus_containers_all' \
            '--resources[Show the resources available to the server]' \
            "--show-log[Show the container's last 100 log lines?]" \
            '--target[Cluster member name]'
        ;;
        (launch|init)
          _arguments -C \
            '1: :__incus_images' \
            {-c,--config=}'[Config key/value to apply to the new container (= map\[\])]' \
            '--console=[Immediately attach to the console]' \
            '--empty[Create an empty instance]' \
            {-e,--ephemeral}'[Ephemeral container]' \
            {-n,--network=}'[Network name]' \
            '--no-profiles[Create the instance with no profiles applied]' \
            {-p,--profile=}'[Profile to apply to the new container]' \
            {-s,--storage=}'[Storage pool name]' \
            '--target=[Node name]' \
            {-t,--type=}'[Instance type]' \
            '--vm[Create a virtual machine]'
        ;;
        (list)
          # c.f https://github.com/incus/lxd/blob/master/incus/list.go
          local _l="'Columns' '4[IPv4 address]' '6[IPv6 address]' 'a[Architecture]' 'b[Storage pool]' \
            'c[Creation date]' 'd[Description]' 'l[Last used date]' 'n[Name]' 'N[Number of Processes]' \
            \"p[PID of the container's init process]\" 'P[Profiles]' 's[State]' \
            'S[Number of snapshots]' 't[Type (persistent or ephemeral)]' \
            'L[Location of the container (e.g. its cluster member)]'"
          _arguments -C \
            {-c,--columns=}"[Columns (default: ns46tSL)]:Columns:_values -s '' $_l" \
            '--fast[Fast mode (same as --columns=nsacPt)]' \
            '--format=[Format (csv|json|table|yaml) (default "table")]:Format:(csv json table yaml)' \
            '--no-alias[Ignore aliases when determining what command to run]'
        ;;
        (manpage)
          _arguments -C \
            '1:Directory to put manpage to:_files'
        ;;
        (monitor)
          _arguments -C \
            '1: :__incus_containers_all' \
            '--loglevel=[Minimum level for log messages]:Log level:(info)' \
            '--pretty[Pretty rendering]' \
            '--type=[Event type to listen for]:Type:(lifecycle logging)'
        ;;
        (move)
          _arguments -C \
            {-c,--config}'[Config key/value to apply to the target instance]' \
            {-d,--device}'[New key/value to apply to a specific device]' \
            '--instance-only[Move the instance without its snapshots]' \
            '--mode{Transfer mode. One of pull (default), push or relay. (default "pull")}' \
            '--no-profiles[Unset all profiles on the target instance]' \
            {-p,--profile}'[Profile to apply to the target instance]' \
            --stateless'[Copy a stateful instance stateless]' \
            {-s,--storage}'[Storage pool name]' \
            '--target[Cluster member name]' \
            '--target-project[Copy to a project different from the source]'
        ;;
        (network)
          _arguments -C \
            '1: :__incus_network_commands'
        ;;
        (operation)
          # TODO: complete operation items
          _arguments -C \
            '1: :__incus_operation_commands'
        ;;
        (pause)
          _arguments -C \
            '1: :__incus_containers_running' \
            '--all[Run command against all containers]'
        ;;
        (project)
          case $words[2] in
            (edit|delete|switch|rename|show|get|set)
              _arguments -C \
                '2: :__incus_projects'
            ;;
            (list|ls)
              _arguments -C \
                '3: :()' \
                '--format=[Format (csv|json|table|yaml) (default "table")]:Format:(csv json table yaml)'
            ;;
          esac
          _arguments -C \
            '1: :__incus_project_commands'
        ;;
        (profile)
          case $words[2] in
            (add)
              _arguments -C \
                '2: :__incus_containers_all' \
                '3: :__incus_profiles' \
            ;;
            (assign|apply)
              _arguments -C \
                '2: :__incus_containers_all' \
                "3: :_values -s , Profiles $(__get_incus_profiles)"
            ;;
            (copy|cp)
              _arguments -C \
                '2: :__incus_profiles' \
                '3: :__incus_profiles'
            ;;
            (delete|rm|edit|show)
              _arguments -C \
                '2: :__incus_profiles'
            ;;
            (get|set|unset)
              # TODO: complete profile keys
              _arguments -C \
                '2: :__incus_profiles'
            ;;
            (list|ls)
              # TODO: complete container profiles
              _arguments -C \
                '2: :__incus_remotes'
            ;;
            (rename|mv)
              # TODO: complete container profiles
              _arguments -C \
                '2: :__incus_profiles'
            ;;
          esac
          _arguments -C \
            '1: :__incus_profile_commands'
        ;;
        (publish)
          # TODO: complete publish
          _arguments -C \
            '1: :__incus_containers_all'
        ;;
        (query)
          _arguments -C \
            {-d,--data}'[Input data]' \
            '--raw[Print the raw response]' \
            {-X,--request}'[Action (defaults to GET) (default "GET")]' \
            '--wait[Wait for the operation to complete]'
        ;;
        (remote)
          case $words[2] in
            (set-default|set-url|rename|remove)
              _arguments -C \
                '2: :__incus_remotes'
            ;;
            (add)
              _arguments -C \
                '2: :()' \
                '--accept-certificate[Accept certificate]' \
                '--auth-type=[Server authentication type (tls or macaroons)]:Auth type:(tls macaroons)' \
                '--password[Remote admin password]' \
                '--protocol=[Server protocol (lxd or simplestreams)]:Protocol:(tls macaroons)' \
                '--public[Public image server]'
            ;;
          esac
          _arguments -C \
            '1: :__incus_remote_commands'
        ;;
        (rename)
          _arguments -C \
            '1:containers:__incus_containers_stopped' \
        ;;
        (restart)
          _arguments -C \
            '*:containers:__incus_containers_running' \
            {-f,--force}'[Force the container to shutdown]' \
            '--timeout[Time to wait for the container before killing it]' \
            $opt_container_control
        ;;
        (restore)
          _arguments -C \
            '1:containers:__incus_containers_all' \
            '--stateful[Store the container state (only for stop)]'
        ;;
        (shell)
          _arguments -C \
            '1:containers:__incus_containers_running' \
            '--cwd[Directory to run the command in (default /root)]' \
            {-n,--disable-stdin}'[Disable stdin (reads from /dev/null)]' \
            '--env[Environment variable to set (e.g. HOME=/home/foo)]' \
            {-t,--force-interactive}'[Force pseudo-terminal allocation]' \
            {-T,--force-noninteractive}'[Disable pseudo-terminal allocation]' \
            '--group[Group ID to run the command as (default 0)]' \
            '--mode[Override the terminal mode (auto, interactive or non-interactive) (default "auto")]' \
            '--user[User ID to run the command as (default 0)]'
        ;;
        (snapshot)
          _arguments -C \
            '1:containers:__incus_containers_all'
        ;;
        (start)
          _arguments -C \
            '*:containers:__incus_containers_stopped' \
            $opt_container_control
        ;;
        (stop)
          _arguments -C \
            '*:containers:__incus_containers_running' \
            '--timeout[Time to wait for the container before killing it (= -1)]' \
            {-f,--force}'[Force the container to shutdown]' \
            $opt_container_control
        ;;
        (storage)
          case $words[2] in
            (delete|edit|get|info|set|unset)
              _arguments -C \
                '2: :__incus_storages'
            ;;
            (volume)
              case $words[3] in
                (list)
                  _arguments -C \
                    '3: :__incus_storages'
                ;;
              esac
              _arguments -C \
                '2: :__incus_storage_volume_commands'
            ;;
          esac
          _arguments -C \
            '1: :__incus_storage_commands'
        ;;
        (version)
          # nop
        ;;
      esac
    ;;
  esac
  _arguments -C -A '-*' \
    '*: :__incus_global_flags'
  return 0
}

__incus_global_flags() {
  local -a _l=(
    '--debug:Show all debug messages'
    '--force-local:Force using the local unix socket'
    {-h,--help}':Print help'
    '--project:Override the source project'
    {-q,--quiet}":Don't show progress information"
    {-v,--verbose}':Show all information messages'
    # '--version:Print version number'
  )
  _describe -o -t global_options 'global option' _l
}

__incus_commands() {
  local -a _l=(
    'alias:Manage command aliases'
    'cluster:Manage cluster nodes'
    'config:Change container or server configuration options'
    "console:Interact with the container's console device and log"
    'copy:Copy containers within or in between LXD instances'
    'delete:Delete containers and snapshots'
    'exec:Execute commands in containers'
    'export:Export instance backups'
    'file:Manage files in containers'
    'help:Help about any command'
    # 'finger:Check if the LXD server is alive' # old sub command
    'image:Manipulate container images'
    'import:Import instance backups'
    'info:Show container or server information'
    'init:Create containers from images'
    'launch:Create and start containers from images'
    'list:List the existing containers'
    'manpage:Generate all the LXD manpages'
    'monitor:Monitor a local or remote LXD server'
    'move:Move containers within or in between LXD instances'
    'network:Manage and attach containers to networks'
    'operation:List, show and delete background operations'
    'pause:Pause containers'
    'profile:Manage container configuration profiles'
    'project:Manage projects'
    'publish:Publish containers as images'
    'query:Send a raw query to LXD'
    'remote:Manage the list of remote LXD servers'
    'rename:Rename a container or snapshot'
    'restart:Restart containers'
    'restore:Restore containers from snapshots'
    'snapshot:Create container snapshots'
    'shell:Execute commands in instances'
    'start:Start containers'
    'stop:Stop containers'
    'storage:Manage storage pools and volumes'
    'version:Print the version number of this client tool'
  )
  _describe -t commands Commands _l
}

__incus_alias_commands() {
  local -a _l=(
    'add:Add a new alias <alias> pointing to <target>.'
    'remove:Remove the alias <alias>.'
    'list:List all the aliases.'
    'rename:Rename remote <old alias> to <new alias>.'
  )
  _describe -t commands 'Alias commands' _l
}

__incus_cluster_commands() {
  local -a _l=(
    'edit:Edit cluster member configurations as YAML'
    'enable:Enable clustering on a single non-clustered LXD server'
    'list:List all the cluster members'
    'remove:Remove a member from the cluster'
    'rename:Rename a cluster member'
    'show:Show details of a cluster member'
  )
  _describe -t commands 'Cluster commands' _l
}

__incus_config_commands() {
  local -a _l=(
    'get:Get container or server configuration key'
    'set:Set container or server configuration key'
    'unset:Unset container or server configuration key'
    'show:Show container or server configuration'
    'edit:Edit container or server configuration key'
    'metadata:Container metadata'
    'template:Container templates'
    'device:Device management'
    'trust:Client trust store management'
  )
  _describe -t commands 'Config commands' _l
}

__incus_config_device_commands() {
  local -a _l=(
    'add:Add a device to a container'
    'get:Get a device property'
    'set:Set a device property'
    'unset:Unset a device property'
    'override:Copy a profile inherited device into local container config'
    'list:List devices for container'
    'show:Show full device details for container'
    'remove:Remove device from container'
  )
  _describe -t commands 'Config device commands' _l
}


__incus_config_metadata_commands() {
  local -a _l
  _c=(
    'show:Show the container metadata.yaml content'
    'edit:Edit the container metadata.yaml, either by launching external editor or reading STDIN'
  )
  _describe -t commands 'Config metadata commands' _l
}

__incus_config_template_commands() {
  local -a _l=(
    'list:List the names of template files for a container.'
    'show:Show the content of a template file for a container'
    'create:Add an empty template file for a container'
    'edit:Edit the content of a template file for a container, either by launching external editor or reading STDIN'
    'delete:Delete a template file for a container'

  )
  _describe -t commands 'Config template commands' _l
}

__incus_config_trust_commands() {
  local -a _l=(
    'list:List all trusted certs'
    'add:Add certfile.crt to trusted hosts'
    'remove:Remove the cert from trusted hosts'
  )
  _describe -t commands 'Config trust commands' _l
}

__incus_file_commands() {
  local -a _l=(
    'pull:Pull file from container'
    'push:Push file to container'
    'delete:Delete files in containers.'
    'edit:Edit files in containers using the default text editor'
  )
  _describe -t commands 'File commands' _l
}

__incus_image_commands() {
  local -a _l=(
    'copy:Copy an image from one LXD daemon to another over the network'
    'delete:Delete one or more images from the LXD image store'
    'import:Import images into the image store'
    'export:Export an image from the LXD image store into a distributable tarball'
    'info:Print everything LXD knows about a given image'
    'list:List images in the LXD image store. Filters may be of the'
    'show:Yaml output of the user modifiable properties of an image'
    'edit:Edit image, either by launching external editor or reading STDIN'
    'alias:Manage alias for image in the LXD image store'
    'refresh:Refresh images'
  )
  _describe -t commands 'Image commands' _l
}

__incus_image_alias_commands() {
  local -a _l=(
    'create:Create aliases for existing images'
    'rename:Rename aliases'
    'delete:Delete image alias'
    'list:List image aliases'
  )
  _describe -t commands 'Image alias commands' _l
}

__incus_profile_commands() {
  local -a _l=(
    'add:Add profiles to containers'
    'assign:Assign sets of profiles to containers'
    'copy:Copy profiles'
    'create:Create profiles'
    'delete:Delete profiles'
    'device:Manage container devices'
    'edit:Edit profile configurations as YAML'
    'get:Get values for profile configuration keys'
    'list:List profiles'
    'remove:Remove profiles from containers'
    'rename:Rename profiles'
    'set:Set profile configuration keys'
    'show:Show profile configurations'
    'unset:Unset profile configuration keys'
  )
  _describe -t commands 'Profile commands' _l
}

__incus_remote_commands() {
  local -a _l=(
    'add:Add the remote <remote> at <url>'
    'remove:Remove the remote <remote>'
    'list:List all remotes'
    'rename:Rename remote <old name> to <new name>'
    "set-url:Update <remote>'s url to <url>"
    'set-default:Set the default remote'
    'get-default:Print the default remote'
  )
  _describe -t commands 'Remote commands' _l
}

__incus_network_commands() {
  local -a _l=(
    'attach:Attach network interfaces to containers'
    'attach-profile:Attach network interfaces to profiles'
    'create:Create new networks'
    'delete:Delete networks'
    'detach:Detach network interfaces from containers'
    'detach-profile:Detach network interfaces from profiles'
    'edit:Edit network configurations as YAML'
    'get:Get values for network configuration keys'
    'info:Get runtime information on networks'
    'list:List available networks'
    'list-leases:List DHCP leases'
    'rename:Rename networks'
    'set:Set network configuration keys'
    'show:Show network configurations'
    'unset:Unset network configuration keys'
  )
  _describe -t commands 'Network commands' _l
}

__incus_operation_commands() {
  local -a _l=(
    'delete:Delete a background operation (will attempt to cancel)'
    'list:List background operations'
    'show:Show details on a background operation'
  )
  _describe -t commands 'Operation commands' _l
}

__incus_storage_commands() {
  local -a _l=(
    'create:Create storage pools'
    'delete:Delete storage pools'
    'edit:Edit storage pool configurations as YAML'
    'get:Get values for storage pool configuration keys'
    'info:Show useful information about storage pools'
    'list:List available storage pools'
    'set:Set storage pool configuration keys'
    'show:Show storage pool configurations and resources'
    'unset:Unset storage pool configuration keys'
    'volume:Manage storage volumes'
  )
  _describe -t commands 'Storage commands' _l
}

__incus_storage_volume_commands() {
  local -a _l=(
    'attach:Attach new storage volumes to containers'
    'attach-profile:Attach new storage volumes to profiles'
    'copy:Copy storage volumes'
    'create:Create new custom storage volumes'
    'delete:Delete storage volumes'
    'detach:Detach storage volumes from containers'
    'detach-profile Detach storage volumes from profiles'
    'edit:Edit storage volume configurations as YAML'
    'get:Get values for storage volume configuration keys'
    'list:List storage volumes'
    'move:Move storage volumes between pools'
    'rename:Rename storage volumes and storage volume snapshots'
    'restore:Restore storage volume snapshots'
    'set:Set storage volume configuration keys'
    'show:Show storage volum configurations'
    'snapshot:Snapshot storage volumes'
    'unset:Unset storage volume configuration keys'
  )
  _describe -t commands 'Storage volume commands' _l
}

__incus_project_commands() {
  local -a _l=(
    'create:Create projects'
    'delete:Delete projects'
    'edit:Edit project configurations as YAML'
    'get:Get values for project configuration keys'
    'list:List projects'
    'rename:Rename projects'
    'set:Set project configuration keys'
    'show:Show project options'
    'switch:Switch the current project'
    'unset:Unset project configuration keys'
  )
  _describe -t commands 'Project commands' _l
}

__incus_devices_by_container () {
  local -a _l=(${(f)"$(_call_program devices incus config device list $selected_container)"})
  _describe "Devices of $selected_container" _l
}

__incus_list_columns () {
  local -a _l=(
    '4:IPv4 address'
    '6:IPv6 address'
    'a:Architecture'
    'b:Storage pool'
    'c:Creation date'
    'd:Description'
    'l:Last used date'
    'n:Name'
    'N:Number of Processes'
    "p:PID of the container's init process"
    'P:Profiles'
    's:State'
    'S:Number of snapshots'
    't:Type (persistent or ephemeral)'
    'L:Location of the container (e.g. its cluster member)'
  )
  _describe "Columns" _l
}

__incus_device_types () {
  local -a _l=(
    'none:Inheritance blocker'
    'nic:Network interface'
    'disk:Mountpoint inside the container'
    'unix-char:Unix character device'
    'unix-block:Unix block device'
    'usb:USB device'
    'gpu:GPU device'
    'infiniband:Infiniband device'
    'proxy:Proxy device'
  )
  _describe 'Device types' _l
}

__incus_containers_running () {
  local -a _l=(${(@f)"$(_call_program containers incus list --fast | tail -n +4 | awk '{print $2 $4}' | grep -E 'RUNNING$' | sed -e "s/RUNNING//")"})
  _describe -t containers 'Running Containers' _l
}

__incus_containers_stopped () {
  local -a _l=(${(@f)"$(_call_program containers incus list --fast | tail -n +4 | awk '{print $2 $4}' | grep -E 'STOPPED$' | sed -e "s/STOPPED//")"})
  _describe -t containers 'Stopped containers' _l
}

__incus_containers_all () {
  local -a _l=(${(@f)"$(_call_program containers incus list --fast | tail -n +4 | awk '{print $2}' | grep -E -v '^(\||^$)')"})
  _describe -t containers 'All containers' _l
}

__incus_images_as_fingerprint () {
  # local -a _l=(${(@f)"$(_call_program images incus image list | tail -n +4 | egrep -e '^\|' | awk '{split($0,a,"|"); for(i in a){ sub(/^[ \t]+/,"",a[i]);sub(/[ \t]+$/,"",a[i]);}; (a[2]=="") ? b=" (not aliased)" : b=" (aliased as " a[2] ")" ; print a[3] ":" a[5] b }' )"})

  local -a _l
  _call_program images incus image list --format=csv | sed -e 's/:/\\:/g' | while read line
  do
    local alias=$(echo $line| cut -d ',' -f 1)
    if [ -n "$alias" ]; then
      suffix="$alias"
    else
      suffix='(not aliased)'
    fi
    _l=($_l "$(echo $line | awk -F ',' '{printf "%s:%-44s -- ",$2,$4}')$suffix")
  done

  _describe -t images_as_fingerprint 'Images as fingerprint' _l
}

__incus_images_as_alias () {
  # local -a _l=(${(@f)"$(_call_program images incus image alias list | tail -n +4 | egrep -e '^\|' | awk '{split($0,a,"|"); for(i in a){ sub(/^[ \t]+/,"",a[i]);sub(/[ \t]+$/,"",a[i]);}; (a[4]=="") ? b="" : b=" - " a[4] ;print a[2] ":" a[3] b }' )"})

  local -a _l
  _call_program images incus image list --format=csv | sed -e 's/:/\\:/g' | while read line
  do
    local alias=$(echo $line| cut -d ',' -f 1)
    if [ -n "$alias" ]; then
      _l=($_l "$(echo $line | awk -F ',' '{printf "%s: %s -- %s",$1,$2,$4}')")
    fi
  done
  _describe -t images_as_alias 'Images as alias' _l
}

__incus_images () {
  __incus_images_as_alias
  __incus_images_as_fingerprint
}

__incus_aliases () {
  local -a _l=(${(@f)"$(_call_program aliases incus alias list | tail -n +4 | grep -E '^\|' | awk '{print $2 ":" $4}')"})
  _describe -t aliases 'Aliases' _l
}

__incus_remotes () {
  local -a _l=(${(@f)"$(_call_program remotes incus remote list | tail -n +4 | grep -E -e '^\|' | sed -e 's/(default)//' | awk '{print $2 ":" $4}')"})
  _describe -t remotes 'Remotes' _l
}

__incus_profiles () {
  local -a _l=(${(@f)"$(_call_program profiles incus profile list | tail -n +4 | grep -E -e '^\|' | awk '{print $2 ":used by " $4 " containers" }' )"})
  _describe -t profiles 'Profiles' _l
}

__incus_projects() {
  local -a _l=(${(@f)"$(_call_program profiles incus project list --format=csv | cut -d ',' -f 1 | sed -e 's/ (current)/:current/')"})
  _describe -t profiles 'Projects' _l
}

__incus_storages () {
  local -a _l=(${(@f)"$(_call_program profiles incus storage list | tail -n +4 | grep -E -e '^\|' | awk '{print $2 }')"})
  _describe -t storages 'Storages' _l
}

__get_incus_keys_by_device () {
  typeset -A hash
  hash[nic]="(nictype limits.ingress limits.egress limits.max name host_name hwaddr mtu \
    parent vlan ipv4.address ipv6.address security.mac_filtering maas.subnet.ipv4 maas.subnet.ipv6)"
  hash[infiniband]="(nictype name hwaddr mtu parent)"
  hash[disk]="(limits.read limits.write limits.max path source optional readonly size recursive pool)"
  hash[unix-char]="(source path major minor uid gid mode required)"
  hash[unix-block]="(source path major minor uid gid mode required)"
  hash[usb]="(vendorid productid uid gid mode required)"
  hash[gpu]="(vendorid productid id pci uid gid mode)"
  hash[proxy]="(listen bind connect)"
  echo "$hash[$1]"
}

__get_incus_templates_by_container () {
  incus config template list $1 | tail -n +4 | grep -E '^\|' | awk '{print $2}'
}

__get_incus_profiles () {
  incus profile list | tail -n +4 | grep -E -e '^\|' | awk '{print $2}' | paste -sd " "
}

compdef _incus incus
