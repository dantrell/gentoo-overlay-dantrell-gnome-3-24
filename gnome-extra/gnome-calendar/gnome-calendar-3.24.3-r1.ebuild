# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

# >=libical-1.0.1 for https://bugzilla.gnome.org/show_bug.cgi?id=751244
RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.21.6:3
	>=gnome-extra/evolution-data-server-3.17.1:=
	>=dev-libs/libical-1.0.1:0=
	net-libs/libsoup:2.4
	>=net-libs/gnome-online-accounts-3.2.0:=
	>=gnome-base/gsettings-desktop-schemas-3.21.2
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.24.3-week-grid-fixes.patch # from gnome-3-24 branch
	"${FILESDIR}"/${PN}-3.24.3-libical3-compat.patch # from master branch, https://bugzilla.gnome.org/show_bug.cgi?id=790072
)

src_configure() {
	# Explicit --enable-debug=minimum forces no -O and -g touching in development (odd minor) versions
	gnome2_src_configure \
		--enable-debug=minimum
}
