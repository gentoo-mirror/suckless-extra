# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="suckless init"
HOMEPAGE="https://core.suckless.org/sinit"
SRC_URI="https://dl.suckless.org/${PN}/${P}.tar.gz"

S="${WORKDIR}"/"${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal"

RDEPEND="
	!minimal? ( sys-process/daemontools-encore )
	!minimal? ( sys-apps/littkit )"
PDEPEND="!minimal? ( sys-apps/sinit-scripts )"

src_unpack() {
	cd "${WORKDIR}"
	tar xf "${WORKDIR}"/../distdir/sinit-1.1.tar.gz
}

src_prepare() {
	default

	sed -i \
		-e "s/ -Os//" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	use !minimal &&
	cp /usr/bin/sinit "${D}"/sbin/
}

pkg_postinst() {
	use minimal &&
	ewarn "Please disable the minimal flag" &&
	ewarn "unless you know what you are doing." &&
	ewarn "Do not delete your current init system" &&
	ewarn "unless you are sure that everything is" &&
	ewarn "set up correctly"
}
