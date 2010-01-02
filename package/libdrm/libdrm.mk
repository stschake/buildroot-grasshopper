#############################################################
#
# libdrm
#
#############################################################
LIBDRM_VERSION:=2.3.0
LIBDRM_SOURCE:=libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE:=http://dri.freedesktop.org/libdrm/
LIBDRM_CAT:=$(BZCAT)
LIBDRM_DIR:=$(BUILD_DIR)/libdrm-$(LIBDRM_VERSION)

$(DL_DIR)/$(LIBDRM_SOURCE):
	$(call DOWNLOAD,$(LIBDRM_SITE),$(LIBDRM_SOURCE))

libdrm-source: $(DL_DIR)/$(LIBDRM_SOURCE)

$(LIBDRM_DIR)/.unpacked: $(DL_DIR)/$(LIBDRM_SOURCE)
	$(LIBDRM_CAT) $(DL_DIR)/$(LIBDRM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(LIBDRM_DIR)
	touch $@

$(LIBDRM_DIR)/.configured: $(LIBDRM_DIR)/.unpacked
	(cd $(LIBDRM_DIR); rm -f config.cache; \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
	)
	touch $@

$(LIBDRM_DIR)/.compiled: $(LIBDRM_DIR)/.configured
	$(MAKE) CCexe="$(HOSTCC)" -C $(LIBDRM_DIR)
	touch $(LIBDRM_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libdrm.so: $(LIBDRM_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBDRM_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libdrm.la
	#$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)\',g" \
	# -e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
	# -e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" \
	# -e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" \
	# $(STAGING_DIR)/usr/bin/libdrm-config
	touch -c $(STAGING_DIR)/usr/lib/libdrm.so

$(TARGET_DIR)/usr/lib/libdrm.so: $(STAGING_DIR)/usr/lib/libdrm.so
	cp -dpf $(STAGING_DIR)/usr/lib/libdrm.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libdrm.so

libdrm: host-pkg-config $(TARGET_DIR)/usr/lib/libdrm.so

libdrm-clean:
	-$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(LIBDRM_DIR) uninstall
	-$(MAKE) -C $(LIBDRM_DIR) clean

libdrm-dirclean:
	rm -rf $(LIBDRM_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBDRM),y)
TARGETS+=libdrm
endif
