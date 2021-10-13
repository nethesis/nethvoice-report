Name:		nethvoice-report
Version: 1.0.4
Release: 1%{?dist}
Summary:	Queue and CDR/Costs reports

License:	GPLv3
URL:		https://github.com/nethesis/nethvoice-report
Source0:	nethvoice-report.tar.gz
Source1:	dist/ui.tar.gz
Source2:	dist/api
Source3:	dist/tasks

Requires:	nethserver-nethvoice14 >= 14.8.0
Requires:   nethserver-collectd
Requires:	redis

BuildRequires: 	perl
BuildRequires: 	nethserver-devtools
BuildRequires: 	python2-devel

%description
Queue and CDR/Costs reports

%prep
%setup -q -n nethvoice-report

%build
%{makedocs}
perl createlinks
sed -i 's/_RELEASE_/%{version}/' %{name}.json

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

mkdir -p %{buildroot}/usr/share/cockpit/%{name}/
mkdir -p %{buildroot}/usr/share/cockpit/nethserver/applications/
mkdir -p %{buildroot}/usr/libexec/nethserver/api/%{name}/
cp -a manifest.json %{buildroot}/usr/share/cockpit/%{name}/
cp -a logo.png %{buildroot}/usr/share/cockpit/%{name}/
cp -a %{name}.json %{buildroot}/usr/share/cockpit/nethserver/applications/
cp -a api-cockpit/* %{buildroot}/usr/libexec/nethserver/api/%{name}/
chmod +x %{buildroot}/usr/libexec/nethserver/api/%{name}/*

%{genfilelist} %{buildroot} \
    --dir /var/lib/redis/nethvoice-report 'attr(0755,redis,asterisk)' \
    --file /opt/nethvoice-report/api/api 'attr(0755,asterisk,asterisk)' \
    --file /opt/nethvoice-report/tasks/tasks 'attr(0755,asterisk,asterisk)' \
    | grep -v /opt/nethvoice-report/api/user_authorizations.json > %{name}-%{version}-filelist
cat %{name}-%{version}-filelist

%files -f %{name}-%{version}-filelist
%defattr(-,root,root)
%dir %{_nseventsdir}/%{name}-update
%config(noreplace) /opt/nethvoice-report/api/user_authorizations.json
%attr(0664,asterisk,asterisk) /opt/nethvoice-report/api/user_authorizations.json

%doc COPYING

%changelog
* Wed Oct 13 2021 Stefano Fancello <stefano.fancello@nethesis.it> - 1.0.4-1
- Make sure that agent columns don't show negative values - Bug nethesis/dev#6069
- Fix saved searches names and enhance some report's informations - Bug nethesis/dev#6064
- Duplicated rows in report_queue table - Bug nethesis/dev#6057

* Tue Jul 27 2021 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 1.0.3-1
- NethVoice report: CVE-2020-28483 - Nethesis/dev#6046

* Fri Apr 23 2021 Andrea Leardini <andrea.leardini@nethesis.it> - 1.0.2-1
- NethVoice report: show only agents of selected queues - nethesis/dev#5989

* Fri Apr 16 2021 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 1.0.1-1
- Queue Report: static agent data are not shown correctly - Bug nethesis/dev#5981

* Thu Mar 18 2021 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 1.0.0-1
- First stable release - Nethesis/dev#5975
- Add inline cdr doc (#124)
- ui & queries. fix filters and login with domain (#123)
- api. fix check filter in cache (#122)
- views. fix provinces and regions retrieval (#121)

* Thu Feb 18 2021 Edoardo Spadoni <edoardo.spadoni@nethesis.it> - 0.2.1-1
- Change cost configuration from seconds to minutes

* Tue Feb 09 2021 Edoardo Spadoni <edoardo.spadoni@nethesis.it> - 0.2.0-1
- NethVoice: new CDR/Costs report - nethesis/dev#5907

* Thu Dec 03 2020 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 0.1.2-1
- NethVoice: new Queue report - nethesis/dev#5865

* Tue Nov 24 2020 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 0.1.1-1
- api. query: added query limit based on settings (#68)
- ui. fix hour of saved search (#72)

* Mon Nov 23 2020 Giacomo Sanchietti <giacomo.sanchietti@nethesis.it> - 0.1.0-1
- NethVoice: new Queue report - Nethesis/dev#5865

