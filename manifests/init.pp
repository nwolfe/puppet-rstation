# == Class: rstation
#
# Full description of class rstation here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'rstation':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class rstation(
  $station_name    = "RStation",
  $station_id      = "rstation",
  $music_directory = "/var/lib/rstation/music",
  $hostname        = "localhost",
  $port            = "8000")
{
  file { $music_directory:
    ensure => 'directory'
  }

  class { 'icecast':
    hostname        => $hostname,
    port            => $port,
    source_password => 'password',
  }

  class { 'mpd::server':
    music_directory => $music_directory,
    audio_outputs   => [{
     'type'     => 'shout',
     'encoding' => 'mp3',
     'name'     => $station_name,
     'host'     => $hostname,
     'port'     => $port,
     'mount'    => $station_id,
     'password' => 'password',
     'bitrate'  => '128',
     'format'   => '44100:16:1'
    }]
  }

  include mpd::client
}
