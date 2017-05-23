class bpx.server.local {
	package { 'vim': ensure => 'installed', }
	package { 'curl': ensure => 'installed', }
	package { 'git': ensure => 'installed', } 

	user { 'monitor':
		ensure => 'present',
		home => '/home/monitor',
		shell => 'bash',
	}

	file { 'home/monitor/scripts':
		ensure => 'directory',
	}

	exec { 'get_script':
		command => "/usr/bin/wget -q https://raw.githubusercontent.com/2013056105/SE-Exercise/master/memory_check -O /home/monitor/scripts/memory_check",
		creates => "/home/monitor/scripts/memory_check",
	}

	file { '/home/monitor/scripts/memory_check':
		mode => 'a+x',
		require => Exec["get_script"],
	}

	file { '/home/monitor/src':
		ensure => 'directory',
	}

	file { '/home/monitor/src/my_memory_check':
		ensure => 'link',
		target => '/home/monitor/scripts/memory_check',
	}

	cron { 'my_memory_check':
		command => './home/monitor/src/my_memory_check -c 90 -w 60 -e test2013056105@mailinator.com',
		ensure => 'present',
		user => 'root',
		hour => '*',
		minute => '*/10',
		require => File['/home/monitor/src/my_memory_check'],
	}
}
