module {
	public type Bitcoinaddress = Text;
	public type Bitcoinnetwork = { #mainnet; #testnet };
	public type Blockhash = [Nat8];
	public type Canisterid = Principal;
	public type Canistersettings = {
		freezing_threshold : ?Nat;
		controllers : ?[Principal];
		memory_allocation : ?Nat;
		compute_allocation : ?Nat;
	};
	public type Definitecanistersettings = {
		freezing_threshold : Nat;
		controllers : [Principal];
		memory_allocation : Nat;
		compute_allocation : Nat;
	};
	public type EcdsaCurve = { #secp256k1 };
	public type Getbalancerequest = {
		network : Bitcoinnetwork;
		address : Bitcoinaddress;
		min_confirmations : ?Nat32;
	};
	public type GetCurrentFeePercentilesRequest = {
		network : Bitcoinnetwork;
	};
	public type Getutxosrequest = {
		network : Bitcoinnetwork;
		filter : ?{ #page : [Nat8]; #min_confirmations : Nat32 };
		address : Bitcoinaddress;
	};
	public type GetUtxosResponse = {
		next_page : ?[Nat8];
		tip_height : Nat32;
		tip_block_hash : Blockhash;
		utxos : [Utxo];
	};
	public type Httpheader = { value : Text; name : Text };
	public type http_response = {
		status : Nat;
		body : [Nat8];
		headers : [Httpheader];
	};
	public type MillisatoshiPerByte = Nat64;
	public type Outpoint = { txid : [Nat8]; vout : Nat32 };
	public type Satoshi = Nat64;
	public type SendTransactionRequest = {
		transaction : [Nat8];
		network : Bitcoinnetwork;
	};
	public type UserId = Principal;
	public type Utxo = { height : Nat32; value : Satoshi; outpoint : Outpoint };
	public type WasmModule = [Nat8];
	public type Service = actor {
		bitcoin_get_balance : shared Getbalancerequest -> async Satoshi;
		bitcoin_get_current_fee_percentiles : shared GetCurrentFeePercentilesRequest -> async [
				MillisatoshiPerByte
			];
		bitcoin_get_utxos : shared Getutxosrequest -> async GetUtxosResponse;
		bitcoin_send_transaction : shared SendTransactionRequest -> async ();
		canister_status : shared { canisterid : Canisterid } -> async {
				status : { #stopped; #stopping; #running };
				memory_size : Nat;
				cycles : Nat;
				settings : Definitecanistersettings;
				idle_cycles_burned_per_day : Nat;
				module_hash : ?[Nat8];
			};
		create_canister : shared { settings : ?Canistersettings } -> async {
				canisterid : Canisterid;
			};
		delete_canister : shared { canisterid : Canisterid } -> async ();
		deposit_cycles : shared { canisterid : Canisterid } -> async ();
		ecdsa_public_key : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				canisterid : ?Canisterid;
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
							response : http_response;
						} -> async http_response;
					context : [Nat8];
				};
				headers : [Httpheader];
			} -> async http_response;
		install_code : shared {
				arg : [Nat8];
				wasm_module : WasmModule;
				mode : { #reinstall; #upgrade; #install };
				canisterid : Canisterid;
			} -> async ();
		provisional_create_canister_with_cycles : shared {
				settings : ?Canistersettings;
				specified_id : ?Canisterid;
				amount : ?Nat;
			} -> async { canisterid : Canisterid };
		provisional_top_up_canister : shared {
				canisterid : Canisterid;
				amount : Nat;
			} -> async ();
		raw_rand : shared () -> async [Nat8];
		sign_with_ecdsa : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				derivation_path : [[Nat8]];
				message_hash : [Nat8];
			} -> async { signature : [Nat8] };
		start_canister : shared { canisterid : Canisterid } -> async ();
		stop_canister : shared { canisterid : Canisterid } -> async ();
		uninstall_code : shared { canisterid : Canisterid } -> async ();
		update_settings : shared {
				canisterid : Principal;
				settings : Canistersettings;
			} -> async ();
	};

	public type IC = Service;

	public let ic = actor("aaaaa-aa"): Service;
}