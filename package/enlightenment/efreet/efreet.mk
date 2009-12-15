#############################################################
#
# Enlightenment Project - efreet
#
#############################################################
EFREET_VERSION:=0.5.0.063
EFREET_SOURCE:=efreet-$(EFREET_VERSION).tar.gz
EFREET_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
EFREET_INSTALL_STAGING = YES
EFREET_INSTALL_TARGET = YES
EFREET_CONF_OPT = 
EFREET_DEPENDENCIES = host-pkgconfig eina ecore
EFREET_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,efreet))
