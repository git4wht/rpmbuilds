%define _installdir /etc/vearch
%define _resourcedir /opt/rpm/vearch

Name:       vearch
Version:    3.2.6
Release:    1%{?dist}
BuildArch:  x86_64
Summary:    Vearch RPM package
Group:      Applications/Databases
License:    GPL
BuildRoot:  .build

Requires: libgomp
#  blas lapack openssl libzstd openblas tbb

%description
This is vearch-v%{Version} RPM package.

%prep
# we have no source, so nothing here
rm -rf %{buildroot}

%build
# we have no source, so nothing here

%install
%{__rm} -rf %{buildroot}
%{__mkdir_p} %{buildroot}%{_unitdir}
%{__mkdir_p} %{buildroot}%{_installdir}

%{__install} -D -m 644 %{_resourcedir}/conf/vearch.service %{buildroot}%{_unitdir}/vearch.service
%{__install} -D -m 644 %{_resourcedir}/conf/vearch@.service %{buildroot}%{_unitdir}/vearch@.service

cp -r %{_resourcedir}/* %{buildroot}%{_installdir}/

%post
chmod -R 644 /etc/vearch/
chmod 755 /etc/vearch/*.sh
chmod -R 755 /etc/vearch/bin
chmod -R 755 /etc/vearch/lib

%{__ln_s} -f /etc/vearch/lib/libgamma.so.0.1 /etc/vearch/lib/libgamma.so
%{__ln_s} -f /etc/vearch/lib/librocksdb.so.6.2.2 /etc/vearch/lib/librocksdb.so.6.2
%{__ln_s} -f /etc/vearch/lib/librocksdb.so.6.2.2 /etc/vearch/lib/librocksdb.so
%{__ln_s} -f /etc/vearch/lib/libzfp.so.0.5.5 /etc/vearch/lib/libzfp.so.0
%{__ln_s} -f /etc/vearch/lib/libzfp.so.0.5.5 /etc/vearch/lib/libzfp.so

%prepun
# we have no source, so nothing here
systemctl -f stop vearch.service
systemctl -f stop vearch@*.service

%postun
%{__rm} -rf /etc/vearch
%{__rm} -rf %{_unitdir}/vearch*.service

%files
%dir /etc/vearch
/etc/vearch/*
%{_unitdir}/vearch*.service

%clean
%{__rm} -rf %{buildroot}

%changelog
# let's skip this for now