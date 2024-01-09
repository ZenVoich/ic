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