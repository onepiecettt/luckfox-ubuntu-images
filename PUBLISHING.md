# 镜像发布检查清单

## 镜像信息

- [ ] 已确认产品系列、开发板完整型号和硬件版本。
- [ ] 已确认 Lyra、Lyra Plus、Lyra Pi、Lyra Ultra 和 Lyra Zero W 的附件没有混用。
- [ ] 已确认目标介质是 SPI Flash、eMMC 还是 TF 卡。
- [ ] 镜像已在对应开发板上完成启动测试。
- [ ] Release 文档中的文件名与实际附件完全一致。

## 压缩与校验

```bash
xz -T0 -6 -k -v <image-name>.img
sha256sum <image-name>.img.xz > <image-name>.img.xz.sha256
sha256sum -c <image-name>.img.xz.sha256
```

- [ ] 每个 `.img.xz` 都有对应的 `.img.xz.sha256`。
- [ ] 已从 Release 重新下载附件并验证 SHA256。
- [ ] 已确认 Windows PowerShell 校验说明可用于该文件名。

## 烧录验证

- [ ] 已使用对应主机系统的 Rockchip 官方工具完成烧录测试。
- [ ] 没有将 balenaEtcher 或 `dd` 写成 Lyra 系列镜像的可用烧录方式。
- [ ] Lyra TF 卡镜像注明只能在 Windows 下使用 SDDiskTool。
- [ ] Lyra TF 卡镜像注明 Linux 和 macOS 暂无烧录工具。

## GitHub Release

建议 Tag：

```text
ubuntu-images-<YYYYMM>
```

- [ ] 同一次 Release 的全部镜像统一写入一份 Markdown。
- [ ] 后续版本已填写实际更新内容；首次发布只保留简单说明。
- [ ] 已上传全部镜像压缩包及 SHA256 文件。
- [ ] 已更新首页支持型号列表和对应 Release 链接。

最终文案保存为 `releases/<version>.md`，镜像文件只上传到 GitHub Release，不提交到 Git 历史。
