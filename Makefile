#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-adguardhome
PKG_VERSION:=1.8-20240107
PKG_RELEASE:=1
PKG_MAINTAINER:=<https://github.com/rufengsuixing/luci-app-adguardhome>

LUCI_TITLE:=LuCI app for AdGuardHome
LUCI_DEPENDS:=+!wget&&!curl&&!wget-ssl:curl
LUCI_PKGARCH:=all
LUCI_DESCRIPTION:=LuCI support for AdGuardHome

define Package/luci-app-adguardhome/conffiles
/etc/AdGuardHome/config.yaml
/etc/config/AdGuardHome
/usr/bin/AdGuardHome
/usr/share/AdGuardHome/links.txt
endef

define Package/luci-app-adguardhome/postinst
#!/bin/sh
	/etc/init.d/AdGuardHome enable >/dev/null 2>&1
	enable=$$(uci get AdGuardHome.AdGuardHome.enabled 2>/dev/null)
	if [ "$$enable" == "1" ]; then
		/etc/init.d/AdGuardHome reload >/dev/null 2>&1
	fi
	rm -f /tmp/luci-indexcache
	rm -f /tmp/luci-modulecache/*
exit 0
endef

define Package/luci-app-adguardhome/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/AdGuardHome disable
	/etc/init.d/AdGuardHome stop >/dev/null 2>&1
	uci delete ucitrack.@AdGuardHome[-1]
	uci commit ucitrack
fi
exit 0
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
