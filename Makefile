#
# Copyright 2021-2022 Michael Zhang <probezy@gmail.com>
# Licensed to the public under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cpolar
PKG_VERSION:=1.0.2
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Michael Zhang <probezy@gmail.com>

LUCI_TITLE:=LuCI support for Cpolar
LUCI_DEPENDS:=+jshn +luci-lib-jsonc +cpolar
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/cpolar
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/postinst
#!/bin/sh

if [ -z "$${IPKG_INSTROOT}" ] ; then
	( . /etc/uci-defaults/40_luci-cpolar ) && rm -f /etc/uci-defaults/40_luci-cpolar
fi

chmod 755 "$${IPKG_INSTROOT}/etc/init.d/cpolar" >/dev/null 2>&1
ln -sf "../init.d/cpolar" \
	"$${IPKG_INSTROOT}/etc/rc.d/S99cpolar" >/dev/null 2>&1

exit 0
endef

define Package/$(PKG_NAME)/postrm
#!/bin/sh

if [ -s "$${IPKG_INSTROOT}/etc/rc.d/S99cpolar" ] ; then
	rm -f "$${IPKG_INSTROOT}/etc/rc.d/S99cpolar"
fi

if [ -s "$${IPKG_INSTROOT}/etc/init.d/cpolar" ] ; then
	rm -f "$${IPKG_INSTROOT}/etc/init.d/cpolar"
fi


if [ -z "$${IPKG_INSTROOT}" ] ; then
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi

exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
