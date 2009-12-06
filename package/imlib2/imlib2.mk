#############################################################
#
# imlib2
#
#############################################################
IMLIB2_VERSION:=1.4.2
IMLIB2_SOURCE:=imlib2-$(IMLIB2_VERSION).tar.gz
IMLIB2_SITE:=http://downloads.sourceforge.net/project/enlightenment/imlib2-src/$(IMLIB2_VERSION)/$(IMLIB2_SOURCE)?use_mirror=autoselect
IMLIB2_INSTALL_STAGING = YES
IMLIB2_INSTALL_TARGET = YES
IMLIB2_CONF_OPT = --without-x
IMLIB2_DEPENDENCIES = host-pkgconfig

$(eval $(call AUTOTARGETS,package,imlib2))
