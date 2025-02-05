// RUN: %target-swift-ide-test -print-module -module-to-print=AmbiguousMethods -I %S/Inputs -source-filename=x -enable-cxx-interop | %FileCheck %s

// CHECK: mutating func pingMutating()
// CHECK: func ping()

// CHECK: func increment(_ a: Int32) -> Int32
// CHECK: mutating func incrementMutating(_ a: Int32) -> Int32

// CHECK: mutating func incrementMutating(_ a: Int32, _ b: Int32, _ c: inout Int32)
// CHECK: func increment(_ a: Int32, _ b: Int32, _ c: inout Int32)

// CHECK: mutating func incrementMutating(_ a: inout Int32, _ b: Int32)
// CHECK: func increment(_ a: inout Int32, _ b: Int32)

// CHECK: func numberOfMutableMethodsCalled() -> Int32
// CHECK: mutating func numberOfMutableMethodsCalledMutating() -> Int32
