# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="https://www.musicpd.org/clients/ncmpc/ https://github.com/MusicPlayerDaemon/ncmpc"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="async-connect chat-screen doc +help-screen key-screen +library-screen lirc lyrics-screen outputs-screen search-screen +song-screen +mouse nls pcre"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"
RDEPEND="
	>=media-libs/libmpdclient-2.9
	sys-libs/ncurses:0=[unicode]
	lirc? ( app-misc/lirc )
	pcre? ( dev-libs/libpcre )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.62
"

PATCHES=( "${FILESDIR}/${P}-mandir.patch" )

src_prepare() {
	default

	# use correct docdir and don't install license file
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "s/'COPYING', //" \
		-i meson.build || die

	# use correct (html) docdir
	sed -e "/install_dir:.*doc/s/meson.project_name()/'${PF}'/" \
		-i doc/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dcurses=ncursesw
		-Dcolors=true
		-Dmini=false
		-Dlyrics_plugin_dir="${EPREFIX}/usr/$(get_libdir)/ncmpc/lyrics"
		-Dlibrary_screen=$(usex library-screen true false)
		-Dasync_connect=$(usex async-connect true false)
		-Dchat_screen=$(usex chat-screen true false)
		-Ddocumentation=$(usex doc enabled disabled)
		-Dhelp_screen=$(usex help-screen true false)
		-Dkey_screen=$(usex key-screen true false)
		-Dlyrics_screen=$(usex lyrics-screen true false)
		-Doutputs_screen=$(usex outputs-screen true false)
		-Dsearch_screen=$(usex search-screen true false)
		-Dsong_screen=$(usex song-screen true false)
		-Dlocale=$(usex nls enabled disabled)
		-Dmultibyte=$(usex nls true false)
		-Dnls=$(usex nls enabled disabled)
		-Dlirc=$(usex lirc enabled disabled)
		-Dmouse=$(usex mouse enabled disabled)
		-Dregex=$(usex pcre enabled disabled)
	)

	meson_src_configure
}
