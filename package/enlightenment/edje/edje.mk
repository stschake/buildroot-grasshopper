#############################################################
#
# Enlightenment Project - edje
#
#############################################################
EDJE_VERSION:=0.9.93.063
EDJE_SOURCE:=edje-$(EDJE_VERSION).tar.gz
EDJE_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)
EDJE_INSTALL_STAGING = YES
EDJE_INSTALL_TARGET = YES
EDJE_CONF_OPT = LUA_LIBS="-L$(STAGING_DIR)/usr/lib -llua" LUA_CFLAGS="-I$(STAGING_DIR)/usr/include"
EDJE_DEPENDENCIES = host-pkgconfig evas ecore eet lua embryo eina
EDJE_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,edje))
