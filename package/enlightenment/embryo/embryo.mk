#############################################################
#
# Enlightenment Project - embryo
#
#############################################################
EMBRYO_VERSION:=$(ENLIGHTENMENT_SNAPSHOT_VERSION)
EMBRYO_SOURCE:=embryo-$(EMBRYO_VERSION).tar.gz
EMBRYO_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
EMBRYO_INSTALL_STAGING = YES
EMBRYO_INSTALL_TARGET = YES
EMBRYO_CONF_OPT = 
EMBRYO_DEPENDENCIES = host-pkgconfig
EMBRYO_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,embryo))
