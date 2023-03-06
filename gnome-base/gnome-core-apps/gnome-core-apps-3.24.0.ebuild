# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME core applications"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="*"

IUSE="+bluetooth +cdr cups +eog-plugins +gedit-plugins"

RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.10.1:3
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=app-crypt/gcr-3.20.0:0=
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-3.20.0
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.20.0
	>=app-editors/gedit-3.22.0
	gedit-plugins? ( >=app-editors/gedit-plugins-3.22.0 )
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-3.22.0
	>=media-gfx/eog-${PV}
	eog-plugins? ( >=media-gfx/eog-plugins-3.16.6 )
	>=media-video/totem-${PV}
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-3.22.0

	>=x11-themes/adwaita-icon-theme-$(ver_cut 1-2)
	>=x11-themes/gnome-themes-standard-3.22

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.20.0 )
	cdr? ( >=app-cdr/brasero-3.12.2 )
"
DEPEND=""

S="${WORKDIR}"
