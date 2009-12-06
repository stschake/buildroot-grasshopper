#############################################################
#
# Enlightenment Project - ecore
#
#############################################################
ECORE_VERSION:=$(ENLIGHTENMENT_SNAPSHOT_VERSION)
ECORE_SOURCE:=ecore-$(ECORE_VERSION).tar.gz
ECORE_SITE:=http://download.enlightenment.org/snapshots/$(ENLIGHTENMENT_SNAPSHOT_DATE)/
ECORE_INSTALL_STAGING = YES
ECORE_INSTALL_TARGET = YES
ECORE_CONF_OPT = --enable-ecore-fb --enable-ecore-evas --enable-ecore-job --enable-ecore-con --enable-ecore-ipc --enable-ecore-txt --disable-ecore-x --disable-ecore-evas-gl
ECORE_DEPENDENCIES = host-pkgconfig eina evas
ECORE_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,ecore))

ECORE_DIR_PREFIX:=package/enlightenment
