[English](README.md) | [简体中文](README_CN.md)

# Luckfox Ubuntu Images

This repository publishes and maintains Ubuntu images for the Luckfox Lyra family, including Lyra, Lyra Plus, Lyra Pi, Lyra Ultra, and Lyra Zero W. Images are distributed through [GitHub Releases](../../releases), and each release may contain images for multiple boards and storage media.

Before downloading, check the complete board model and target storage medium. Images for different models or storage media are not interchangeable.

## Supported Boards

| Product family | Board model | Image version and storage | Release notes |
| --- | --- | --- | --- |
| Luckfox Lyra | Lyra | See the Release assets | [View release notes](releases/202609.md) |
| Luckfox Lyra | Lyra Plus | See the Release assets | [View release notes](releases/202609.md) |
| Luckfox Lyra | Lyra Pi | See the Release assets | [View release notes](releases/202609.md) |
| Luckfox Lyra | Lyra Ultra | See the Release assets | [View release notes](releases/202609.md) |
| Luckfox Lyra | Lyra Zero W | See the Release assets | [View release notes](releases/202609.md) |

## Download Files

Select the image for your board model and target storage medium, then download both the compressed image and its matching SHA-256 checksum file from the same Release.

The commands below use a Lyra Pi A eMMC image as an example. Replace the filenames with those of the image you downloaded:

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

## Verify SHA-256

Always verify that the image was downloaded completely before extracting or flashing it. If verification fails, delete both files and download them again.

The following commands continue to use the Lyra Pi A eMMC image as an example.

### Linux

Open a terminal in the download directory and run:

```bash
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

A successful verification displays:

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz: OK
```

### macOS

If `sha256sum` is available, run:

```bash
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

If only the built-in `shasum` command is available, display both checksums and confirm that they match exactly:

```bash
shasum -a 256 Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
cat Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

### Windows PowerShell

Open PowerShell in the image directory and display the calculated and expected checksums:

```powershell
Get-FileHash .\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
Get-Content .\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

The `Hash` printed by `Get-FileHash` must match the checksum at the beginning of the `.sha256` file. Letter case does not matter. You can also compare them automatically:

```powershell
$file = ".\Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz"
$actual = (Get-FileHash -Algorithm SHA256 $file).Hash
$expected = ((Get-Content "$file.sha256" -Raw).Trim() -split '\s+')[0]
if ($actual -ieq $expected) { "SHA256: OK" } else { "SHA256: FAILED" }
```

Continue only if the command displays `SHA256: OK`.

## Extract the Image

On Linux, or on macOS with XZ Utils installed, run:

```bash
xz -d -k Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz
```

On Windows, use 7-Zip to extract the `.xz` archive. The extracted file is:

```text
Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img
```

## Flash the Image

> [!CAUTION]
> The Lyra images published by this repository cannot be flashed with balenaEtcher or Linux `dd`. You must use the Rockchip tool listed below. Using an unsupported tool may leave the board unable to boot.

### Supported Tools for the Lyra Family

| Host system | Target storage | Flashing tool | Status |
| --- | --- | --- | --- |
| Windows | SPI Flash, eMMC | RKDevTool | Supported |
| Windows | TF card | SDDiskTool | Supported |
| Linux (x86_64) | SPI Flash, eMMC | Upgrade_Tool | Supported |
| Linux (x86_64) | TF card | Not available | Not supported |
| macOS | SPI Flash, eMMC | `upgrade_tool` | Supported |
| macOS | TF card | Not available | Not supported |

### eMMC Image Example

Using `Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img` as an example, select the eMMC flashing tool for your host system:

- Use RKDevTool on Windows.
- Use Upgrade_Tool on Linux x86_64.
- Use `upgrade_tool` on macOS.

Before flashing, put the board into the required upgrade mode. Follow the documentation for your exact board model for the supported tool version, USB connection, upgrade mode, and command parameters.

### TF Card Images

Lyra TF card images can only be flashed with SDDiskTool on Windows. A supported TF card flashing tool is not currently available for Linux or macOS. Do not substitute balenaEtcher, `dd`, or another disk-writing tool.

## First Boot

1. Wait for the official flashing tool to report success before disconnecting the device.
2. Exit upgrade mode as described in the board documentation, then power-cycle the board.
3. The first boot may take longer than subsequent boots.
4. See the corresponding Release notes for default credentials and image-specific configuration.

## For Maintainers

The following commands use the Lyra Pi A eMMC image as an example. Create the compressed archive with:

```bash
xz -T0 -6 -k -v Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img
```

Generate and verify the SHA-256 checksum file:

```bash
sha256sum Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz \
  > Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
sha256sum -c Ubuntu_Luckfox_Lyra_Pi_A_eMMC_202609.img.xz.sha256
```

Before pushing a release tag, add the corresponding English release notes as `releases/<version>.md`. The GitHub Actions workflow publishes that file as the Release body.
