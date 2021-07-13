# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2021 Nick Hainke <vincent@systemli.org>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mesh-watcher
PKG_VERSION:=1
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Nick Hainke <vincent@systemli.org>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/mesh-watcher
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Watchdog for IPv6 mesh links
  PKGARCH:=all
  DEPENDS:=@IPV6 +owipcalc
endef

define Package/mesh-watcher/description
Reboots if no mesh neighbor is available.
endef

define Package/mesh-watcher/conffiles
/etc/config/mesh-watcher
endef

define Build/Compile
endef

define Package/mesh-watcher/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mesh-watcher.init $(1)/etc/init.d/mesh-watcher
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/mesh-watcher.sh $(1)/usr/bin/mesh-watcher
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/mesh-watcher.config $(1)/etc/config/mesh-watcher
endef

$(eval $(call BuildPackage,mesh-watcher))
