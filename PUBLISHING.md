# 镜像发布检查清单

## 1. 准备镜像

- [ ] 确认镜像能够正常启动。
- [ ] 确认产品系列、开发板完整型号及硬件版本。
- [ ] 确认 Ubuntu 版本、内核版本、系统架构和启动介质。
- [ ] 确认镜像没有在外观相似的其他型号上被误标为兼容。
- [ ] 确认默认账号、密码及 SSH 状态。
- [ ] 清除镜像中的构建缓存、临时文件和敏感信息。

## 2. 压缩和校验

```bash
xz -T0 -6 -k -v <image-name>.img
sha256sum <image-name>.img.xz > <image-name>.img.xz.sha256
sha256sum -c <image-name>.img.xz.sha256
```

- [ ] 校验结果为 `OK`。
- [ ] 文件名包含开发板、启动介质和版本号。
- [ ] 在一台干净环境中重新下载、校验并测试烧录。

## 3. 创建 GitHub Release

建议 Tag 格式：

```text
ubuntu-images-<YYYYMM>
```

例如：

```text
ubuntu-images-202609
```

- [ ] 从 `RELEASE_TEMPLATE.md` 复制并填写本次 Release 说明。
- [ ] 在同一份“镜像列表”中列出本次发布的全部型号、介质和附件名。
- [ ] 删除全部 `TODO` 和占位符。
- [ ] 上传 `.img.xz` 和 `.img.xz.sha256` 两个附件。
- [ ] 确认 Release 标题、Tag 和镜像版本一致。
- [ ] 发布后检查附件可以正常下载。
- [ ] 更新首页“镜像索引”中的产品系列、型号、介质和最新版本。

## 4. 保留发布记录

每次 Release 只保留一份 Markdown，并保存为 `releases/<version>.md`。同一次 Release 中的不同型号镜像统一列在这份文档中，不按产品拆分 Markdown。镜像二进制文件只上传到 GitHub Release，不提交到 Git 历史。
