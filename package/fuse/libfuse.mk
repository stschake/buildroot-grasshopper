#############################################################
#
# libfuse
#
#############################################################
LIBFUSE_VERSION:=2.7.0
LIBFUSE_SOURCE:=fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE:=http://downloads.sourceforge.net/fuse
LIBFUSE_DIR:=$(BUILD_DIR)/fuse-$(LIBFUSE_VERSION)
LIBFUSE_BINARY:=libfuse
$(DL_DIR)/$(LIBFUSE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBFUSE_SITE)/$(LIBFUSE_SOURCE)

$(LIBFUSE_DIR)/.source: $(DL_DIR)/$(LIBFUSE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LIBFUSE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBFUSE_DIR) package/fuse/ patch/*.patch
	touch $@


$(LIBFUSE_DIR)/.configured: $(LIBFUSE_DIR)/.source
	(cd $(LIBFUSE_DIR); rm -rf config.cache ; \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--enable-shared \
		--enable-static \
		--program-prefix="" \
		--disable-nls \
		--disable-example \
		--enable-kernel-module \
		--enable-lib \
		--enable-util \
		--with-kernel="$(LINUX_DIR)" \
	);
	touch $@
#		--disable-example
#		--disable-mtab
#		--disable-rpath

 
$(LIBFUSE_DIR)/.compiled: $(LIBFUSE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBFUSE_DIR)
	touch $@
#		CROSS_COMPILE="$(TARGET_CROSS)"
#		AM_CFLAGS="$(TARGET_CFLAGS) -DDISABLE_COMPAT=1" \
#		EXTRA_DIST=""


$(STAGING_DIR)/usr/lib/libfuse.so: $(LIBFUSE_DIR)/.compiled
	$(MAKE) prefix=$/usr -C $(LIBFUSE_DIR) DESTDIR=$(STAGING_DIR)/ install
	touch -c $@

$(TARGET_DIR)/usr/lib/libfuse.so: $(STAGING_DIR)/usr/lib/libfuse.so
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/bin
	cp -dpf $(STAGING_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/bin/
	cp -dpf $(STAGING_DIR)/usr/lib/libfuse.so.* $(TARGET_DIR)/usr/lib/
#	cp -dpf $(STAGING_DIR)/lib/modules/(uname-r)/kernel/fs/fuse/fuse.pc $(TARGET_DIR)/usr/lib/
	touch -c $@

libfuse: uclibc $(TARGET_DIR)/usr/lib/libfuse.so

libfuse-source: $(DL_DIR)/$(LIBFUSE_SOURCE)

libfuse-clean:
	-$(MAKE) -C $(LIBFUSE_DIR) DESTDIR=$(STAGING_DIR) uninstall
	-$(MAKE) -C $(LIBFUSE_DIR) clean
	rm -f $(TARGET_DIR)/usr/lib/libfuse.so*

libfuse-dirclean:
	rm -rf $(LIBFUSE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBFUSE)),y)
TARGETS+=libfuse
endif