# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs savedconfig

DESCRIPTION="simple pomodoro timer"
HOMEPAGE="https://github.com/pickfire/spt"
SRC_URI="https://github.com/pickfire/spt/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify"

DEPEND="
	libnotify? ( x11-libs/libnotify x11-libs/libX11 )
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	use libnotify ||
	sed -i \
		-e "s/DEFS/#DEFS/g" \
		-e "s/INCS+=/#INCS+=/g" \
		-e "s/LIBS+=/#LIBS+=/g" \
		config.mk
	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk

	restore_config config.def.h
}

src_compile() {
	emake CC="$(tc-getCC)" spt
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	save_config config.def.h
}
