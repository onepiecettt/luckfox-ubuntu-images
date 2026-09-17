# GitHub 自动同步到 Gitee

GitHub 是日常维护入口。每次向 GitHub 推送 `main` 或标签，`Sync to Gitee` 工作流会同步当前 `main` 和全部标签到：

https://gitee.com/onepiecettt/luckfox-ubuntu-images

也可以在 GitHub 的 **Actions → Sync to Gitee → Run workflow** 手动触发。

## 首次配置

1. 生成一对专门用于本项目同步的 SSH 密钥，不设置口令，私钥保存在仓库目录之外。
2. 将公钥添加到有目标仓库写权限的 Gitee 账号的 **设置 → SSH 公钥**。仓库的部署公钥仅支持拉取，不能用于自动推送。
3. 在 GitHub 本仓库的 **Settings → Secrets and variables → Actions → New repository secret** 添加：
   - 名称：`GITEE_SSH_PRIVATE_KEY`
   - 值：完整私钥文本，包括 BEGIN 和 END 行。
4. 将工作流推送至 GitHub 的 `main`，或手动运行一次。
5. 首次同步完成后，在 Gitee 检查默认分支为 `main`。

无需设置 GitHub Personal Access Token。工作流使用只读的 GitHub 仓库权限和专用 SSH 密钥向 Gitee 推送。

Gitee 地址固定在工作流中。SSH 主机公钥固定在 `.github/gitee_known_hosts`，已对照 [Gitee 官方公布的主机公钥和指纹](https://help.gitee.com/account/gitees-ssh-key-fingerprints) 核验。

## 同步范围

- 同步 `main` 的文件、提交历史，以及 Git 标签。
- 标签触发时仍同步 GitHub 当前的 `main`，不会把旧标签对应的提交推成默认分支。
- 不自动删除 Gitee 标签，不强制覆盖不同的历史，不同步其他分支。
- GitHub Releases 的正文和镜像附件不属于 Git 仓库内容，不通过这个工作流复制。镜像继续从 GitHub Releases 下载。
- 日常新增、修改和删除文件后，正常提交并推送 GitHub 即可，无需手工操作 Gitee。

## 检查同步结果

查看 [GitHub Actions](https://github.com/onepiecettt/luckfox-ubuntu-images/actions/workflows/sync-gitee.yml) 中最新运行是否成功，再对比两边分支和标签：

```bash
git ls-remote https://github.com/onepiecettt/luckfox-ubuntu-images.git refs/heads/main 'refs/tags/*'
git ls-remote https://gitee.com/onepiecettt/luckfox-ubuntu-images.git refs/heads/main 'refs/tags/*'
```

同名引用的提交编号应相同。

## 常见失败

- `Add the GITEE_SSH_PRIVATE_KEY repository secret`：GitHub 仓库 Secret 未设置或名称不正确。
- `Permission denied (publickey)`：Gitee 未添加对应公钥，或公钥所属账号没有目标仓库写权限。
- `DeployKey does not support push code`：Gitee 将密钥识别为只读部署公钥。将公钥改为账号 SSH 公钥，并确保该账号有仓库写权限。
- `non-fast-forward`：Gitee 的 `main` 有独立提交。先比较两边历史并保留需要的修改，再重新运行。
- 标签已存在且拒绝更新：两边同名标签指向不同对象，需要先人工确认正确版本。
- `Host key verification failed`：对照 Gitee 官方主机指纹核验后，更新 `.github/gitee_known_hosts`。
- 超时或暂时无法连接：在 Actions 页面重跑失败的工作流。

请将私钥仅用于 GitHub Actions Secret，勿提交到 Git 仓库。
