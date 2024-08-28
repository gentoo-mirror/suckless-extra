# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="extremely fast and small background setter for X."
HOMEPAGE="https://github.com/Gottox/bgs"
SRC_URI="https://github.com/Gottox/bgs/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="xinerama"

DEPEND="
	media-libs/imlib2
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk
}

src_compile() {
	if use xinerama; then
		emake CC="$(tc-getCC)" bgs
	else
		emake CC="$(tc-getCC)" XINERAMAFLAGS="" XINERAMALIBS="" bgs
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
