# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} pypy )

inherit cmake db-use flag-o-matic gnome2 python-any-r1 systemd vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution https://gitlab.gnome.org/GNOME/evolution-data-server"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/60" # subslot = libcamel-1.2 soname version
KEYWORDS="*"

IUSE="berkdb +gnome-online-accounts +gtk gtk-doc google +introspection ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="!test? ( test )"

# gdata-0.17.7 soft required for new gdata_feed_get_next_page_token API to handle more than 100 google tasks
# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
gdata_depend=">=dev-libs/libgdata-0.17.7:="
RDEPEND="
	>=app-crypt/gcr-3.4:0=
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.46:2
	>=dev-libs/libical-0.43:=
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=net-libs/libsoup-2.42:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4:0=[gtk]
		>=x11-libs/gtk+-3.10:3
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=net-libs/webkit-gtk-2.11.91:4
		${gdata_depend}
	)
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.8:=
		${gdata_depend} )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/gperf
	>=dev-build/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
}

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare call
src_prepare() {
	eapply "${FILESDIR}"/${PN}-3.24.7-DESTDIR-honoring.patch
	eapply "${FILESDIR}"/${PN}-3.24.7-libical3-compat.patch

	# Make CMakeLists versioned vala enabled
	eapply "${FILESDIR}"/${PN}-3.24.2-assume-vala-bindings.patch

	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=795295
	eapply "${FILESDIR}"/${PN}-3.29.2-bug-795295-fails-to-compile-after-icu-61-1-upgrade-icuunicodestring.patch

	use vala && vala_setup
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	local google_enable
	if use google || use gnome-online-accounts; then
		google_enable="ON"
	else
		google_enable="OFF"
	fi

	# phonenumber does not exist in tree
	local mycmakeargs=(
		-DWITH_SYSTEMDUSERUNITDIR="$(systemd_get_userunitdir)"
		-DENABLE_GTK_DOC=$(usex gtk-doc)
		-DWITH_PRIVATE_DOCS=$(usex gtk-doc)
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DWITH_KRB5=$(usex kerberos)
		-DWITH_KRB5_INCLUDES=$(usex kerberos "${EPREFIX}"/usr "")
		-DWITH_KRB5_LIBS=$(usex kerberos "${EPREFIX}"/usr/$(get_libdir) "")
		-DWITH_OPENLDAP=$(usex ldap)
		-DWITH_PHONENUMBER=OFF
		-DENABLE_SMIME=ON
		-DENABLE_GTK=$(usex gtk)
		-DENABLE_GOOGLE_AUTH=${google_enable}
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DENABLE_UOA=OFF
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr OFF)
		-DENABLE_IPV6=ON
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_GOOGLE=$(usex google)
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym ../../../usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! use berkdb; then
		ewarn "You will need to enable berkdb USE for migrating old"
		ewarn "(pre-3.13 evolution versions) addressbook data"
	fi
}
