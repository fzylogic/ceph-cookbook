include_attribute 'ceph'

default['ceph']['mgr']['init_style'] = node['init_style']

case node['platform_family']
when 'debian'
  packages = ['ceph-mgr']
  packages += debug_packages(packages) if node['ceph']['install_debug']
  default['ceph']['mds']['packages'] = packages
else
  default['ceph']['mds']['packages'] = []
end
