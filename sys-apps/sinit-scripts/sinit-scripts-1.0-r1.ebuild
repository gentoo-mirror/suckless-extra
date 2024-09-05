# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig

DESCRIPTION="Collection of services for suckless init"
HOMEPAGE="https://github.com/Andrey0189/sinit-scripts"
SRC_URI="https://github.com/Andrey0189/sinit-scripts/archive/refs/heads/main.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/"$PN"-main

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-apps/sinit"
RDEPEND="${DEPEND}
sys-process/daemontools-encore
sys-apps/littkit"

PATCHES=(
	"${FILESDIR}/${P}-fs-fix.diff"
	"${FILESDIR}/${P}-alsa-wo-udev.diff"
)

src_prepare() {
	default

	cp -r "${FILESDIR}"/alsa-wo-udev ./var/rc/
	chmod +x ./var/rc/alsa-wo-udev/run
	restore_config var/rc/dtinit/dtinit.sh
}

src_install() {
	dodir var/rc
	cp -r ./var/rc "${D}"/var/
	keepdir etc/rc
	into /
	dobin ./bin/*
	dosbin ./sbin/*
	save_config var/rc/dtinit/dtinit.sh
}

pkg_postinst() {
	ln -s "${ROOT}"/sbin/sinit "${ROOT}"/sbin/init
	ln -s "${ROOT}"/sbin/shutdown "${ROOT}"/sbin/reboot
	ln -s "${ROOT}"/sbin/shutdown "${ROOT}"/sbin/poweroff
	ln -s "${ROOT}"/var/rc/* "${ROOT}"/etc/rc/
	echo
	ewarn "You may need to add new services."
	ewarn "To add new services run:"
	ewarn "mkdir ${ROOT}/var/rc/service_name"
	ewarn "touch ${ROOT}/var/rc/service_name/run # main execution script for the service."
	ewarn "#Note: daemontools-encore is going to restart the service every time it finishes execution of the run file."
	ewarn "#If you want to avoid this add \"lk_forever 3600\" at the end of the script."
	ewarn "chmod u+x ${ROOT}/var/rc/service_name/run"
	ewarn "ln -s ${ROOT}/var/rc/service_name ${ROOT}/etc/rc/"
	ewarn "# Add \"log 'service_name'\" (optionally) and \"lk_runsvc ${ROOT}/etc/rc/service_name 0\" to ${ROOT}/etc/rc/dtinit/dtinit.sh"
	echo
	ewarn "If you have not done that already, please delete ${ROOT}/sbin/init, ${ROOT}/sbin/poweroff, ${ROOT}/sbin/reboot and ${ROOT}/sbin/shutdown before emerging this package"
	ewarn "Alternatively, unmerge your current init system and emerge this package again. It is safer to do this in a chroot environment"
	echo
	elog " -< Succeeded. Now you can reboot >- "
	echo
	[ -f ${ROOT}/etc/hostname ] ||
	ewarn "File ${ROOT}/etc/hostname is missing. Copy ${ROOT}/etc/localhost or create one"
}
