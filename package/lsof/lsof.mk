#############################################################
#
# lsof
#
#############################################################

LSOF_VERSION = 4.85
LSOF_SOURCE = lsof_$(LSOF_VERSION).tar.bz2
LSOF_SITE = ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/

BR2_LSOF_CFLAGS =
ifeq ($(BR2_LARGEFILE),)
BR2_LSOF_CFLAGS += -U_FILE_OFFSET_BITS
endif
ifeq ($(BR2_INET_IPV6),)
BR2_LSOF_CFLAGS += -UHASIPv6
endif

ifeq ($(BR2_USE_WCHAR),)
define LSOF_CONFIGURE_WCHAR_FIXUPS
	$(SED) 's,^#define[[:space:]]*HASWIDECHAR.*,#undef HASWIDECHAR,' \
		$(@D)/machine.h
	$(SED) 's,^#define[[:space:]]*WIDECHARINCL.*,,' \
		$(@D)/machine.h
endef
endif

ifeq ($(BR2_ENABLE_LOCALE),)
define LSOF_CONFIGURE_LOCALE_FIXUPS
	$(SED) 's,^#define[[:space:]]*HASSETLOCALE.*,#undef HASSETLOCALE,' \
		$(@D)/machine.h
endef
endif

# The .tar.bz2 contains another .tar, which contains the source code.
define LSOF_EXTRACT_TAR
	$(TAR) $(TAR_STRIP_COMPONENTS)=1 -xf $(@D)/lsof_$(LSOF_VERSION)_src.tar -C $(@D)
	rm -f $(@D)/lsof_$(LSOF_VERSION)_src.tar
endef

LSOF_POST_EXTRACT_HOOKS += LSOF_EXTRACT_TAR

define LSOF_CONFIGURE_CMDS
	(cd $(@D) ; \
		echo n | $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" \
		LSOF_INCLUDE="$(STAGING_DIR)/usr/include" LSOF_CFLAGS_OVERRIDE=1 ./Configure linux)
	$(LSOF_CONFIGURE_WCHAR_FIXUPS)
	$(LSOF_CONFIGURE_LOCALE_FIXUPS)
endef

define LSOF_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_LSOF_CFLAGS)" -C $(@D)
endef

define LSOF_INSTALL_TARGET_CMDS
	install -D -m 755 $(@D)/lsof $(TARGET_DIR)/bin/lsof
endef

define LSOF_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/bin/lsof
endef

define LSOF_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS))
