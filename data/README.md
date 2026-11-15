# Datos (no se versionan)

Los datos de OpenCEM **no se suben a este repositorio** (son pesados y tienen su propia licencia, CC BY 4.0).

## Descarga
1. Ir a Zenodo: https://doi.org/10.5281/zenodo.21436223
2. Descargar:
   - el archivo `.sqlite.zst`
   - el zip de soporte
   - el archivo de SHA256
3. Guardarlos en esta carpeta (`data/`). El `.gitignore` los excluye.

## Verificar integridad
```bash
sha256sum -c <archivo_sha256>      # Linux / WSL / macOS (shasum -a 256 -c)
```

## Descomprimir
```bash
zstd -d <archivo>.sqlite.zst
```

El `.sqlite` resultante es la capa **Bronze**: solo lectura, nunca se modifica.
