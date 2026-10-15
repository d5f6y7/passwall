#!/bin/sh
# PassWall 一键安装脚本
# 适用：GL.iNet GL-MG1300 (Mango 2) 原厂固件 4.x，及其他 OpenWrt 21.02+ 的 mipsel_24kc/arm 设备
# 用法：wget -O - https://raw.githubusercontent.com/d5f6y7/passwall/main/install.sh | sh
# 软件源：OpenWrt-Passwall 官方预编译 (SourceForge)

set -e

echo "=== PassWall 一键安装 ==="
echo ""

# ---- 1. 检测系统 ----
if [ ! -f /etc/openwrt_release ]; then
    echo "错误：这不是 OpenWrt 系统"
    exit 1
fi
. /etc/openwrt_release
echo "系统：${DISTRIB_DESCRIPTION:-未知}"
echo "架构：${DISTRIB_ARCH:-未知}"

# 提取主版本号，如 21.02（兼容 21.02-SNAPSHOT 这类写法）
RELEASE=$(echo "$DISTRIB_RELEASE" | grep -oE '^[0-9]+\.[0-9]+' | head -1)
if [ -z "$RELEASE" ]; then
    echo "警告：无法识别版本，默认使用 21.02"
    RELEASE="21.02"
fi
ARCH="$DISTRIB_ARCH"
FEED_BASE="https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-${RELEASE}/${ARCH}"
echo "软件源：$FEED_BASE"
echo ""

# ---- 2. 导入签名 key ----
echo "--- 导入签名 ---"
wget -q -O /tmp/ipk.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/ipk.pub
opkg-key add /tmp/ipk.pub >/dev/null 2>&1 || {
    mkdir -p /etc/opkg/keys
    cp /tmp/ipk.pub /etc/opkg/keys/ 2>/dev/null || true
}
rm -f /tmp/ipk.pub
echo "签名已导入"
echo ""

# ---- 3. 添加软件源（避免重复） ----
echo "--- 添加软件源 ---"
touch /etc/opkg/customfeeds.conf
for feed in passwall_luci passwall_packages passwall2; do
    if grep -q "[[:space:]]$feed[[:space:]]" /etc/opkg/customfeeds.conf 2>/dev/null; then
        echo "已存在，跳过：$feed"
    else
        echo "src/gz $feed $FEED_BASE/$feed " >> /etc/opkg/customfeeds.conf
        echo "已添加：$feed"
    fi
done
echo ""

# ---- 4. 更新软件包列表 ----
echo "--- 更新软件包列表 ---"
opkg update
echo ""

# ---- 5. 安装 PassWall ----
echo "--- 安装 luci-app-passwall ---"
opkg install luci-app-passwall
echo ""

# ---- 6. 预装代理内核（MG1300 闪存充足） ----
echo "--- 安装代理内核 ---"
for core in xray-core sing-box; do
    if opkg list-installed 2>/dev/null | grep -q "^$core "; then
        echo "已安装，跳过：$core"
    else
        opkg install "$core" && echo "已安装：$core" || echo "安装失败，可稍后在 PassWall 界面按需安装：$core"
    fi
done
echo ""

echo "=== 安装完成 ==="
echo "在浏览器打开路由器管理页面，进入「服务」->「PassWall」进行配置。"
echo "首次使用建议先更新分流规则与地理数据。"
