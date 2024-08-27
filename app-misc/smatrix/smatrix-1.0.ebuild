# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple cmatrix clone"
HOMEPAGE="https://sr.ht/~rjraymond/smatrix/"
SRC_URI="https://gentoo.stellar-nexus.ru/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default

	sed -i \
		-e "s/gcc/${CC}/g" \
		-e "s/-o smatrix/-o smatrix ${LDFLAGS}/g" \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin smatrix
}
