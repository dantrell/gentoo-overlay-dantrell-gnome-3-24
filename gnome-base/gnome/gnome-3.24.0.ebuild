# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0"
KEYWORDS="*"

IUSE="accessibility +bluetooth +classic +cdr cups +extras"

RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-3.8.0

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]
	gnome-base/gnome-shell-common

	>=x11-themes/gnome-backgrounds-$(ver_cut 1-2)
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-2.24
		>=app-accessibility/at-spi2-core-2.24
		>=app-accessibility/caribou-0.4.21
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-3.12.0 )
	classic? ( >=gnome-extra/gnome-shell-extensions-${PV} )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.32[udisks]"

S="${WORKDIR}"

pkg_postinst() {
	elog "This version of GNOME was sourced from Dantrell's GNOME Without Systemd Project."
	elog "To keep apprised of changes, watch: https://github.com/dantrell/gentoo-project-gnome-without-systemd#overview"
	elog "To report issues and contribute, see: https://github.com/dantrell/gentoo-project-gnome-without-systemd/blob/master/CONTRIBUTING.md"
}
