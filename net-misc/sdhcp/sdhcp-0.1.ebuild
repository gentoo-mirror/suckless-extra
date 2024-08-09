# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple dhcp client"
HOMEPAGE="https://core.suckless.org/sdhcp
https://git.2f30.org/sdhcp/files.html"
SRC_URI="https://dl.2f30.org/releases/${P}.tar.gz"

S="${WORKDIR}"/"${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	cd "${WORKDIR}"
	tar xf "${WORKDIR}"/../distdir/"${P}".tar.gz
}

src_prepare() {
	default

	sed -i \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
