```text
            Spack-based Docker images for HPC & AI
   ____  ____    _    ____ _  __   _   _ ____   ____    _    ___
  / ___||  _ \  / \  / ___| |/ /  | | | |  _ \ / ___|  / \  |_ _|
  \___ \| |_) |/ _ \| |   | ' /   | |_| | |_) | |     / _ \  | |
   ___) |  __// ___ \ |___| . \   |  _  |  __/| |___ / ___ \ | |
  |____/|_|  /_/   \_\____|_|\_\  |_| |_|_|    \____/_/   \_\|___|  
           SPACK / MFEM / deal.II / CUDA / VSCode / GLVis
```

**Project:** `shubinuh/spack-hpc`
**Docker Hub:** https://hub.docker.com/r/shubinuh/spack-hpc
**Repository:** https://github.com/shubiuh/docker-spack-environment

---

## Version v2.3 (development)

======================================

---

## Version v2.2, released on Jan 19, 2026

======================================

**Build date:** Jan 19, 2026
**Image:** `shubinuh/spack-hpc:v2.2`
**Dockerfile:** `None, built from v2.1 container and then commit`
**Base image:** `shubinuh/spack-hpc:v2.1`

### Major additions

- Added **MFEM GPU development build** with **CUDA 12.6** support.
- Added **MFEM CPU development build** integrated into the default workspace.
- Added **deal.II CPU development build** for FEM research and benchmarking.

### HPC software stack

- Spack-based environment with a unified `/opt/view` prefix.
- Centralized compiler, MPI, and math libraries.
- Enabled support for:
  - MFEM (CPU + GPU)
  - deal.II (CPU)
  - Hypre, MUMPS, MPI toolchains
- CUDA toolchain targeting **sm_89** (Ada / Hopper-class GPUs).

### Runtime and process management

- Switched default runtime to **supervisord**.
- Added custom `supervisord.conf` managing:
  - VS Code Server
  - GLVis WebSocket server
  - User shell services
- Introduced a custom `/entrypoint.sh` for development startup logic.

### Developer experience

- Default working directory set to `/opt/software`.
- Preconfigured environment variables:
  - `PATH`
  - `CMAKE_PREFIX_PATH`
  - `PKG_CONFIG_PATH`
  - `ACLOCAL_PATH`
  - `MANPATH`
- Timezone set to `America/Los_Angeles`.
- Noninteractive Debian frontend for reproducible builds.

### Image size notes

- MFEM GPU development layer: ~8.9 GB
- MFEM + deal.II CPU development layer: ~3.6 GB
- Full image includes large Spack views and compiler stacks
  (expected for HPC + GPU development images).

---

## Version v2.1, rleased on Jan 18, 2026

==================================================

**Build date:** Jan 18, 2026
**Image:** `shubinuh/spack-hpc:v2.1`
**Dockerfile:** `None, built from v2.0 container and then commit`
**Base image:** `shubinuh/spack-hpc:v2.0`

### Purpose

- Add mfem GPU dev build using cuda 12.6 in mounted workspace (mfem_gpu_dev).
- Migrated base environment from Ubuntu-style image to **Euler-based HPC image**.

---

## Version v2.0, released on Jan 18, 2026

**Build date:** Jan 18, 2026
**Image:** `shubinuh/spack-hpc:v2.0`
**Dockerfile:** `None, built from v1.0 container and then commit`
**Base image:** `shubinuh/spack-hpc:v1.0`

### Purpose

- Provide a full **developer workstation container** for HPC/FEM work with:
  - Remote IDE (**OpenVSCode Server**)
  - Visualization (**glvis-js** via WebSocket)

### Notes

- This image targets **advanced FEM / CEM / HPC research**, including:
  - Large-scale MFEM GPU simulations
  - deal.II CPU reference runs
  - Remote visualization with GLVis
  - VS Code–based container development
- Image size is intentionally large to prioritize **developer productivity** over minimal footprint.

## Version 1.0, released on Jan 18, 2026

==================================================

**Build date:** Jan 18, 2026
**Image:** `shubinuh/spack-hpc:v1.0`
**Dockerfile:** `None, built from base container and then commit`
**Base image:** `shubinuh/spack-hpc:base`

### Purpose

- Provide a full **developer workstation container** for HPC/FEM work with:
  - Spack **dev environment installed**
  - C/C++ tooling (**clang/clangd**) for IntelliSense and debugging

### Spack environments (dev installed, prod staged)

* Re-created environment directories:
  * `/opt/env-dev`
  * `/opt/env-prod`
* Environment manifests:
  * `/opt/env-dev/spack.yaml` (from `spack.dev.yaml`)
  * `/opt/env-prod/spack.yaml` (from `spack.prod.yaml`)
* Production overlay file staged:
  * `/opt/env-prod/mfem_package.py`

### MFEM source tree override

* Replaced upstream MFEM clone with custom fork + branch:
  * Removed `/code/mfem`
  * Cloned `https://github.com/shubiuh/mfem.git` branch `v48` into `/code/mfem`

## Version develop, released on Jan 17, 2026

=========================================================

**Build date:** Jan 17, 2026
**Image:** `shubinuh/spack-hpc:develop`
**Dockerfile:** `Dockerfile.dev`
**Base image:** `shubinuh/spack-hpc:base`

### Purpose

- Provide a full **developer workstation container** for HPC/FEM work with:
  - Spack **dev environment installed**
  - C/C++ tooling (**clang/clangd**) for IntelliSense and debugging

### Build configuration

- `BUILD_SPACK_DEVELOP=true`
- `BUILD_SPACK_PRODUCTION=false`
- Example build command:
  ```bash
  docker build -f Dockerfile.dev \
    --build-arg BUILD_SPACK_DEVELOP=true \
    --build-arg BUILD_SPACK_PRODUCTION=false \
    -t shubinuh/spack-hpc:develop .
  ```

### System packages and tooling

* Added development tooling:
  * `gfortran`, `supervisor`, `sudo`
  * `git-lfs`
  * LLVM toolchain: `clang`, `clang-tools`, `clangd`
  * Build tools: `cmake`, `autoconf`, `automake`
  * Debugging: `gdb`
  * System libs: `libffi-dev`, `zlib1g-dev`, `libssl-dev`, `xz-utils`, `pkgconf`
  * Utilities: `wget`, `libarchive-tools`
* Set `clang`/`clang++` as default compilers via `update-alternatives`.

### Users

* Created unprivileged user:
  * `euler` (home: `/home/euler`, shell: `/bin/bash`)
* Granted passwordless sudo (developer convenience):
  * `euler ALL=(ALL) NOPASSWD:ALL`

### Spack environments (dev installed, prod staged)

* Re-created environment directories:
  * `/opt/env-dev`
  * `/opt/env-prod`
* Environment manifests:
  * `/opt/env-dev/spack.yaml` (from `spack.dev.yaml`)
  * `/opt/env-prod/spack.yaml` (from `spack.prod.yaml`)
* Production overlay file staged:
  * `/opt/env-prod/mfem_package.py`

### MFEM source tree override

* Replaced upstream MFEM clone with custom fork + branch:
  * Removed `/code/mfem`
  * Cloned `https://github.com/shubiuh/mfem.git` branch `v48` into `/code/mfem`

### Spack build behavior (this image)

* Dev environment  **installed** :
  * `spack env activate /opt/env-dev`
  * `spack concretize -f`
  * `spack install`
* Production environment **not installed** (skipped by build arg):
  * `/opt/env-prod` is present but not built.
* Custom MFEM Spack package override applied during builds:
  * Copied `mfem_package.py` into the active Spack builtin repo path.

### Cleanup and image hygiene

* Cleaned Spack caches:
  * `spack clean --all`
* Removed build directories under `/opt/software`:
  * `find /opt/software -type d -name build -exec rm -rf {} +`

### Compatibility fix

* Added symlink to satisfy LLVM lookup (e.g., mesa build expectations):
  * `/usr/bin/llvm-config -> /usr/bin/llvm-config-18`

## Version base, released on Jan 17, 2026

====================================================

**Build date:** Jan 17, 2026
**Image:** `shubinuh/spack-hpc:base`
**Dockerfile:** `Dockerfile.base`
**Base OS:** `ubuntu:24.04@sha256:a4453623f2f8319cfff65c43da9be80fe83b1a7ce689579b475867d69495b782`

### Purpose

- Provide a reproducible **HPC base image** with Spack configured, but **no Spack packages installed**.
- Serve as the foundation layer for downstream images (CPU dev, GPU dev, MFEM, deal.II, etc.).

### Build configuration

- Built with `BUILD_SPACK=false` (skip `spack concretize` and `spack install`).
- Example build command:
  ```bash
  docker build -f Dockerfile.base \
    --build-arg BUILD_SPACK=false \
    -t shubinuh/spack-hpc:base .
  ```

### Included components

* Ubuntu 24.04 pinned by digest (see Base OS above).
* Spack pinned to commit:
  * `7868be74d84e97c00e1e4677aefab3b98dfb41af`
* Default environment variables:
  * `DEBIAN_FRONTEND=noninteractive`
  * `TZ=America/Los_Angeles`
  * `SPACK_ENV=/opt/env`
* View-related paths pre-set:
  * `PATH=/opt/view/bin:/opt/spack/bin:$PATH`
  * `MANPATH=/opt/view/share/man:$MANPATH`
  * `PKG_CONFIG_PATH=/opt/view/lib/pkgconfig:/opt/view/lib64/pkgconfig:/opt/view/share/pkgconfig:$PKG_CONFIG_PATH`
  * `CMAKE_PREFIX_PATH=/opt/view`
  * `ACLOCAL_PATH=/opt/view/share/aclocal`

### Provisioning steps

* Installed base build tooling and Spack bootstrap via:
  * `./scripts/ubuntu/apt-install-defaults-plus-args.sh`
  * `./scripts/install-cmake-binary.sh`
  * `./scripts/set-up-spack.sh`
* Detected system compilers:
  * `spack compiler find`

### Spack environments staged

* Created environments:
  * `/opt/env-dev`
  * `/opt/env-prod`
* Copied manifests:
  * `/opt/env-dev/spack.yaml`
  * `/opt/env-prod/spack.yaml` (from `spack.prod.yaml`)

### Source trees cloned

* Cloned (shallow) into `/code`:
  * `https://github.com/mfem/mfem.git`
  * `https://github.com/dealii/dealii.git`

### Entry and default working directory

* Default `WORKDIR`: `/opt/software`
* Default entrypoint:
  * `ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/profile", "-l"]`

### Not included (by design)

* No Spack package installs (`spack install` not executed).
* No activated environment on login (activation script is only added when building with installs enabled).
* No MFEM/deal.II builds (only repositories cloned).
