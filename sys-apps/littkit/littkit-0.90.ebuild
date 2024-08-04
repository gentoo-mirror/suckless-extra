# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a set of shell scripts to implement oredered-startup and run-once capabilities"
HOMEPAGE="https://troubleshooters.com/projects/littkit"
SRC_URI="https://troubleshooters.com/projects/${PN}/downloads/${PN}_${PV//./_}.tgz"

S="${WORKDIR}"/littkit_0_90

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	dobin lk_*
}
