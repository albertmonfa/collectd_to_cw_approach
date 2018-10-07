.DEFAULT_GOAL := build_rpm

iteration = 'ami-62d35c02'
version = 0.0.1
build_path = src
python_deps = boto3 virtualenv-tools ConfigArgParse docker-py PyYAML jsonschema
pkg_name = cloudwatch-collectd-plugin
arch = amd64
maintaniner = 'Albert Monfà'
description =  'CloudWatch collectd plugin. The CloudWatch collectd plugin is a publishing extension for collectd'
license = 'Apache 2.0'

build_rpm:
	find $(build_path) ! -perm -a+r -exec chmod a+r {} \;
	find $(build_path) -iname *.pyc -exec rm {} \;
	find $(build_path) -iname *.pyo -exec rm {} \;
	fpm \
	--depends python \
        --depends collectd \
        --depends collectd-python \
        --post-install scripts/post-install \
        --pre-install scripts/pre-install \
	--rpm-user root \
	--rpm-group root \
	--description $(description) \
	--license $(license) \
	-t rpm -s dir -C $(build_path) -n $(pkg_name) -v $(version) -p \
	package/$(pkg_name)_$(version)_$(iteration)_$(arch).rpm \
	-a $(arch)
