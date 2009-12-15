#############################################################
#
# Enlightenment Project - edbus
#
#############################################################
EDBUS_VERSION:=0.5.0.063
EDBUS_SOURCE:=e_dbus-$(EDBUS_VERSION).tar.gz
EDBUS_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
EDBUS_INSTALL_STAGING = YES
EDBUS_INSTALL_TARGET = YES
EDBUS_CONF_OPT = 
EDBUS_DEPENDENCIES = host-pkgconfig ecore dbus
EDBUS_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,edbus))
