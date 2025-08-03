Name:           amp
Version:        0.0.1754206759
Release:        1%{?dist}
Summary:        An agentic coding tool, in research preview from Sourcegraph

License:        MIT
URL:            https://ampcode.com
Source0:        amp-%{version}.tar.gz

# BuildArch is determined by the target architecture
Requires:       ripgrep

# Skip binary stripping for cross-compiled binaries
%global __strip /bin/true
%global __os_install_post %{nil}

%description
Amp is an agentic coding tool engineered to maximize what’s possible with today’s frontier models—autonomous reasoning, comprehensive code editing, and complex task execution.

%prep
%setup -q

%build
# No build required for binary package

%install
mkdir -p %{buildroot}%{_bindir}
install -m 0755 amp %{buildroot}%{_bindir}/amp

%files
%{_bindir}/amp
