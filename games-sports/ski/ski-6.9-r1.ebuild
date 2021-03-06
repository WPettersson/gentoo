# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="A simple text-mode skiing game"
HOMEPAGE="http://www.catb.org/~esr/ski/"
SRC_URI="http://www.catb.org/~esr/ski/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

# games-sports/ski and app-emulation/ski both install 'ski' binary, bug #653110
RDEPEND="${RDEPEND} !!app-emulation/ski"

src_install() {
	dobin ski
	dodoc NEWS README
	doman ski.6
	domenu ski.desktop
	doicon ski.png
	python_fix_shebang "${ED}/usr/bin"
}
