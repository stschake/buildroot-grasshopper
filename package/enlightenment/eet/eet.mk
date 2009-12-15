#############################################################
#
# Enlightenment Project - eet
#
#############################################################
EET_VERSION:=1.2.3
EET_SOURCE:=eet-$(EET_VERSION).tar.gz
EET_SITE:=http://download.enlightenment.org/releases/
EET_INSTALL_STAGING = YES
EET_INSTALL_TARGET = YES
EET_CONF_OPT = 
EET_DEPENDENCIES = host-pkgconfig jpeg
EET_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package/enlightenment,eet))
