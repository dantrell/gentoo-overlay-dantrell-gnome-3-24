# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.11.4:3
	>=gnome-extra/evolution-data-server-3.13.90:=
	>=net-libs/webkit-gtk-2.10.0:4
	net-libs/gnome-online-accounts:=
	dev-libs/libxml2
	>=app-misc/tracker-1:=
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"
# Needed if eautoreconf:
# sys-devel/autoconf-archive

src_prepare() {
	# From GNOME:
	# 	https://git.gnome.org/browse/bijiben/commit/?id=384dd61950cf40d2a0c2f9caf9ed0cb8bd2a4029
	eapply "${FILESDIR}"/${PN}-3.27.4-memo-provider-dont-add-custom-border-to-pixbuf.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-zeitgeist
}
