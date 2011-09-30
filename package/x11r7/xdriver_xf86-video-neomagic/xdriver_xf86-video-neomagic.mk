################################################################################
#
# xdriver_xf86-video-neomagic -- Neomagic video driver
#
################################################################################

XDRIVER_XF86_VIDEO_NEOMAGIC_VERSION = 1.2.4
XDRIVER_XF86_VIDEO_NEOMAGIC_SOURCE = xf86-video-neomagic-$(XDRIVER_XF86_VIDEO_NEOMAGIC_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NEOMAGIC_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NEOMAGIC_AUTORECONF = NO
XDRIVER_XF86_VIDEO_NEOMAGIC_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(call AUTOTARGETS))
