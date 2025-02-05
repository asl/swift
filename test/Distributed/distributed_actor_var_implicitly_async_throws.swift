// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend-emit-module -emit-module-path %t/FakeDistributedActorSystems.swiftmodule -module-name FakeDistributedActorSystems -disable-availability-checking %S/Inputs/FakeDistributedActorSystems.swift
// RUN: %target-swift-frontend -typecheck -verify -enable-experimental-distributed -disable-availability-checking -I %t 2>&1 %s
// REQUIRES: concurrency
// REQUIRES: distributed

import _Distributed
import FakeDistributedActorSystems

@available(SwiftStdlib 5.5, *)
typealias DefaultDistributedActorSystem = FakeActorSystem

struct NotCodable {}

distributed actor D {

  // expected-note@+1{{access to property 'normal' is only permitted within distributed actor 'D'}}
  var normal: String = "normal"

  // expected-note@+1{{access to property 'computed' is only permitted within distributed actor 'D'}}
  var computed: String  {
    "normal"
  }

  // expected-error@+1{{property 'dlet' cannot be 'distributed', only computed properties can}}
  distributed let dlet: String = "illegal"

  // expected-error@+1{{distributed property 'dletvar' cannot be 'distributed', only computed properties can}}
  distributed var dletvar: String = "illegal"

  // OK:
  distributed var dist: String {
    "dist"
  }

  // expected-error@+1{{'distributed' property 'hello' cannot be 'static'}}
  static distributed var hello: String {
    "nope!"
  }

  // expected-error@+1{{result type 'NotCodable' of distributed property 'notCodable' does not conform to serialization requirement 'Codable'}}
  distributed var notCodable: NotCodable {
    .init()
  }

  //expected-error@+1{{'distributed' computed property 'dist_nope' cannot have setter}}
  distributed var dist_nope: String {
    get {
      "dist"
    }
    set {
      // ignore
    }
  }

}

func test_outside(distributed: D) async throws {
  _ = distributed.normal
  // expected-error@-1{{distributed actor-isolated property 'normal' can not be accessed from a non-isolated context}}

  _ = distributed.computed
  // expected-error@-1{{distributed actor-isolated property 'computed' can not be accessed from a non-isolated context}}
}

