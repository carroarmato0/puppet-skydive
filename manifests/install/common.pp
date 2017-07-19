# class skydive::common::install
class skydive::install::common {

  if $::skydive::manage_repo {
    case $::osfamily {
      'RedHat': {
        yumrepo { 'opstools7-sensu-common-release':
          baseurl  => 'https://cbs.centos.org/repos/opstools7-sensu-common-release/$basearch/os/',
          descr    => 'Community Build Service',
          enabled  => '1',
          gpgcheck => '0',
        }
        exec { 'yum-clean-expire-cache':
          command     => '/usr/bin/yum clean expire-cache',
          before      => [
            Package['skydive-agent'],
            Package['skydive-analyzer'],
            Package['skydive'],
          ],
          refreshonly => true,
        }
      }
      default: {
        fail("Module ${module_name} is not supported on osfamily '${::osfamily}'")
      }
    }
  }

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        exec { 'skydive: reload systemd':
          command     => 'systemctl daemon-reload',
          path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
          refreshonly => true,
          subscribe   => [
            Package['skydive-agent'],
            Package['skydive-analyzer'],
            Package['skydive'],
          ],
        }
      }
    }
    default: {
      fail("Module ${module_name} is not supported on osfamily '${::osfamily}'")
    }
  }

  package { 'skydive':
    ensure => installed,
  }

}
