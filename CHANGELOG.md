## 3.2.0
- Decoupled `TransformFunction` from `Transform` type

## 3.1.0

Updated types:
- `HttpRequestArgs` - Added experimental `is_replicated` field to switch between replicated and non-replicated http outcalls

## 3.0.0

Added methods:
- `subnet_info` - Get subnet information including replica version
- `vetkd_derive_key` - Derive encrypted keys using vetKD
- `vetkd_public_key` - Get public keys for vetKD

Added types:
- `SchnorrAux` - Auxiliary data for Schnorr signatures
- `SubnetInfoArgs` and `SubnetInfoResult` - For subnet information queries
- `VetkdCurve`, `VetkdDeriveKeyArgs`, `VetkdDeriveKeyResult`, `VetkdPublicKeyArgs`, `VetkdPublicKeyResult` - For vetKD (Verifiable Encrypted Threshold Key Derivation) support

Updated types:
- `CanisterSettings` - Added `wasm_memory_threshold` field
- `CanisterStatusResult` - Added `memory_metrics` field with detailed memory usage information
- `DefiniteCanisterSettings` - Added `wasm_memory_threshold` field
- `LogVisibility` - Added `#allowed_viewers` option for fine-grained log access control
- `SignWithSchnorrArgs` - Added optional `aux` field for auxiliary data
- `UninstallCodeArgs` - Renamed from `uninstall_code_args` for consistency

## 2.1.0
- Added wrappers for `ic` calls like `http_request` that automatically calculate the minimum amount of cycles and attach them with the call (by @Kamirus)

## 2.0.0

Changes:
- Added `#regtest` to `BitcoinNetwork` type

Added methods:
- `bitcoin_get_block_headers`
- `delete_canister_snapshot`
- `fetch_canister_logs`
- `list_canister_snapshots`
- `load_canister_snapshot`
- `schnorr_public_key`
- `sign_with_schnorr`
- `take_canister_snapshot`

Removed methods:
- `bitcoin_get_balance_query` (query version removed)
- `bitcoin_get_utxos_query` (query version removed)

## 1.0.1
- Add license and keywords to `mops.toml`

## 1.0.0
- Updated interface to the latest version
- New methods:
  - `bitcoin_get_balance_query`
  - `bitcoin_get_utxos_query`
  - `canister_info`
  - `node_metrics_history`
  - `install_chunked_code`
  - `stored_chunks`
  - `upload_chunk`
  - `clear_chunk_store`

**Breaking changes**:
- All `[Nat8]` types are now `Blob`