# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GNOME default icon theme"
HOMEPAGE="https://git.gnome.org/browse/adwaita-icon-theme/"
SRC_URI="${SRC_URI}
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
"

LICENSE="
	|| ( LGPL-3 CC-BY-SA-3.0 )
	branding? ( CC-BY-SA-4.0 )
"
SLOT="0"
KEYWORDS="*"

IUSE="branding"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# gtk+:3 is needed for build for the gtk-encode-symbolic-svg utility
# librsvg is needed for gtk-encode-symbolic-svg to be able to read the source SVG via its pixbuf loader and at runtime for rendering scalable icons shipped by the theme
COMMON_DEPEND="
	>=x11-themes/hicolor-icon-theme-0.10
	gnome-base/librsvg:2
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.14
	x11-libs/gtk+:3
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	if use branding; then
		for i in 16 22 24 32 48; do
			cp "${WORKDIR}"/tango-gentoo-v1.1/${i}x${i}/gentoo.png \
			"${S}"/Adwaita/${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done
	fi

	# Install cursors in the right place used in Gentoo
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i "${S}"/Makefile.am \
		-i "${S}"/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure GTK_UPDATE_ICON_CACHE=$(type -P true)
}
