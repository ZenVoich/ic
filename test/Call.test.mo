import Blob "mo:base/Blob";
import { suite; test; expect } "mo:test/async";

import IC "../src/lib";
import Call "../src/Call";

actor {
  public func runTests() : async () {
    await test(
      "createCanister should succeed",
      func() : async () {
        ignore await Call.createCanister(createCanisterArgs);
      },
    );

    await test(
      "createCanister cost should be exact",
      func() : async () {
        let cycles = Call.Cost.createCanister();
        ignore await (with cycles) IC.ic.create_canister(createCanisterArgs);
        await expect.call(
          func() : async () {
            ignore await (with cycles = cycles - 1) IC.ic.create_canister(createCanisterArgs);
          }
        ).reject();
      },
    );

    await test(
      "httpRequest should succeed",
      func() : async () {
        ignore await Call.httpRequest(request);
        ignore await Call.httpRequest({ request with headers });
        ignore await Call.httpRequest({ request with body });
        ignore await Call.httpRequest({ request with max_response_bytes });
        ignore await Call.httpRequest({
          request with headers;
          body;
          max_response_bytes;
        });
        ignore await Call.httpRequest({ request with transform });
      },
    );

    await suite(
      "httpRequest cost should be exact",
      func() : async () {
        await test("default", httpRequestExactCost(request));
        await test("with headers", httpRequestExactCost({ request with headers }));
        await test("with body", httpRequestExactCost({ request with body }));
        await test("with max_response_bytes", httpRequestExactCost({ request with max_response_bytes }));
        await test("with all above", httpRequestExactCost({ request with headers; body; max_response_bytes }));

        // Future work: transform can't be exact yet
        // await test("with transform", httpRequestExactCost({ request with transform }));
      },
    );
  };

  func httpRequestExactCost(request : IC.HttpRequestArgs) : () -> async () = func() : async () {
    let cycles = Call.Cost.httpRequest(request);
    ignore await (with cycles) IC.ic.http_request(request);
    await expect.call(
      func() : async () {
        ignore await (with cycles = cycles - 1) IC.ic.http_request(request);
      }
    ).reject();
  };

  public shared query func transformFunction({
    context : Blob;
    response : IC.HttpRequestResult;
  }) : async IC.HttpRequestResult {
    ignore context;
    { response with headers = []; status = 200 };
  };

  let createCanisterArgs : IC.CreateCanisterArgs = {
    settings = null;
    sender_canister_version = null;
  };

  let request : IC.HttpRequestArgs = {
    url = "https://ic0.app";
    method = #get;
    headers = [];
    body = null;
    max_response_bytes = null;
    transform = null;
  };
  let headers = [{ name = "x-test"; value = "test" }];
  let body = ?to_candid ([1, 2, 3]);
  let max_response_bytes : ?Nat64 = ?1_000;
  let transform = ?{
    function = transformFunction;
    context = Blob.fromArray([23, 41, 13, 6, 17]);
  };
};
