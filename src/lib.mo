module {
	public type BitcoinAddress = Text;
	public type BitcoinNetwork = { #mainnet; #testnet };
	public type BlockHash = [Nat8];
	public type CanisterId = Principal;
	public type CanisterSettings = {
		freezing_threshold : ?Nat;
		controllers : ?[Principal];
		memory_allocation : ?Nat;
		compute_allocation : ?Nat;
	};
	public type DefiniteCanisterSettings = {
		freezing_threshold : Nat;
		controllers : [Principal];
		memory_allocation : Nat;
		compute_allocation : Nat;
	};
	public type EcdsaCurve = { #secp256k1 };
	public type GetBalanceRequest = {
		network : BitcoinNetwork;
		address : BitcoinAddress;
		min_confirmations : ?Nat32;
	};
	public type GetCurrentFeePercentilesRequest = {
		network : BitcoinNetwork;
	};
	public type GetUtxosRequest = {
		network : BitcoinNetwork;
		filter : ?{ #page : [Nat8]; #min_confirmations : Nat32 };
		address : BitcoinAddress;
	};
	public type GetUtxosResponse = {
		next_page : ?[Nat8];
		tip_height : Nat32;
		tip_block_hash : BlockHash;
		utxos : [Utxo];
	};
	public type HttpHeader = { value : Text; name : Text };
	public type HttpResponse = {
		status : Nat;
		body : [Nat8];
		headers : [HttpHeader];
	};
	public type MillisatoshiPerByte = Nat64;
	public type Outpoint = { txid : [Nat8]; vout : Nat32 };
	public type Satoshi = Nat64;
	public type SendTransactionRequest = {
		transaction : [Nat8];
		network : BitcoinNetwork;
	};
	public type UserId = Principal;
	public type Utxo = { height : Nat32; value : Satoshi; outpoint : Outpoint };
	public type WasmModule = [Nat8];
	public type Service = actor {
		bitcoin_get_balance : shared GetBalanceRequest -> async Satoshi;
		bitcoin_get_current_fee_percentiles : shared GetCurrentFeePercentilesRequest -> async [
				MillisatoshiPerByte
			];
		bitcoin_get_utxos : shared GetUtxosRequest -> async GetUtxosResponse;
		bitcoin_send_transaction : shared SendTransactionRequest -> async ();
		canister_status : shared { canister_id : CanisterId } -> async {
				status : { #stopped; #stopping; #running };
				memory_size : Nat;
				cycles : Nat;
				settings : DefiniteCanisterSettings;
				idle_cycles_burned_per_day : Nat;
				module_hash : ?[Nat8];
			};
		create_canister : shared { settings : ?CanisterSettings } -> async {
				canister_id : CanisterId;
			};
		delete_canister : shared { canister_id : CanisterId } -> async ();
		deposit_cycles : shared { canister_id : CanisterId } -> async ();
		ecdsa_public_key : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				canister_id : ?CanisterId;
				derivation_path : [[Nat8]];
			} -> async { public_key : [Nat8]; chain_code : [Nat8] };
		http_request : shared {
				url : Text;
				method : { #get; #head; #post };
				max_response_bytes : ?Nat64;
				body : ?[Nat8];
				transform : ?{
					function : shared query {
							context : [Nat8];
							response : HttpResponse;
						} -> async HttpResponse;
					context : [Nat8];
				};
				headers : [HttpHeader];
			} -> async HttpResponse;
		install_code : shared {
				arg : [Nat8];
				wasm_module : WasmModule;
				mode : { #reinstall; #upgrade; #install };
				canister_id : CanisterId;
			} -> async ();
		provisional_create_canister_with_cycles : shared {
				settings : ?CanisterSettings;
				specified_id : ?CanisterId;
				amount : ?Nat;
			} -> async { canister_id : CanisterId };
		provisional_top_up_canister : shared {
				canister_id : CanisterId;
				amount : Nat;
			} -> async ();
		raw_rand : shared () -> async [Nat8];
		sign_with_ecdsa : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				derivation_path : [[Nat8]];
				message_hash : [Nat8];
			} -> async { signature : [Nat8] };
		start_canister : shared { canister_id : CanisterId } -> async ();
		stop_canister : shared { canister_id : CanisterId } -> async ();
		uninstall_code : shared { canister_id : CanisterId } -> async ();
		update_settings : shared {
				canister_id : Principal;
				settings : CanisterSettings;
			} -> async ();
	};
	public type IC = Service;

	public let ic = actor("aaaaa-aa"): Service;
}