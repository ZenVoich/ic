# IC management canister interface

[![mops](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/mops/ic)](https://mops.one/ic)
[![documentation](https://oknww-riaaa-aaaam-qaf6a-cai.raw.ic0.app/badge/documentation/ic)](https://mops.one/ic/docs)

Based on https://github.com/dfinity/portal/blob/master/docs/references/_attachments/ic.did

See [Call](https://mops.one/ic/docs/Call) module documentation for automatic calculation of the minimum amount of cycles and attaching them to the call.

## Examples

### Import
```motoko
import IC "mo:ic";
let ic = actor("aaaaa-aa") : IC.Service;
```
or
```motoko
import {ic} "mo:ic";
```

### Fetch canister status
```motoko
import {ic} "mo:ic";

let canisterId = Principal.fromText("e3mmv-5qaaa-aaaah-aadma-cai");
let canisterStatus = await ic.canister_status({canister_id = canisterId});

Debug.print("status = " # debug_show canisterStatus.status);
Debug.print("memory_size = " # debug_show canisterStatus.memory_size);
Debug.print("module_hash = " # debug_show canisterStatus.module_hash);
Debug.print("settings = " # debug_show canisterStatus.settings);
```

### Update canister settings
Here we set the canister controllers to a single blackhole canister.
```motoko
import {ic; CanisterSettings} "mo:ic";

let canisterId = Principal.fromText("e3mmv-5qaaa-aaaah-aadma-cai");
let settings : CanisterSettings = {
	freezing_threshold = null;
	controllers = ?[Principal.fromText("e3mmv-5qaaa-aaaah-aadma-cai")];
	memory_allocation = null;
	compute_allocation = null;
};
await ic.update_settings({
	canister_id = canisterId;
	settings = settings;
});
```