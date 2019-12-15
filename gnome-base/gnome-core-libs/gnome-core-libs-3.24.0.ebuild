# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="cups python"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gdk-pixbuf-2.36:2
	>=x11-libs/pango-1.40
	>=media-libs/clutter-1.26:1.0
	>=x11-libs/gtk+-3.22:3[cups?]
	>=dev-libs/atk-2.24
	>=x11-libs/libwnck-3.24.0:3
	>=gnome-base/librsvg-2.40.17
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.32
	>=gnome-base/dconf-0.26

	>=media-libs/gstreamer-1.8:1.0
	>=media-libs/gst-plugins-base-1.8:1.0
	>=media-libs/gst-plugins-good-1.8:1.0

	dev-lang/vala:0.42
	dev-lang/vala:0.44

	python? ( >=dev-python/pygobject-${PV}:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
