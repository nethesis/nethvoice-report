Name:		nethvoice-report
Version:	1.0.0
Release:	1%{?dist}
Summary:	Queue and CDR/Costs reports

License:	GPLv3
URL:		https://github.com/nethesis/nethvoice-report
Source0:	dist/ui.tar.gz
Source1:	dist/api
BuildArch:	noarch

Requires:	nethserver-nethvoice14

BuildRequires: 	perl
BuildRequires: 	nethserver-devtools

%description
Queue and CDR/Costs reports

%prep
%setup

%build
%{makedocs}
perl createlinks

%install
rm -rf %{buildroot}
(cd root; find . -depth -print | cpio -dump %{buildroot})

mkdir -p %{buildroot}/opt/nethvoice-report/ui
mkdir -p %{buildroot}/opt/nethvoice-report/api

tar xvf %{SOURCE0} -C %{buildroot}/opt/nethvoice-report/ui/
cp -a %{SOURCE1} %{buildroot}/opt/nethvoice-report/api/


%{genfilelist} %{buildroot}  --file /etc/sudoers.d/50_nsapi_nethserver_nut 'attr(0440,root,root)' > %{name}-%{version}-filelist
cat %{name}-%{version}-filelist

%post

%preun

%files -f %{name}-%{version}-filelist
%defattr(-,root,root)
%dir %{_nseventsdir}/%{name}-update
%doc COPYING

%changelog