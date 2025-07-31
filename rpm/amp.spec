Name:           amp
Version:        1.0.0
Release:        1%{?dist}
Summary:        AI-powered coding assistant CLI tool

License:        MIT
URL:            https://github.com/sourcegraph/amp-packages
Source0:        amp-%{version}.tar.gz

BuildArch:      x86_64 aarch64
Requires:       ripgrep

# Skip binary stripping for cross-compiled binaries
%global __strip /bin/true
%global __os_install_post %{nil}

%description
Amp CLI is an AI-powered coding assistant that helps developers write better code faster.
It provides intelligent code suggestions, error detection, and automated refactoring capabilities.

Features:
- AI-powered code suggestions
- Error detection and fixing
- Automated refactoring
- Cross-platform support
- Easy command-line interface

%prep
%setup -q

%build
# No build required for binary package

%install
mkdir -p %{buildroot}%{_bindir}
install -m 0755 amp %{buildroot}%{_bindir}/amp

%files
%{_bindir}/amp

%changelog
* Tue Jul 29 2025 Sourcegraph <support@sourcegraph.com> - 1.0.0-1
- Initial release
- AI-powered coding assistant CLI tool
- Cross-platform support for Linux, macOS, and Windows
- Ripgrep integration for fast code search
