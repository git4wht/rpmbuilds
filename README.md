# vearch-rpmbuild

## build prepare
```
yum install -y epel-release
yum install -y rpm-build
```

## build Vearch
```
cd /opt
git clone --recursive https://github.com/vearch/vearch.git
cd vearch/cloud/
./run_docker.sh
```
build files in `../build/bin` and `../build/lib`

## rpmbuilder prepare
copy files in  `../build/bin` and `../build/lib` to this `vearch`
```
rpmbuild -ba vearch.spec
```
build files in `/root/rpmbuild/RPMS/x86_64`