#############################################################
#
# Enlightenment Project - elementary
#
#############################################################
ELEMENTARY_VERSION:=0.6.0.063
ELEMENTARY_SOURCE:=elementary-$(ELEMENTARY_VERSION).tar.gz
ELEMENTARY_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
ELEMENTARY_INSTALL_STAGING = YES
ELEMENTARY_INSTALL_TARGET = YES
ELEMENTARY_CONF_OPT =
ELEMENTARY_DEPENDENCIES = host-pkgconfig ecore evas edje lua
ELEMENTARY_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,elementary))
