Name:           gitcommit
Version:        1.1.3
Release:        1%{?dist}
Summary:        Automated Git workflow tool

License:        Estrogen-Source-Available-1.2
URL:            https://github.com/CloveTwilight3/GitCommit
Source0:        https://github.com/CloveTwilight3/GitCommit/archive/refs/tags/v%{version}.tar.gz

BuildArch:      noarch
Requires:       git >= 2.0
Requires:       bash

%description
GitCommit is an automated Git workflow tool that simplifies the process of 
committing and pushing changes to your Git repositories. It handles the entire 
workflow: switching branches, pulling latest changes, adding files, committing 
with your message, and pushing to origin.

%prep
%autosetup -n GitCommit-%{version}

%build
# Nothing to build - it's a bash script

%install
install -Dm755 src/linux/gitcommit.sh %{buildroot}%{_bindir}/gitcommit

%files
%license LICENSE.md
%doc README.md
%{_bindir}/gitcommit

%changelog
* Thu Jan 02 2025 Clove Twilight <clovetwilight3@outlook.com> - 1.1.3-1
- Initial Fedora package