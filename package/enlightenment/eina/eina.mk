#############################################################
#
# Enlightenment Project - eina
#
#############################################################
EINA_VERSION:=$(ENLIGHTENMENT_SNAPSHOT_VERSION)
EINA_SOURCE:=eina-$(ECORE_VERSION).tar.gz
EINA_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
EINA_INSTALL_STAGING = YES
EINA_INSTALL_TARGET = YES
EINA_CONF_OPT = 
EINA_DEPENDENCIES = host-pkgconfig
EINA_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,eina))
