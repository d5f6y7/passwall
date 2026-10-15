# passwall

OpenWrt 路由器 PassWall 一键安装脚本。

## 一键安装（二选一）

**v1（经典版）**：

```sh
wget -O - https://raw.githubusercontent.com/d5f6y7/passwall/main/install.sh | sh
```

**v2（新版，推荐）**：支持 Hysteria2、TUIC、XHTTP、NaiveProxy 等新协议

```sh
wget -O - https://raw.githubusercontent.com/d5f6y7/passwall/main/install-v2.sh | sh
```

注意：v1 和 v2 不要同时装，装之前先把另一个卸掉。

## 说明

- 自动识别 OpenWrt 版本与 CPU 架构，添加 PassWall 官方预编译软件源（SourceForge）
- 安装 `luci-app-passwall` 或 `luci-app-passwall2`，及 `xray-core`、`sing-box` 内核
- 已在 GL.iNet GL-MG1300（Mango 2，原厂 4.x 固件，mipsel_24kc）上验证思路；理论上支持 OpenWrt 21.02 及以上的大部分架构
- 装完后在路由器管理页面进入「服务」->「PassWall」或「PassWall2」配置节点

## 软件源

https://github.com/Openwrt-Passwall/openwrt-passwall-build
