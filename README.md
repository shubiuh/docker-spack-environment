# Spack-Based HPC Development Environment

This workspace builds a Docker image with a Spack environment for MFEM (and optionally deal.II) and presents installed software via a view. It supports active development against local source trees under `/code`.

## Files

- Dockerfile: see `Dockerfile.base` — builds the image, installs packages via Spack, and configures auto-activation.
- Spack environment: `spack.yaml` — declares specs, view location, and `develop` entries for building from local sources.

## Build the Image

```bash
# From the repo root
docker build -f Dockerfile.base -t hpc-dev .
```

## Run the Container

```bash
# Start an interactive login shell with the Spack environment active
docker run -it --rm hpc-dev

# Mount a host directory (Windows path example) to /mnt in the container
docker run -it --rm -v D:\docker_ws:/mnt hpc-dev
```

## Development Workflow (MFEM)

- Source location: `/code/mfem` (cloned during build).
- Spack is configured to build MFEM from `/code/mfem` with variants via `develop:` in `spack.yaml`.

Rebuild after making changes:

```bash
# Inside the container
cd /opt/hpc-env
. /opt/spack/share/spack/setup-env.sh
spack env activate .
spack install --force mfem@master+examples+miniapps
```

Use installed artifacts from the view:

```bash
# Binaries / headers / libraries (copy/symlink view)
ls /opt/views/view/bin
ls /opt/views/view/include
ls /opt/views/view/lib /opt/views/view/lib64

# Example: confirm mfem install
mfem-config --prefix
```

## Optional: Development Workflow (deal.II)

If you enabled the `dealii` develop entry:

- Clone source into `/code/dealii` (similar to MFEM):

```bash
# Modify Dockerfile to clone deal.II or clone after container start
cd /code
git clone --depth=1 https://github.com/dealii/dealii.git dealii
```

- Rebuild:

```bash
cd /opt/hpc-env
. /opt/spack/share/spack/setup-env.sh
spack env activate .
spack install --force dealii@9.7.1~adol-c~arborx~arpack~assimp~cgal+complex~cuda~doc~examples~ginkgo~gmsh+gsl~hdf5~int64~ipo+kokkos+metis+mpi+muparser~nanoflann~netcdf~optflags+p4est+petsc+platform-introspection+python+scalapack+simplex+slepc~sundials~symengine+taskflow~threads~trilinos~vtk build_type=Release
```

## Environment & View

- The Spack view is configured at `/opt/views/view`.
- The Docker image appends activation commands to `/etc/profile.d/z10_spack_environment.sh`, so login shells start with the environment enabled.
- `activate.sh` (if used) exports common variables like `CMAKE_PREFIX_PATH`, `PETSC_DIR`, `SLEPC_DIR`, and sets `PATH`, `LD_LIBRARY_PATH`, etc.

## Image Size & Cleanup

The Dockerfile runs:

```bash
spack clean --all
find /opt/software -type d -name build -exec rm -rf {} + 2>/dev/null || true
```

This removes cached sources and build directories, reducing image size while keeping installed binaries/headers/libs in the view.

## Troubleshooting

- If the environment isn’t active, source profile:

```bash
source /etc/profile
```

- If `mfem-config` isn’t found, ensure `/opt/views/view/bin` is on `PATH` or activate the env:

```bash
. /opt/spack/share/spack/setup-env.sh
spack env activate /opt/hpc-env
```

- For path mismatches, verify `develop:` entries in `spack.yaml` match actual source locations (e.g., `/code/mfem`, `/code/dealii`).

## Notes

- With unified concretization (`unify: true` / `together`), shared dependencies (MPI, PETSc, SLEPc) are resolved once. Adjust variants if conflicts arise.
- Prefer a single MPI implementation (e.g., MPICH) across all specs for ABI compatibility.
