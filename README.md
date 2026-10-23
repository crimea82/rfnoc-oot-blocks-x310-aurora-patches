# RFNoC OOT Blocks X310 Aurora Patches

Patches against the Ettus [rfnoc-oot-blocks](https://github.com/EttusResearch/rfnoc-oot-blocks)
repository that add X310 support to the Aurora RFNoC block. Two SFP configurations
are supported:

- **X310_AA** — Aurora on SFP0 (left/top port), 1 GigE on SFP1
- **X310_AA1** — Aurora on SFP1 (right/bottom port), 1 GigE on SFP0

## Prerequisites

Patched UHD 4.10.0.0 must be built and installed before building the bitfile.
See the uhd-x310-aurora-patches repo for instructions.

## Usage

```
make          # clone rfnoc-oot-blocks from Ettus and apply patches
make clean    # remove the cloned source tree
```

The source repo URL and base commit can be overridden:

```
make RFNOC_REPO=https://github.com/EttusResearch/rfnoc-oot-blocks.git
```

## Building the X310 Aurora bitfile

Set `UHD_FPGA_DIR` to the `fpga/` directory of the patched UHD source tree
(required because the modified RTL files are not installed by `cmake --install`).

**Aurora on SFP0, 1 GigE on SFP1 (X310_AA):**

```bash
cd rfnoc-oot-blocks
rfnoc_image_builder -y icores/x310_Aurora_rfnoc_image_core.yml \
    -t X310_AA \
    -I . \
    -F /path/to/uhd/fpga \
    -p /tools/Xilinx/Vivado \
    -j $(nproc)
```

**Aurora on SFP1, 1 GigE on SFP0 (X310_AA1):**

```bash
cd rfnoc-oot-blocks
rfnoc_image_builder -y icores/x310_Aurora1_rfnoc_image_core.yml \
    -t X310_AA1 \
    -I . \
    -F /path/to/uhd/fpga \
    -C . \
    -p /tools/Xilinx/Vivado \
    -j $(nproc)
```

## Output files

Bitfiles are written to `build/` relative to the working directory:

```
build/usrp_x310_fpga_Aurora.bit
build/usrp_x310_fpga_Aurora.bin
build/usrp_x310_fpga_Aurora.lvbitx
build/usrp_x310_fpga_Aurora.rpt
```

## Network configuration

The X310 stores IP addresses in EEPROM with factory defaults:

- SFP0 (eth0): `192.168.10.2`
- SFP1 (eth1): `192.168.20.2`

**X310_AA** (Aurora on SFP0): SFP0 is aurora and bypasses Ethernet entirely.
Connect the host NIC to SFP1 and set the host address to `192.168.20.1/24`.

**X310_AA1** (Aurora on SFP1): SFP1 is aurora. Connect the host NIC to SFP0
and set the host address to `192.168.10.1/24`.

You can verify or update the stored IP with:

```bash
uhd_image_loader --args="type=x300,addr=<current-ip>" --just-check-rev
```
