# The profile to install the volume service
class havana::profile::cinder::volume {
  $data_network = hiera('havana::network::data')
  $data_address = ip_for_network($data_network)

  havana::resources::firewall { 'ISCSI API': port => '3260', }

  include ::havana::common::cinder

  class { '::cinder::setup_test_volume':
    volume_name => 'cinder-volumes',
    size        => hiera('havana::cinder::volume_size')
  } ->

  class { '::cinder::volume':
    package_ensure => true,
    enabled        => true,
  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address  => $data_address,
    volume_group      => 'cinder-volumes',
  }
}
