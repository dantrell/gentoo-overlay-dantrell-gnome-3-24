# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2 toolchain-funcs

DESCRIPTION="GNOME Flashback panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-panel"

LICENSE="GPL-2+ FDL-1.1 LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="eds gtk-doc"

RDEPEND="
	>=gnome-base/gnome-desktop-2.91.0:3=
	>=x11-libs/gdk-pixbuf-2.26.0:2
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.45.3:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=x11-libs/libwnck-3.4.6:3
	>=gnome-base/gnome-menus-3.7.90:3
	eds? (
		>=gnome-extra/evolution-data-server-3.5.3:=
		<gnome-extra/evolution-data-server-3.33
	)
	>=x11-libs/cairo-1.0.0[X,glib]
	>=dev-libs/libgweather-3.17.1:2=
	>=gnome-base/dconf-0.13.4
	>=x11-libs/libXrandr-1.3.0
	gnome-base/gdm
	x11-libs/libX11
	sys-auth/polkit
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-build/gtk-doc-am-1.25 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
" # yelp-tools and autoconf-archive for eautoreconf

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable eds)
		$(use_enable gtk-doc)
		$(use_enable gtk-doc gtk-doc-html)
	)

	gnome2_src_configure "${myconf[@]}"
}

src_install() {
	gnome2_src_install

	if ! use gtk-doc ; then
		rm -r "${ED}"/usr/share/gtk-doc || die
	fi
}
