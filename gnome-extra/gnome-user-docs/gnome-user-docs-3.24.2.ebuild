# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="https://git.gnome.org/browse/gnome-user-docs"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="*"

IUSE="test"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

RDEPEND=""
DEPEND="
	test? ( dev-libs/libxml2 )
"
# eautoreconf requires:
#	app-text/yelp-tools
# rebuilding translations requires:
#	app-text/yelp-tools
#	dev-util/gettext

src_configure() {
	# itstool is only needed for rebuilding translations
	# xmllint is only needed for tests
	gnome2_src_configure \
		$(usex test "" XMLLINT=$(type -P true)) \
		ITSTOOL=$(type -P true)
}

src_compile() {
	# Do not compile; "make all" with unset LINGUAS rebuilds all translations,
	# which can take > 2 hours on a Core i7.
	return
}
