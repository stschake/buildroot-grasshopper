#############################################################
#
# libplayer
#
#############################################################
LIBPLAYER_VERSION:=1.0.0
LIBPLAYER_SOURCE:=libplayer-$(LIBPLAYER_VERSION).tar.bz2
LIBPLAYER_SITE:=http://libplayer.geexbox.org/releases/
LIBPLAYER_DIR:=$(BUILD_DIR)/libplayer-$(LIBPLAYER_VERSION)

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
		--enable-mplayer \
		--enable-xine \
		--enable-vlc \
		--enable-gstreamer \
		--prefix=/usr \
	)
	touch $@

$(LIBPLAYER_DIR)/.built: $(LIBPLAYER_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBPLAYER_DIR)

$(TARGET_DIR)/.done: $(LIBPLAYER_DIR)/.built
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBPLAYER_DIR) install
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(LIBPLAYER_DIR) install

libplayer: $(TARGET_DIR)/.done

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
