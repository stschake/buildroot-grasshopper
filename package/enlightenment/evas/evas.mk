#############################################################
#
# Enlightenment Project - evas
#
#############################################################
EVAS_VERSION:=$(ENLIGHTENMENT_SNAPSHOT_VERSION)
EVAS_SOURCE:=evas-$(EVAS_VERSION).tar.gz
EVAS_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
EVAS_INSTALL_STAGING = YES
EVAS_INSTALL_TARGET = YES
EVAS_CONF_OPT = --enable-fb --disable-xrender-xcb --disable-software-xcb --disable-software-16-x11 --disable-xrender-x11
EVAS_DEPENDENCIES = host-pkgconfig eina freetype eet
EVAS_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,evas))
