# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal

GNOME_ORG_MODULE="at-spi2-core"

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility https://gitlab.gnome.org/GNOME/at-spi2-core"
SRC_URI="mirror://gnome/sources/${GNOME_ORG_MODULE}/${GNOME_ORG_RELEASE}/${GNOME_ORG_MODULE}-${PV}.tar.${GNOME_TARBALL_SUFFIX}"

S="${WORKDIR}/${GNOME_ORG_MODULE}-${PV}"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="X +introspection"

# x11-libs/libSM is needed until upstream #719808 is solved either
# making the dep unneeded or fixing their configure
# Only libX11 is optional right now
RDEPEND="
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)

	!<app-accessibility/at-spi2-core-2.46.0:2
"
DEPEND="${RDEPEND}
	>=dev-build/gtk-doc-am-1.9
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}"/${GNOME_ORG_MODULE}-2.0.2-disable-teamspaces-test.patch
)

multilib_src_configure() {
	# xevie is deprecated/broken since xorg-1.6/1.7
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-xevie \
		$(multilib_native_use_enable introspection) \
		$(use_enable X x11)

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		ln -s "${S}"/doc/libatspi/html doc/libatspi/html || die
	fi
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
