#############################################################
#
# coreutils
#
#############################################################
COREUTILS_VERSION:=7.4
COREUTILS_SOURCE:=coreutils-$(COREUTILS_VERSION).tar.gz
#COREUTILS_SITE:=ftp://alpha.gnu.org/gnu/coreutils/
COREUTILS_SITE:=$(BR2_GNU_MIRROR)/coreutils
COREUTILS_CAT:=$(ZCAT)
COREUTILS_DIR:=$(BUILD_DIR)/coreutils-$(COREUTILS_VERSION)
COREUTILS_BINARY:=src/vdir
COREUTILS_TARGET_BINARY:=bin/vdir
BIN_PROGS:=cat chgrp chmod chown cp date dd df dir echo false hostname \
	ln ls mkdir mknod mv pwd rm rmdir vdir sleep stty sync touch true uname

$(DL_DIR)/$(COREUTILS_SOURCE):
	 $(call DOWNLOAD,$(COREUTILS_SITE),$(COREUTILS_SOURCE))

coreutils-source: $(DL_DIR)/$(COREUTILS_SOURCE)

$(COREUTILS_DIR)/.unpacked: $(DL_DIR)/$(COREUTILS_SOURCE)
	$(COREUTILS_CAT) $(DL_DIR)/$(COREUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(COREUTILS_DIR) package/coreutils/ coreutils\*.patch
	$(CONFIG_UPDATE) $(COREUTILS_DIR)/build-aux
	# ensure rename.m4 file is older than configure / aclocal.m4 so
	# auto* isn't rerun
	touch -d '1979-01-01' $(@D)/m4/rename.m4
	touch $@

$(COREUTILS_DIR)/.configured: $(COREUTILS_DIR)/.unpacked
	(cd $(COREUTILS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_func_strtod=yes \
		ac_fsusage_space=yes \
		fu_cv_sys_stat_statfs2_bsize=yes \
		ac_cv_func_closedir_void=no \
		ac_cv_func_getloadavg=no \
		ac_cv_lib_util_getloadavg=no \
		ac_cv_lib_getloadavg_getloadavg=no \
		ac_cv_func_getgroups=yes \
		ac_cv_func_getgroups_works=yes \
		ac_cv_func_chown_works=yes \
		ac_cv_have_decl_euidaccess=no \
		ac_cv_func_euidaccess=no \
		ac_cv_have_decl_strnlen=yes \
		ac_cv_func_strnlen_working=yes \
		ac_cv_func_lstat_dereferences_slashed_symlink=yes \
		ac_cv_func_lstat_empty_string_bug=no \
		ac_cv_func_stat_empty_string_bug=no \
		gl_cv_func_rename_trailing_slash_bug=no \
		ac_cv_have_decl_nanosleep=yes \
		jm_cv_func_nanosleep_works=yes \
		gl_cv_func_working_utimes=yes \
		ac_cv_func_utime_null=yes \
		ac_cv_have_decl_strerror_r=yes \
		ac_cv_func_strerror_r_char_p=no \
		jm_cv_func_svid_putenv=yes \
		ac_cv_func_getcwd_null=yes \
		ac_cv_func_getdelim=yes \
		ac_cv_func_mkstemp=yes \
		utils_cv_func_mkstemp_limitations=no \
		utils_cv_func_mkdir_trailing_slash_bug=no \
		gl_cv_func_rename_dest_exists_bug=no \
		ac_cv_func_memcmp_working=yes \
		ac_cv_have_decl_malloc=yes \
		gl_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_calloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes \
		jm_cv_func_gettimeofday_clobber=no \
		am_cv_func_working_getline=yes \
		gl_cv_func_working_readdir=yes \
		jm_ac_cv_func_link_follows_symlink=no \
		utils_cv_localtime_cache=no \
		ac_cv_struct_st_mtim_nsec=no \
		gl_cv_func_tzset_clobber=no \
		gl_cv_func_getcwd_null=yes \
		gl_cv_func_getcwd_path_max=yes \
		ac_cv_func_fnmatch_gnu=yes \
		am_getline_needs_run_time_check=no \
		am_cv_func_working_getline=yes \
		gl_cv_func_mkdir_trailing_slash_bug=no \
		gl_cv_func_mkstemp_limitations=no \
		ac_cv_func_working_mktime=yes \
		jm_cv_func_working_re_compile_pattern=yes \
		ac_use_included_regex=no \
		gl_cv_c_restrict=no \
		./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-rpath \
		--disable-dependency-tracking \
	)
	touch $@

$(COREUTILS_DIR)/$(COREUTILS_BINARY): $(COREUTILS_DIR)/.configured
	$(MAKE) -C $(COREUTILS_DIR)
	rm -f $(TARGET_DIR)/$(COREUTILS_TARGET_BINARY)

$(TARGET_DIR)/$(COREUTILS_TARGET_BINARY): $(COREUTILS_DIR)/$(COREUTILS_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(COREUTILS_DIR) install
	# some things go in root rather than usr
	for f in $(BIN_PROGS); do \
		mv $(TARGET_DIR)/usr/bin/$$f $(TARGET_DIR)/bin/$$f; \
	done
	# link for archaic shells
	ln -fs test $(TARGET_DIR)/usr/bin/[
	# gnu thinks chroot is in bin, debian thinks it's in sbin
	mv $(TARGET_DIR)/usr/bin/chroot $(TARGET_DIR)/usr/sbin/chroot
	$(STRIPCMD) $(TARGET_DIR)/usr/sbin/chroot > /dev/null 2>&1
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc

# If both coreutils and busybox are selected, make certain coreutils
# wins the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
coreutils: busybox $(TARGET_DIR)/$(COREUTILS_TARGET_BINARY)
else
coreutils: $(TARGET_DIR)/$(COREUTILS_TARGET_BINARY)
endif

# If both coreutils and busybox are selected, the corresponding applets
# may need to be reinstated by the clean targets.
coreutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(COREUTILS_DIR) uninstall
	-$(MAKE) -C $(COREUTILS_DIR) clean

coreutils-dirclean:
	rm -rf $(COREUTILS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_COREUTILS),y)
TARGETS+=coreutils
endif
