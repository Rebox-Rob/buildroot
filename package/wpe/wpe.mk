################################################################################
#
# WPE
#
################################################################################

WPE_VERSION = e3e09736b8733d726d682b441e8412689d476c1f
WPE_SITE = $(call github,Metrological,WebKitForWayland,$(WPE_VERSION))

WPE_INSTALL_STAGING = YES
WPE_DEPENDENCIES = host-flex host-bison host-gperf host-ruby \
	host-pkgconf zlib pcre libgles libegl cairo freetype fontconfig \
	harfbuzz icu libxml2 libxslt sqlite libsoup jpeg webp \
	gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad \
	wayland weston athol

ifeq ($(BR2_ENABLE_DEBUG),y)
BUILDTYPE=Debug
WPE_BUILDDIR = $(@D)/debug
FLAGS= -DCMAKE_C_FLAGS_DEBUG="-O0 -g -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -Wno-cast-align"
else
BUILDTYPE=Release
WPE_BUILDDIR = $(@D)/release
FLAGS= -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align" \
 -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG -Wno-cast-align"
endif

ifeq ($(BR2_PACKAGE_WPE_USE_DXDRM_EME),y)
FLAGS += -DENABLE_DXDRM=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_ENCRYPTED_MEDIA),y)
FLAGS += -DENABLE_ENCRYPTED_MEDIA_V2=ON -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_WPE_USE_MEDIA_SOURCE),y)
FLAGS += -DENABLE_MEDIA_SOURCE=ON
endif

WPE_CONF_OPT = -DPORT=WPE \
 -DCMAKE_BUILD_TYPE=$(BUILDTYPE) \
 $(FLAGS)

RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests

$(eval $(cmake-package))
