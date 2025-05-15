import Prim "mo:prim";

import IC "lib";

module {
  public func httpRequest(args : IC.HttpRequestArgs) : async IC.HttpRequestResult {
    let cycles = costHttpRequest(args);
    await (with cycles) IC.ic.http_request(args);
  };

  func costHttpRequest(args : IC.HttpRequestArgs) : Nat {
    let requestSize = calculateRequestSize(args);
    let maxResponseBytes : Nat64 = switch (args.max_response_bytes) {
      // As stated here: https://internetcomputer.org/docs/references/ic-interface-spec#ic-http_request:
      // "The upper limit on the maximal size for the response is 2MB (2,000,000B) and this value also applies if no maximal size value is specified."
      case null 2_000_000;
      case (?bytes) bytes;
    };
    Prim.costHttpRequest(requestSize, maxResponseBytes);
  };

  func calculateRequestSize(request : IC.HttpRequestArgs) : Nat64 {
    var size : Nat64 = 0;

    // Add URL byte length
    size += Prim.natToNat64(request.url.size());

    // Add headers byte length (sum of all names and values)
    for (header in request.headers.vals()) {
      size += Prim.natToNat64(header.name.size());
      size += Prim.natToNat64(header.value.size());
    };

    // Add body length if present
    switch (request.body) {
      case (?body) { size += Prim.natToNat64(body.size()) };
      case null {};
    };

    // Add transform context length if present
    switch (request.transform) {
      case (?transform) {
        size += Prim.natToNat64(transform.context.size());
        // How to get the method name length otherwise?
        // This gets us both the method name and the actor
        let blob = to_candid (transform.function);
        size += Prim.natToNat64(blob.size());
      };
      case null {};
    };

    size;
  };
};
