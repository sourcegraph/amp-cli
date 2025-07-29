Name:           amp
Version:        1.0.0
Release:        1%{?dist}
Summary:        AI-powered coding assistant CLI tool

License:        MIT
URL:            https://github.com/sourcegraph/amp-cli
Source0:        https://github.com/sourcegraph/amp-cli/releases/download/v%{version}/amp-linux-amd64.tar.gz
Source1:        https://github.com/sourcegraph/amp-cli/releases/download/v%{version}/amp-linux-arm64.tar.gz

BuildArch:      x86_64 aarch64
Requires:       ripgrep

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
%ifarch x86_64
%setup -q -c -T
tar -xzf %{SOURCE0}
%endif
%ifarch aarch64
%setup -q -c -T
tar -xzf %{SOURCE1}
%endif

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
