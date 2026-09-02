# Luckfox Ubuntu 镜像 <版本号>

## 更新内容

- `<新增镜像、系统升级或问题修复>`

首次发布没有历史更新日志时，可以只写：

```text
Luckfox Ubuntu 镜像首次发布。
```

## 镜像列表

同一次 Release 中的全部型号和介质统一写在此表，不为每个产品单独创建 Markdown。

| 产品系列 | 开发板型号 | 目标介质 | 镜像文件 |
| --- | --- | --- | --- |
| Luckfox Lyra | `<Lyra/Lyra Plus/Lyra Pi/Lyra Ultra/Lyra Zero W>` | `<SPI Flash/eMMC/TF 卡>` | `<image-name>.img.xz` |
| Luckfox Lyra | `<Lyra/Lyra Plus/Lyra Pi/Lyra Ultra/Lyra Zero W>` | `<SPI Flash/eMMC/TF 卡>` | `<image-name>.img.xz` |

## 下载附件

每个镜像都必须同时上传对应的 SHA256 文件：

```text
<image-name>.img.xz
<image-name>.img.xz.sha256
```

请同时下载镜像和 SHA256 文件，并在解压前完成完整性校验。各主机系统的校验命令请查看仓库首页。

## 烧录说明

| 开发板型号 | 目标介质 | Windows | Linux（x86_64） | macOS |
| --- | --- | --- | --- | --- |
| `<完整型号>` | `<SPI Flash/eMMC/TF 卡>` | `<工具>` | `<工具或不支持>` | `<工具或不支持>` |

> [!CAUTION]
> 请使用表中指定的官方工具，不要使用 balenaEtcher 或 `dd` 替代。
