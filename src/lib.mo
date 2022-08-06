module {
	public type CanisterSettings = {
		freezing_threshold: ?Nat;
		controllers: ?[Principal];
		memory_allocation: ?Nat;
		compute_allocation: ?Nat;
	};

	public type DefiniteCanisterSettings = {
		freezing_threshold: Nat;
		controllers: [Principal];
		memory_allocation: Nat;
		compute_allocation: Nat;
	};

	public type HttpHeader = { value: Text; name: Text };

	public type HttpRequestError = {
		#dns_error;
		#no_consensus;
		#transform_error;
		#unreachable;
		#bad_tls;
		#conn_timeout;
		#invalid_url;
		#timeout;
	};

	public type HttpResponse = {
		status: Nat;
		body: Blob;
		headers: [HttpHeader];
	};

	public type IC = actor {
		canister_status: shared { canister_id: Principal } -> async {
			status: { #stopped; #stopping; #running };
			memory_size: Nat;
			cycles: Nat;
			settings: DefiniteCanisterSettings;
			module_hash: ?Blob;
		};
		create_canister: shared { settings: ?CanisterSettings } -> async {
			canister_id: Principal;
		};
		delete_canister: shared { canister_id: Principal } -> async ();
		deposit_cycles: shared { canister_id: Principal } -> async ();
		http_request: shared {
			url: Text;
			method: { #get };
			body: ?Blob;
			transform: ?{
				#function: shared query HttpResponse -> async HttpResponse;
			};
			headers: [HttpHeader];
		} -> async { #Ok: HttpResponse; #Err: ?HttpRequestError };
		install_code: shared {
			arg: Blob;
			wasm_module: Blob;
			mode: { #reinstall; #upgrade; #install };
			canister_id: Principal;
		} -> async ();
		provisional_create_canister_with_cycles: shared {
			settings: ?CanisterSettings;
			amount: ?Nat;
		} -> async { canister_id: Principal };
		provisional_top_up_canister: shared {
			canister_id: Principal;
			amount: Nat;
		} -> async ();
		raw_rand: shared () -> async Blob;
		start_canister: shared { canister_id: Principal } -> async ();
		stop_canister: shared { canister_id: Principal } -> async ();
		uninstall_code: shared { canister_id: Principal } -> async ();
		update_settings: shared {
			canister_id: Principal;
			settings: CanisterSettings;
		} -> async ();
	};

	public let ic = actor("aaaaa-aa"): IC;
}