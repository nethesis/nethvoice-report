Name:		nethvoice-report
Version:	0.0.1
Release:	1%{?dist}
Summary:	Queue and CDR/Costs reports

License:	GPLv3
URL:		https://github.com/nethesis/nethvoice-report
Source0:	nethvoice-report.tar.gz
Source1:	dist/ui.tar.gz
Source2:	dist/api
Source3:	dist/tasks

Requires:	nethserver-nethvoice14
Requires:   nethserver-collectd
Requires:	redis

BuildRequires: 	perl
BuildRequires: 	nethserver-devtools

%description
Queue and CDR/Costs reports

%prep
%setup -q -n nethvoice-report

%build
%{makedocs}
perl createlinks

%post
%systemd_post nethvoice-report-api.service

%preun
%systemd_preun nethvoice-report-api.service

%postun
%systemd_postun_with_restart nethvoice-report-api.service

%install
rm -rf %{buildroot}
(cd root; find . -depth -print | cpio -dump %{buildroot})

mkdir -p %{buildroot}/opt/nethvoice-report/ui
mkdir -p %{buildroot}/opt/nethvoice-report/api
mkdir -p %{buildroot}/opt/nethvoice-report/tasks
mkdir -p %{buildroot}/etc/collectd.d/
mkdir -p %{buildroot}/%{python2_sitelib}
mkdir -p %{buildroot}/var/lib/redis/nethvoice-report

tar xvf %{SOURCE1} -C %{buildroot}/opt/nethvoice-report/ui/
cp -a %{SOURCE2} %{buildroot}/opt/nethvoice-report/api/
cp -a %{SOURCE3} %{buildroot}/opt/nethvoice-report/tasks/
cp collectd/asterisk_stats.py %{buildroot}/%{python2_sitelib}
cp collectd/asterisk_stats.conf %{buildroot}/etc/collectd.d/

%{genfilelist} %{buildroot} --dir /var/lib/redis/nethvoice-report 'attr(0755,redis,asterisk)'  --file /opt/nethvoice-report/api/api 'attr(0755,asterisk,asterisk)' --file /opt/nethvoice-report/tasks/tasks 'attr(0755,asterisk,asterisk)' > %{name}-%{version}-filelist
cat %{name}-%{version}-filelist

%files -f %{name}-%{version}-filelist
%defattr(-,root,root)
%dir %{_nseventsdir}/%{name}-update

%doc COPYING

%changelog
