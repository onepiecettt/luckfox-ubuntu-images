# Luckfox Ubuntu 镜像

本仓库用于统一发布和维护多个 Luckfox 产品系列及开发板型号的 Ubuntu 系统镜像，不限定于某一个型号。镜像文件不直接存放在 Git 仓库中，请先在下方索引中确认**产品系列、具体型号、启动介质和版本**，再前往 [Releases](../../releases) 下载对应的镜像压缩包和 SHA256 校验文件。

## 镜像索引

| 产品系列 | 具体型号 | 启动介质 | 最新版本 | Release 说明 | 下载 |
| --- | --- | --- | --- | --- | --- |
| Luckfox Pi | Luckfox Pi B | MicroSD 卡 | `202609` | [查看说明](releases/202609.md) | [前往 Releases](../../releases) |

后续增加其他型号时，在此表新增一行即可。不同型号的镜像不能混用，即使文件大小或启动介质相同，也必须下载与开发板完整型号一致的版本。

推荐使用以下文件命名规则：

```text
Ubuntu_<开发板型号>_<启动介质>_<YYYYMM>.img.xz
Ubuntu_<开发板型号>_<启动介质>_<YYYYMM>.img.xz.sha256
```

例如，Luckfox Pi B 的 `202609` 版本应同时提供：

```text
Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz
Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz.sha256
```

## 下载并校验

将镜像压缩包和对应的 `.sha256` 文件下载到同一个目录，然后执行：

```bash
sha256sum -c Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz.sha256
```

看到以下信息表示文件完整：

```text
Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz: OK
```

如果校验失败，请删除文件并重新下载，不要继续烧录。

## 解压镜像

Linux 下安装 `xz-utils`，并在保留原压缩包的情况下解压：

```bash
sudo apt update
sudo apt install -y xz-utils
xz -d -k Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz
```

解压完成后会得到：

```text
Ubuntu_Luckfox_Pi_B_MicroSD_202609.img
```

以当前 Luckfox Pi B `202609` 版本为例，压缩包约为 `263 MiB`，解压后的镜像约为 `2.1 GiB`。其他型号和版本的实际大小以对应 Release 说明为准。

## 烧录镜像

> [!WARNING]
> 烧录会覆盖目标存储设备上的全部数据。请仔细核对 Release 的适用型号和设备名，不要混用其他型号的镜像，也不要把系统硬盘误写为目标设备。

不同产品系列支持的主机系统、存储介质和烧录工具可能不同。请先确认开发板系列和目标介质，再选择烧录方式。

### Lyra 系列

Lyra 系列开发板支持在 Windows、Linux（x86_64）和 macOS 环境下进行镜像烧录。请根据所使用的主机操作系统选择对应的烧录方式。

| 主机系统 | 支持烧录介质 | 烧录工具 |
| --- | --- | --- |
| Windows | SPI Flash、eMMC、TF 卡 | RKDevTool、SDDiskTool |
| Linux（x86_64） | SPI Flash、eMMC | Upgrade_Tool |
| macOS | SPI Flash、eMMC | `upgrade_tool` |

- Windows 下烧录 SPI Flash 或 eMMC 使用 RKDevTool，制作 TF 卡使用 SDDiskTool。
- Linux（x86_64）下烧录 SPI Flash 或 eMMC 使用 Upgrade_Tool。
- macOS 下烧录 SPI Flash 或 eMMC 使用 `upgrade_tool`。
- 具体工具版本、设备进入升级模式的方法及参数，以对应 Release 和开发板文档为准。

### 完整磁盘镜像

以下方法只适用于 Release 明确标注为“可写入 TF 卡、MicroSD 卡或其他可移动存储设备”的完整 `.img` 镜像，不能代替 Lyra 系列烧录 SPI Flash 或 eMMC 所需的专用工具。

#### 图形界面工具

1. 安装并打开 [balenaEtcher](https://etcher.balena.io/)。
2. 选择下载的 `.img.xz` 压缩包，无需手动解压。
3. 选择要烧录的目标存储设备。
4. 点击 **Flash**，等待写入和校验完成。
5. 安全弹出存储设备，将其连接到镜像对应型号的开发板后上电。

#### Linux 命令行

1. 插入目标存储设备，查看设备名：

   ```bash
   lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS
   ```

2. 确认目标设备。下面以 MicroSD 卡 `/dev/sdX` 为例，实际设备也可能是 `/dev/mmcblk0`。卸载该设备上已经挂载的所有分区：

   ```bash
   sudo umount /dev/sdX1
   sudo umount /dev/sdX2
   ```

   只需卸载实际存在并已挂载的分区。不要对分区执行格式化操作。

3. 将镜像写入整块设备。`of` 必须是 `/dev/sdX`，不能是 `/dev/sdX1` 这样的分区：

   ```bash
   sudo dd if=Ubuntu_Luckfox_Pi_B_MicroSD_202609.img \
     of=/dev/sdX bs=4M status=progress conv=fsync
   ```

4. 等待数据完全写入，然后安全弹出设备：

   ```bash
   sync
   sudo eject /dev/sdX
   ```

如果不想保留解压后的 `.img` 文件，也可以直接解压并烧录：

```bash
xzcat Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz | \
  sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
```

## 首次启动

1. 将烧录好的存储设备连接到对应型号的 Luckfox 开发板。
2. 连接串口或显示器、网络等所需外设。
3. 给开发板上电，首次启动可能比后续启动耗时更长。
4. 默认账号、密码及镜像的具体配置请查看对应版本的 Release 说明。

## 发布者说明

生成压缩包：

```bash
xz -T0 -6 -k -v Ubuntu_Luckfox_Pi_B_MicroSD_202609.img
```

生成并验证 SHA256 校验文件：

```bash
sha256sum Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz \
  > Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz.sha256
sha256sum -c Ubuntu_Luckfox_Pi_B_MicroSD_202609.img.xz.sha256
```

发布前请按照 [发布检查清单](PUBLISHING.md) 操作。通用的 Release 文案位于 [RELEASE_TEMPLATE.md](RELEASE_TEMPLATE.md)，`202609` 版本的 Release 文案位于 [releases/202609.md](releases/202609.md)。

每次 GitHub Release 只维护一份 Markdown，其中可以列出多个型号和多个启动介质的镜像：

```text
releases/
├── 202609.md
├── 202610.md
└── ...
```

## 问题反馈

反馈问题时，请提供开发板型号、镜像文件名、供电方式、启动日志以及问题复现步骤。
