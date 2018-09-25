// DIKitTests.swift
//
// - Authors:
// Ben John
//
// - Date: 17.08.18
//
// Copyright © 2018 Ben John. All rights reserved.


import XCTest
@testable import DIKit

class DIKitTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDependencyContainerCreation() {
        struct ComponentA {}
        struct ComponentB {}

        let dependencyContainer = DependencyContainer { (c: DependencyContainer) in
            c.register { ComponentA() }
            c.register { ComponentB() }
        }

        guard let componentA = dependencyContainer.componentStack.index(forKey: "ComponentA") else {
            return XCTFail()
        }
        let componentProtocolA = dependencyContainer.componentStack[componentA].value
        XCTAssertEqual(componentProtocolA.lifetime, .singleton)
        let instanceA = componentProtocolA.componentFactory()
        XCTAssertTrue(instanceA is ComponentA)
        XCTAssertFalse(instanceA is ComponentB)

        guard let componentB = dependencyContainer.componentStack.index(forKey: "ComponentB") else {
            return XCTFail()
        }
        let componentProtocolB = dependencyContainer.componentStack[componentB].value
        XCTAssertEqual(componentProtocolB.lifetime, .singleton)
        let instanceB = componentProtocolB.componentFactory()
        XCTAssertTrue(instanceB is ComponentB)
        XCTAssertFalse(instanceB is ComponentA)
    }

    func testDependencyContainerResolve() {
        struct ComponentA {}

        let dependencyContainer = DependencyContainer { (c: DependencyContainer) in
            c.register { ComponentA() }
        }

        let componentA: ComponentA = dependencyContainer.resolve()
        XCTAssertNotNil(componentA)
    }

    func testLifetimeOfComponents() {
        struct ComponentA {}
        struct ComponentB {}

        let dependencyContainer = DependencyContainer { (c: DependencyContainer) in
            c.register { ComponentA() }
            c.register { ComponentB() }
        }

        let componentA = dependencyContainer.componentStack.index(forKey: "ComponentA")
        XCTAssertNotNil(componentA)

        let componentB = dependencyContainer.componentStack.index(forKey: "ComponentA")
        XCTAssertNotNil(componentB)
    }
}
