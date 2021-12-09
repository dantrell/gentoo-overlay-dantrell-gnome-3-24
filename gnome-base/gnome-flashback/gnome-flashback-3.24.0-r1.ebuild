# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2

DESCRIPTION="GNOME Flashback session"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-flashback/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+applet"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2.32.2:2
	>=x11-libs/gtk+-3.19.5:3[X]
	>=gnome-base/gnome-desktop-3.12.0:3=
	<gnome-base/gnome-desktop-3.35.4
	>=media-libs/libcanberra-0.13[gtk3]
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/gsettings-desktop-schemas-3.21.4
	>=sys-auth/polkit-0.97
	>=app-i18n/ibus-1.5.2
	>=sys-power/upower-0.99.0:=
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libX11
	net-wireless/gnome-bluetooth
	x11-libs/libXext
	>=x11-libs/libXi-1.6.0
	x11-libs/pango
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	x11-libs/libXfixes
	media-sound/pulseaudio[glib]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
" # autoconf-archive for eautoreconf
RDEPEND="${RDEPEND}
	x11-wm/metacity
	applet? ( gnome-base/gnome-applets )
	gnome-base/gnome-panel
	gnome-base/gnome-settings-daemon
"

src_configure() {
	gnome2_src_configure \
		--disable-static
}
