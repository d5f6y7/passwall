# passwall

OpenWrt 路由器 PassWall 一键安装脚本。

## 一键安装

SSH 进路由器后执行：

```sh
wget -O - https://raw.githubusercontent.com/d5f6y7/passwall/main/install.sh | sh
```

## 说明

- 自动识别 OpenWrt 版本与 CPU 架构，添加 PassWall 官方预编译软件源（SourceForge）
- 安装 `luci-app-passwall` 及 `xray-core`、`sing-box` 内核
- 已在 GL.iNet GL-MG1300（Mango 2，原厂 4.x 固件，mipsel_24kc）上验证思路；理论上支持 OpenWrt 21.02 及以上的大部分架构
- 装完后在路由器管理页面进入「服务」->「PassWall」配置节点

## 软件源

https://github.com/Openwrt-Passwall/openwrt-passwall-build
