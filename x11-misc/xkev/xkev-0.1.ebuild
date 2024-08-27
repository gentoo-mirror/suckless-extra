# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simply simulate KeyPress/KeyRelease"
HOMEPAGE="https://github.com/vlaadbrain/xkev"
SRC_URI="https://github.com/vlaadbrain/xkev/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e "s/ -O0 / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e "/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}" \
		config.mk || die
}

src_compile() {
	emake CC="$(tc-getCC)" xkev
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
