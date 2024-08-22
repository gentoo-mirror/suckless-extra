# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="screen capture tool"
HOMEPAGE="https://git.codemadness.org/xscreenshot/file/README.html"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.codemadness.org/xscreenshot"
else
	SRC_URI="https://gentoo.stellar-nexus.ru/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_compile() {
	filter-flags -Wl,--as-needed
	emake CC="$(tc-getCC)"
}
src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" MANPREFIX="/usr/share/man" install
}
