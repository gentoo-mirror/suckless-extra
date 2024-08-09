# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="RootDO, a simple doas/sudo alternative."
HOMEPAGE="https://codeberg.org/sw1tchbl4d3/rdo"
SRC_URI="https://codeberg.org/sw1tchbl4d3/rdo/archive/main.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/"$PN"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/libcrypt:="

src_prepare() {
	default

	sed -i \
		-e "s/ -O2 / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "s/\/usr\/local\/bin\//${EPREFIX}\/bin\//" \
		Makefile
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir bin
	dodir etc
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog "The configuration file has been placed at /etc/rdo.conf"
	elog "It has the following variables:"
	elog "group: The group of users that is allowed to execute rdo."
	elog "wrong_pw_sleep: The amount of milliseconds to sleep at a wrong password attempt. Must be a positive integer. Set to 0 to disable."
	elog "session_ttl: The amount of minutes a session lasts. Must be a positive integer. Set to 0 to disable."
}
