# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
KEYWORDS="*"

IUSE="+cairo examples gtk test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.52.1
	>=dev-libs/gobject-introspection-1.52.1:=

	sys-libs/readline:0=
	dev-lang/spidermonkey:38=
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
	gtk? ( >=x11-libs/gtk+-3.20:3 )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_configure() {
	# Code Coverage support is completely useless for portage installs
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-code-coverage \
		$(use_with cairo cairo) \
		$(use_with gtk) \
		$(use_with test dbus-tests) \
		$(use_with test xvfb-tests)
}

src_install() {
	# Installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		dodoc -r examples
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}
