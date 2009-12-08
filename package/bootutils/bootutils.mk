#############################################################
#
# bootutils
#
#############################################################
BOOTUTILS_VERSION = 0.0.9
BOOTUTILS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/bootutils

BOOTUTILS_CONF_OPT = --prefix=/ --exec-prefix=/

BOOTUTILS_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,bootutils))
