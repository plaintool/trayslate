# OpenSSL Windows DLLs

This repository contains prebuilt OpenSSL DLLs for Microsoft Windows.

## Included Versions

- OpenSSL 1.1.x
- OpenSSL 3.x

## Included Architectures

| File | Architecture | OpenSSL Version |
|------|--------------|-----------------|
| `libcrypto-1_1.dll` | x86 | 1.1.x |
| `libssl-1_1.dll` | x86 | 1.1.x |
| `libcrypto-1_1-x64.dll` | x64 | 1.1.x |
| `libssl-1_1-x64.dll` | x64 | 1.1.x |
| `libcrypto-3.dll` | x86 | 3.x |
| `libssl-3.dll` | x86 | 3.x |
| `libcrypto-3-x64.dll` | x64 | 3.x |
| `libssl-3-x64.dll` | x64 | 3.x |

## Purpose

These binaries are provided as a convenient way to use OpenSSL in Windows applications without building the library from source.

## Source

The binaries are built from the official OpenSSL source code.

Official project:
https://github.com/openssl/openssl

## License

These binaries are distributed under the original OpenSSL licenses.

- OpenSSL 1.1.x is licensed under the OpenSSL License and the SSLeay License.
- OpenSSL 3.x is licensed under the Apache License 2.0.

See the `LICENSES` directory for the complete license texts.

## Disclaimer

This repository only redistributes unmodified OpenSSL binaries.

OpenSSL is developed and maintained by the OpenSSL Project. This repository is not affiliated with or endorsed by the OpenSSL Project.