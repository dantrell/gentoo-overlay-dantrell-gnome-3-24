# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 systemd

DESCRIPTION="Virtual filesystem implementation for GIO"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="afp archive bluray cdda elogind fuse google gnome-keyring gnome-online-accounts gphoto2 gtk +http ios mtp nfs policykit samba systemd test +udev udisks zeroconf"
REQUIRED_USE="
	?? ( elogind systemd )
	cdda? ( udev )
	elogind? ( udisks )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( udisks )
"

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

RDEPEND="
	app-crypt/gcr:0=
	>=dev-libs/glib-2.51:2
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	elogind? ( >=sys-auth/elogind-229:0= )
	fuse? ( >=sys-fs/fuse-2.8.0:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.7:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? (
		virtual/libusb:1
		>=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.8:= )
	policykit? (
		sys-auth/polkit
		sys-libs/libcap )
	samba? (
		sys-libs/libunwind:=
		>=net-fs/samba-4[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		>=dev-libs/libgudev-147:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-build/gtk-doc-am
	test? (
		>=dev-python/twisted-16
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.2-sysmacros.patch #580234
	"${FILESDIR}"/rollup #599482, 641522
)

src_prepare() {
	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die
	fi

	gnome2_src_prepare
}

src_configure() {
	# --enable-documentation installs man pages
	# --disable-obexftp, upstream bug #729945
	gnome2_src_configure \
		--disable-gdu \
		--enable-documentation \
		--enable-gcr \
		--with-dbus-service-dir="${EPREFIX}"/usr/share/dbus-1/services \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		$(use_enable afp) \
		$(use_enable archive) \
		$(use_enable bluray) \
		$(use_enable cdda) \
		$(use_enable elogind libelogind) \
		$(use_enable fuse) \
		$(use_enable gnome-keyring keyring) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable google) \
		$(use_enable gphoto2) \
		$(use_enable gtk) \
		$(use_enable http) \
		$(use_enable ios afc) \
		$(use_enable mtp libmtp) \
		$(use_enable mtp libusb) \
		$(use_enable nfs) \
		$(use_enable policykit admin) \
		$(use_enable samba) \
		$(use_enable systemd libsystemd-login) \
		$(use_enable udev gudev) \
		$(use_enable udev) \
		$(use_enable udisks udisks2) \
		$(use_enable zeroconf avahi)
}
