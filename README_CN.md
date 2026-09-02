[English](README.md) | [简体中文](README_CN.md)

# Luckfox Ubuntu 镜像

本仓库用于统一发布和维护 Luckfox Lyra 系列开发板的 Ubuntu 系统镜像，覆盖 Lyra、Lyra Plus、Lyra Pi、Lyra Ultra 和 Lyra Zero W。镜像文件通过 [GitHub Releases](../../releases) 发布，每次 Release 可以同时包含多个型号和多种存储介质的镜像。

下载前请核对开发板完整型号和目标存储介质。不同型号、不同介质的镜像不能混用。

## 支持型号

| 产品系列 | 开发板型号 | 镜像版本与介质 | Release 说明 |
| --- | --- | --- | --- |
| Luckfox Lyra | Lyra | 以 Release Assets 为准 | [查看说明](releases/202609_CN.md) |
| Luckfox Lyra | Lyra Plus | 以 Release Assets 为准 | [查看说明](releases/202609_CN.md) |
| Luckfox Lyra | Lyra Pi | 以 Release Assets 为准 | [查看说明](releases/202609_CN.md) |
| Luckfox Lyra | Lyra Ultra | 以 Release Assets 为准 | [查看说明](releases/202609_CN.md) |
| Luckfox Lyra | Lyra Zero W | 以 Release Assets 为准 | [查看说明](releases/202609_CN.md) |

## 下载文件

请根据开发板型号和目标介质，从同一个 Release 中下载镜像压缩包及其对应的 SHA256 校验文件。

以下以 Lyra Pi A eMMC 镜像为例；实际操作时，请将后续命令中的文件名替换为自己下载的镜像文件名：

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

## 校验 SHA256

必须先确认镜像下载完整，校验通过后才能解压和烧录。如果校验失败，请删除文件并重新下载。

以下校验命令继续使用 Lyra Pi A eMMC 镜像作为示例。

### Linux

进入下载目录后执行：

```bash
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

校验成功时会显示：

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz: OK
```

### macOS

如果系统已经提供 `sha256sum`，执行：

```bash
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

如果系统只有自带的 `shasum`，分别查看两个校验值并确认它们完全一致：

```bash
shasum -a 256 Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
cat Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

### Windows PowerShell

在镜像所在目录打开 PowerShell，分别查看实际校验值和 Release 提供的校验值：

```powershell
Get-FileHash .\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
Get-Content .\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

`Get-FileHash` 输出中的 `Hash` 必须与 `.sha256` 文件开头的校验值完全一致，字母大小写可以不同。也可以使用以下命令自动比较：

```powershell
$file = ".\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz"
$actual = (Get-FileHash -Algorithm SHA256 $file).Hash
$expected = ((Get-Content "$file.sha256" -Raw).Trim() -split '\s+')[0]
if ($actual -ieq $expected) { "SHA256: OK" } else { "SHA256: FAILED" }
```

只有显示 `SHA256: OK` 才能继续操作。

## 解压镜像

Linux 或安装了 XZ Utils 的 macOS 可以执行：

```bash
xz -d -k Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
```

Windows 可以使用 7-Zip 解压 `.xz` 文件。解压后会得到：

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img
```

## 烧录镜像

> [!CAUTION]
> 本仓库发布的 Lyra 系列镜像不支持使用 balenaEtcher 或 Linux `dd` 烧录，必须使用下表中的 Rockchip 官方工具。使用错误工具可能导致设备无法启动。

### Lyra 系列工具支持

| 主机系统 | 目标介质 | 烧录工具 | 支持状态 |
| --- | --- | --- | --- |
| Windows | SPI Flash、eMMC | RKDevTool | 支持 |
| Windows | TF 卡 | SDDiskTool | 支持 |
| Linux（x86_64） | SPI Flash、eMMC | Upgrade_Tool | 支持 |
| Linux（x86_64） | TF 卡 | 暂无 | 不支持 |
| macOS | SPI Flash、eMMC | `upgrade_tool` | 支持 |
| macOS | TF 卡 | 暂无 | 不支持 |

### eMMC 镜像示例

以 `Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img` 为例，eMMC 镜像可以按主机系统选择工具：

- Windows 使用 RKDevTool。
- Linux（仅 x86_64）使用 Upgrade_Tool。
- macOS 使用 `upgrade_tool`。

烧录前需要使开发板进入对应的升级模式。工具版本、USB 连接方式、升级模式和具体操作参数请遵循实际开发板型号的烧录文档。

### TF 卡镜像

Lyra 系列 TF 卡镜像只能在 Windows 环境下使用 SDDiskTool 烧录。目前 Linux 和 macOS 缺少对应的 TF 卡烧录工具，不要使用 balenaEtcher、`dd` 或其他磁盘写入工具替代。

## 首次启动

1. 等待官方烧录工具提示操作成功后再断开设备。
2. 按开发板文档退出升级模式并重新上电。
3. 首次启动可能比后续启动耗时更长。
4. 默认账号、密码及镜像配置请查看对应 Release 说明。

## 发布维护

以下发布命令同样以 Lyra Pi A eMMC 镜像为例。生成压缩包：

```bash
xz -T0 -6 -k -v Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img
```

生成并复核 SHA256 校验文件：

```bash
sha256sum Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz \
  > Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

推送 Release Tag 前，请将对应的英文发布说明保存为 `releases/<version>.md`。GitHub Actions 会将该文件发布为 Release 正文。
