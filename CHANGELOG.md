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