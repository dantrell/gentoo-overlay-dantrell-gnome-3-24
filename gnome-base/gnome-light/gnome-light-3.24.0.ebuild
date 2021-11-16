# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME (Light)"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0"
KEYWORDS="*"

IUSE="cups +gnome-shell"

RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.10.1:3
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=gnome-base/nautilus-${PV}

	gnome-shell? (
		>=x11-wm/mutter-${PV}
		>=gnome-base/gnome-shell-${PV}
		gnome-base/gnome-shell-common )

	>=x11-themes/adwaita-icon-theme-$(ver_cut 1-2)
	>=x11-themes/gnome-themes-standard-3.22
	>=x11-themes/gnome-backgrounds-$(ver_cut 1-2)

	>=x11-terms/gnome-terminal-${PV}
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.32.0"

S="${WORKDIR}"

pkg_pretend() {
	if ! use gnome-shell; then
		ewarn "Don't forget to install a window manager since you didn't choose GNOME Shell."
		ewarn "For a list of available packages, see: https://wiki.gentoo.org/wiki/Window_manager"
	fi
}

pkg_postinst() {
	elog "This version of GNOME was sourced from Dantrell's GNOME Without Systemd Project."
	elog "To keep apprised of changes, watch: https://github.com/dantrell/gentoo-project-gnome-without-systemd#overview"
	elog "To report issues and contribute, see: https://github.com/dantrell/gentoo-project-gnome-without-systemd/blob/master/CONTRIBUTING.md"
}
