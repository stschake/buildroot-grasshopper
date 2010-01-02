#############################################################
#
# Vim Text Editor
#
#############################################################
VIM_VERSION:=7.1
VIM_SOURCE:=vim-$(VIM_VERSION).tar.bz2
VIM_SITE:=http://ftp.vim.org/pub/vim
VIM_SOURCE_SITE:=$(VIM_SITE)/unix
VIM_PATCH_SITE:=$(VIM_SITE)/patches/7.1
VIM_DIR:=$(BUILD_DIR)/vim71
VIM_PATCHES:=$(shell sed -e 's:^:$(DL_DIR)/$(VIM_VERSION).:' package/editors/vim/patches)
VIM_CONFIG_H:=$(VIM_DIR)/src/auto/config.h
VIM_CONFIG_MK:=$(VIM_DIR)/src/auto/config.mk

$(DL_DIR)/$(VIM_SOURCE):
	$(call DOWNLOAD,$(VIM_SOURCE_SITE),$(VIM_SOURCE))

$(DL_DIR)/$(VIM_VERSION).%:
	$(call DOWNLOAD,$(VIM_PATCH_SITE),$(notdir $@))

vim-source: $(DL_DIR)/$(VIM_SOURCE) $(VIM_PATCHES)

$(VIM_DIR)/.unpacked: $(DL_DIR)/$(VIM_SOURCE)
	$(BZCAT) $(DL_DIR)/$(VIM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(VIM_DIR)/.patched: $(VIM_DIR)/.unpacked
	@for i in $(VIM_PATCHES); do ( \
		echo "Patching with $$i"; \
		cd $(VIM_DIR); \
		patch -p0 < $$i) \
	done
	toolchain/patch-kernel.sh $(VIM_DIR) package/editors/vim/ \*.patch
	touch $@

$(VIM_DIR)/.configured: $(VIM_DIR)/.patched
	(cd $(VIM_DIR)/src; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		STRIP="$(TARGET_STRIP)" \
		PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
		PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
		./configure $(QUIET) --prefix=/usr \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
		--disable-netbeans \
		--disable-gpm \
		--disable-gui \
		--without-x \
		--with-tlib=ncurses \
	)
	touch $@

$(VIM_DIR)/.build: $(VIM_DIR)/.configured
	(cd $(VIM_DIR)/src; \
		$(MAKE) \
	)
	touch $@

$(TARGET_DIR)/usr/bin/vim: $(VIM_DIR)/.build
	(cd $(VIM_DIR)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installvimbin; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installlinks; \
	)
ifeq ($(BR2_PACKAGE_VIM_RUNTIME),y)
	(cd $(VIM_DIR)/src; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installrtbase; \
		$(MAKE) DESTDIR=$(TARGET_DIR) installmacros; \
	)
endif

vim: host-pkg-config ncurses vim-source $(TARGET_DIR)/usr/bin/vim

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_VIM),y)
TARGETS+=vim
endif
