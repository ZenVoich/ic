module {
	public type BitcoinAddress = Text;
	public type BitcoinNetwork = { #mainnet; #testnet };
	public type BlockHash = Blob;
	public type CanisterId = Principal;
	public type CanisterSettings = {
		freezing_threshold : ?Nat;
		controllers : ?[Principal];
		reserved_cycles_limit : ?Nat;
		memory_allocation : ?Nat;
		compute_allocation : ?Nat;
	};
	public type Change = {
		timestamp_nanos : Nat64;
		canister_version : Nat64;
		origin : ChangeOrigin;
		details : ChangeDetails;
	};
	public type ChangeDetails = {
		#creation : { controllers : [Principal] };
		#code_deployment : {
			mode : { #reinstall; #upgrade; #install };
			module_hash : Blob;
		};
		#controllers_change : { controllers : [Principal] };
		#code_uninstall;
	};
	public type ChangeOrigin = {
		#from_user : { user_id : Principal };
		#from_canister : { canister_version : ?Nat64; canister_id : Principal };
	};
	public type ChunkHash = Blob;
	public type DefiniteCanisterSettings = {
		freezing_threshold : Nat;
		controllers : [Principal];
		reserved_cycles_limit : Nat;
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
		filter : ?{ #page : Blob; #min_confirmations : Nat32 };
		address : BitcoinAddress;
	};
	public type GetUtxosResponse = {
		next_page : ?Blob;
		tip_height : Nat32;
		tip_block_hash : BlockHash;
		utxos : [Utxo];
	};
	public type HttpHeader = { value : Text; name : Text };
	public type HttpResponse = {
		status : Nat;
		body : Blob;
		headers : [HttpHeader];
	};
	public type HttpTransformArg = {
		context : Blob;
		response : HttpResponse;
	};
	public type HttpTransform = {
		function : shared query HttpTransformArg -> async HttpResponse;
		context : Blob;
	};
	public type MillisatoshiPerByte = Nat64;
	public type NodeMetrics = {
		num_block_failures_total : Nat64;
		node_id : Principal;
		num_blocks_total : Nat64;
	};
	public type Outpoint = { txid : Blob; vout : Nat32 };
	public type Satoshi = Nat64;
	public type SendTransactionRequest = {
		transaction : Blob;
		network : BitcoinNetwork;
	};
	public type Utxo = { height : Nat32; value : Satoshi; outpoint : Outpoint };
	public type WasmModule = Blob;

	public type Service = actor {
		bitcoin_get_balance : shared GetBalanceRequest -> async Satoshi;
		bitcoin_get_balance_query : shared query GetBalanceRequest -> async Satoshi;
		bitcoin_get_current_fee_percentiles : shared GetCurrentFeePercentilesRequest -> async [
				MillisatoshiPerByte
			];
		bitcoin_get_utxos : shared GetUtxosRequest -> async GetUtxosResponse;
		bitcoin_get_utxos_query : shared query GetUtxosRequest -> async GetUtxosResponse;
		bitcoin_send_transaction : shared SendTransactionRequest -> async ();
		canister_info : shared {
				canister_id : CanisterId;
				num_requested_changes : ?Nat64;
			} -> async {
				controllers : [Principal];
				module_hash : ?Blob;
				recent_changes : [Change];
				total_num_changes : Nat64;
			};
		canister_status : shared { canister_id : CanisterId } -> async {
				status : { #stopped; #stopping; #running };
				memory_size : Nat;
				cycles : Nat;
				settings : DefiniteCanisterSettings;
				idle_cycles_burned_per_day : Nat;
				module_hash : ?Blob;
				reserved_cycles : Nat;
			};
		clear_chunk_store : shared { canister_id : CanisterId } -> async ();
		create_canister : shared {
				settings : ?CanisterSettings;
				sender_canister_version : ?Nat64;
			} -> async { canister_id : CanisterId };
		delete_canister : shared { canister_id : CanisterId } -> async ();
		deposit_cycles : shared { canister_id : CanisterId } -> async ();
		ecdsa_public_key : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				canister_id : ?CanisterId;
				derivation_path : [Blob];
			} -> async { public_key : Blob; chain_code : Blob };
		http_request : shared {
				url : Text;
				method : { #get; #head; #post };
				max_response_bytes : ?Nat64;
				body : ?Blob;
				transform : ?HttpTransform;
				headers : [HttpHeader];
			} -> async HttpResponse;
		install_chunked_code : shared {
				arg : Blob;
				wasm_module_hash : Blob;
				mode : {
					#reinstall;
					#upgrade : ?{ skip_pre_upgrade : ?Bool };
					#install;
				};
				chunk_hashes_list : [ChunkHash];
				target_canister : CanisterId;
				sender_canister_version : ?Nat64;
				storage_canister : ?CanisterId;
			} -> async ();
		install_code : shared {
				arg : Blob;
				wasm_module : WasmModule;
				mode : {
					#reinstall;
					#upgrade : ?{ skip_pre_upgrade : ?Bool };
					#install;
				};
				canister_id : CanisterId;
				sender_canister_version : ?Nat64;
			} -> async ();
		node_metrics_history : shared {
				start_at_timestamp_nanos : Nat64;
				subnet_id : Principal;
			} -> async [{ timestamp_nanos : Nat64; NodeMetrics : [NodeMetrics] }];
		provisional_create_canister_with_cycles : shared {
				settings : ?CanisterSettings;
				specified_id : ?CanisterId;
				amount : ?Nat;
				sender_canister_version : ?Nat64;
			} -> async { canister_id : CanisterId };
		provisional_top_up_canister : shared {
				canister_id : CanisterId;
				amount : Nat;
			} -> async ();
		raw_rand : shared () -> async Blob;
		sign_with_ecdsa : shared {
				key_id : { name : Text; curve : EcdsaCurve };
				derivation_path : [Blob];
				message_hash : Blob;
			} -> async { signature : Blob };
		start_canister : shared { canister_id : CanisterId } -> async ();
		stop_canister : shared { canister_id : CanisterId } -> async ();
		stored_chunks : shared { canister_id : CanisterId } -> async [ChunkHash];
		uninstall_code : shared {
				canister_id : CanisterId;
				sender_canister_version : ?Nat64;
			} -> async ();
		update_settings : shared {
				canister_id : Principal;
				settings : CanisterSettings;
				sender_canister_version : ?Nat64;
			} -> async ();
		upload_chunk : shared {
				chunk : Blob;
				canister_id : Principal;
			} -> async ChunkHash;
	};

	public let ic = actor("aaaaa-aa") : Service;
};