#############################################################
#
# xine
#
#############################################################
XINE_VERSION:=1.1.17
XINE_SOURCE:=xine-lib-$(XINE_VERSION).tar.bz2
XINE_SITE:=http://downloads.sourceforge.net/project/xine/xine-lib/$(XINELIB_VERSION)/$(XINELIB_SOURCE)?use_mirror=autoselect
XINE_INSTALL_STAGING = YES
XINE_INSTALL_TARGET = YES
XINE_CONF_OPT = --without-x LIBS="$(LIBS) -lm"
XINE_DEPENDENCIES = host-pkgconfig zlib
XINE_LIBTOOL_PATCH = NO

# Value of bitfield test not known for AVR32
ifeq ($(BR2_avr32),y)
XINE_CONF_OPT += --disable-vcd
endif

$(eval $(call AUTOTARGETS,package/multimedia,xine))
