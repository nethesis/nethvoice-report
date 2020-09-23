Name:		nethvoice-report
Version:	1.0.0
Release:	1%{?dist}
Summary:	Queue and CDR/Costs reports

License:	GPLv3
URL:		https://github.com/nethesis/nethvoice-report
Source0:	dist/ui.tar.gz
Source1:	dist/api
Source2:	dist/tasks
Source3:    	dist/nethvoice-report-api.service
BuildArch:	noarch

Requires:	nethserver-nethvoice14
Requires:	redis

BuildRequires: 	perl
BuildRequires: 	nethserver-devtools

%description
Queue and CDR/Costs reports

%prep
%setup

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

tar xvf %{SOURCE0} -C %{buildroot}/opt/nethvoice-report/ui/
cp -a %{SOURCE1} %{buildroot}/opt/nethvoice-report/api/
cp -a %{SOURCE2} %{buildroot}/opt/nethvoice-report/tasks/

cp %{SOURCE3} %{buildroot}/%{_unitdir}

%{genfilelist} %{buildroot}  --file /opt/nethvoice-report/api/api 'attr(0755,asterisk,asterisk)' --file /opt/nethvoice-report/tasks/tasks 'attr(0755,asterisk,asterisk)' > %{name}-%{version}-filelist
cat %{name}-%{version}-filelist

%files -f %{name}-%{version}-filelist
%defattr(-,root,root)
%dir %{_nseventsdir}/%{name}-update

%doc COPYING

%changelog
