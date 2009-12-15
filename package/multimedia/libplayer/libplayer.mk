#############################################################
#
# libplayer
#
#############################################################
LIBPLAYER_VERSION:=1.0.0
LIBPLAYER_SOURCE:=libplayer-$(LIBPLAYER_VERSION).tar.bz2
LIBPLAYER_SITE:=http://libplayer.geexbox.org/releases/
LIBPLAYER_DIR:=$(BUILD_DIR)/libplayer-$(LIBPLAYER_VERSION)
LIBPLAYER_MAKE_TARGETS:=lib bindings
LIBPLAYER_INSTALL_TARGETS:=install-lib install-pkgconfig install-bindings

LIBPLAYER_DEPENDENCIES:=
LIBPLAYER_WRAPPER_CONFIG_OPT:=

ifeq ($(BR2_PACKAGE_LIBPLAYER_WRAPPER_MPLAYER),y)
LIBPLAYER_WRAPPER_CONFIG_OPT += --enable-mplayer
LIBPLAYER_DEPENDENCIES += mplayer
else
LIBPLAYER_WRAPPER_CONFIG_OPT += --disable-mplayer
endif

ifeq ($(BR2_PACKAGE_LIBPLAYER_WRAPPER_GSTREAMER),y)
LIBPLAYER_WRAPPER_CONFIG_OPT += --enable-gstreamer
LIBPLAYER_DEPENDENCIES += gstreamer
else
LIBPLAYER_WRAPPER_CONFIG_OPT += --disable-gstreamer
endif

ifeq ($(BR2_PACKAGE_LIBPLAYER_WRAPPER_XINE),y)
LIBPLAYER_WRAPPER_CONFIG_OPT += --enable-xine
LIBPLAYER_DEPENDENCIES += xine
else
LIBPLAYER_WRAPPER_CONFIG_OPT += --disable-xine
endif

ifeq ($(BR2_PACKAGE_LIBPLAYER_WRAPPER_VLC),y)
LIBPLAYER_WRAPPER_CONFIG_OPT += --enable-vlc
LIBPLAYER_DEPENDENCIES += vlc
else
LIBPLAYER_WRAPPER_CONFIG_OPT += --disable-vlc
endif

ifeq ($(BR2_PACKAGE_LIBPLAYER_X11),y)
LIBPLAYER_DEPENDENCIES += xserver_xorg-server
else
LIBPLAYER_WRAPPER_CONFIG_OPT += --disable-x11
endif

$(DL_DIR)/$(LIBPLAYER_SOURCE):
	$(call DOWNLOAD,$(LIBPLAYER_SITE),$(LIBPLAYER_SOURCE))

$(LIBPLAYER_DIR)/.source: $(DL_DIR)/$(LIBPLAYER_SOURCE)
	$(BZCAT) $(DL_DIR)/$(LIBPLAYER_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LIBPLAYER_DIR)/.configured: $(LIBPLAYER_DIR)/.source
	(cd $(LIBPLAYER_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--cross-compile \
		--prefix=/usr \
		$(LIBPLAYER_WRAPPER_CONFIG_OPT) \
	)
	touch $@

$(LIBPLAYER_DIR)/.built: $(LIBPLAYER_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBPLAYER_DIR) $(LIBPLAYER_MAKE_TARGETS)
	touch $@

$(TARGET_DIR)/.done: $(LIBPLAYER_DIR)/.built
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBPLAYER_DIR) $(LIBPLAYER_INSTALL_TARGETS)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(LIBPLAYER_DIR) $(LIBPLAYER_INSTALL_TARGETS)
	touch $@

libplayer: $(LIBPLAYER_DEPENDENCIES) $(TARGET_DIR)/.done

libplayer-source: $(DL_DIR)/$(LIBPLAYER_SOURCE)

libplayer-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBPLAYER_DIR) uninstall
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBPLAYER_DIR) uninstall
	-$(MAKE) -C $(LIBPLAYER_DIR) clean

libplayer-dirclean:
	rm -rf $(LIBPLAYER_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBPLAYER),y)
TARGETS+=libplayer
endif
