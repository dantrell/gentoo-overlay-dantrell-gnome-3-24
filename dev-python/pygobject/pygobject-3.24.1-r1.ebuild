# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_10,3_11,3_12,3_13} )

inherit gnome2 python-r1 virtualx

DESCRIPTION="Python bindings for GObject Introspection"
HOMEPAGE="https://pygobject.readthedocs.io/"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="*"

IUSE="+cairo examples +threads"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.46.0:=
	dev-libs/libffi:=
	cairo? (
		>=dev-python/pycairo-1.10.0[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
"
# gnome-base/gnome-common required by eautoreconf

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/pygobject/-/commit/e4e241d2bdd470ade220d412f3b58fb40fdedc16
	# 	https://gitlab.gnome.org/GNOME/pygobject/-/commit/bbe2e94bb66b5e263655083dd6ed6bb878e21b74
	eapply "${FILESDIR}"/${PN}-3.28.3-tests-remove-usage-of-time-clock-no-longer-available-in-py3-8.patch
	eapply "${FILESDIR}"/${PN}-3.24.1-dont-use-pytypeobject-tp-print-with-python-3.patch

	# From Red Hat:
	# 	https://bugzilla.redhat.com/show_bug.cgi?id=1900494
	eapply "${FILESDIR}"/${PN}-3.14.0-remove-usage-of-pyunicode-asstringandsize-no-longer-available-in-py3-10.patch

	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	# Hard-enable libffi support since both gobject-introspection and
	# glib-2.29.x rdepend on it anyway
	# docs disabled by upstream default since they are very out of date
	configuring() {
		gnome2_src_configure \
			$(use_enable cairo) \
			$(use_enable threads thread)
	}

	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_install() {
	python_foreach_impl run_in_build_dir gnome2_src_install

	use examples && dodoc -r examples
}
