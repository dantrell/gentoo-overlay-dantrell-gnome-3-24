# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} pypy )
VALA_USE_DEPEND="vapigen"

inherit cmake-utils db-use flag-o-matic gnome2 python-any-r1 systemd vala virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/60" # subslot = libcamel-1.2 soname version
KEYWORDS="*"

IUSE="api-doc-extras +berkdb +gnome-online-accounts +gtk google +introspection ipv6 ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

# Some tests fail due to missing locales.
# Also, dbus tests are flaky, bugs #397975 #501834
# It looks like a nightmare to disable those for now.
RESTRICT="test"

# gdata-0.17.7 soft required for google tasks (more than 100)
# berkdb needed only for migrating old addressbook data from <3.13 versions, bug #519512
RDEPEND="
	>=app-crypt/gcr-3.4
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.46:2
	>=dev-libs/libgdata-0.10:=
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
		>=app-crypt/gcr-3.4[gtk]
		>=x11-libs/gtk+-3.10:3
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=dev-libs/libgdata-0.17.7:=
		>=net-libs/webkit-gtk-2.11.91:4
	)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.24.7-DESTDIR-honoring.patch
	"${FILESDIR}"/${PN}-3.24.7-libical3-compat.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# Make CMakeLists versioned vala enabled
	eapply "${FILESDIR}"/${PN}-3.24.2-assume-vala-bindings.patch

	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=795295
	eapply "${FILESDIR}"/${PN}-3.29.2-bug-795295-fails-to-compile-after-icu-61-1-upgrade-icuunicodestring.patch

	use vala && vala_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	local google_auth_enable
	if use google || use gnome-online-accounts; then
		google_auth_enable="ON"
	else
		google_auth_enable="OFF"
	fi

	local mycmakeargs=(
		-DWITH_SYSTEMDUSERUNITDIR="$(systemd_get_userunitdir)"
		-DENABLE_GTK_DOC=$(usex api-doc-extras)
		-DWITH_PRIVATE_DOCS=$(usex api-doc-extras "ON" "OFF")
		-DENABLE_SCHEMAS_COMPILE=OFF
		-DENABLE_INTROSPECTION=$(usex introspection)
		-DWITH_KRB5=$(usex kerberos "ON" "OFF")
		-DWITH_KRB5_INCLUDES=$(usex kerberos "${EPREFIX}"/usr "")
		-DWITH_KRB5_LIBS=$(usex kerberos "${EPREFIX}"/usr/$(get_libdir) "")
		-DWITH_OPENLDAP=$(usex ldap "ON" "OFF")
		-DWITH_PHONENUMBER=OFF
		-DENABLE_SMIME=ON
		-DENABLE_GTK=$(usex gtk)
		-DENABLE_GOOGLE_AUTH=${google_auth_enable}
		-DENABLE_EXAMPLES=OFF
		-DENABLE_GOA=$(usex gnome-online-accounts)
		-DENABLE_UOA=OFF
		-DWITH_LIBDB=$(usex berkdb "${EPREFIX}"/usr "OFF")
		-DENABLE_IPV6=$(usex ipv6)
		-DENABLE_WEATHER=$(usex weather)
		-DENABLE_GOOGLE=$(usex google)
		-DENABLE_LARGEFILE=ON
		-DENABLE_VALA_BINDINGS=$(usex vala)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	virtx cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

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
