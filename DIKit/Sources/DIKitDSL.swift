// DIKitDSL.swift
//
// - Authors:
// Ben John
//
// - Date: 17.10.19
//
// Copyright © 2019 Ben John. All rights reserved.

@resultBuilder
public struct ModuleBuilder {
    public static func buildBlock(_ children: [ComponentProtocol]...) -> [ComponentProtocol] {
        children.flatMap { $0 }
    }

    public static func buildBlock(_ component: [ComponentProtocol]) -> [ComponentProtocol] {
        component
    }

    static func buildOptional(_ component: [ComponentProtocol]?) -> [ComponentProtocol] {
        component ?? []
    }

    static func buildEither(first component: [ComponentProtocol]) -> [ComponentProtocol] {
        component
    }

    static func buildEither(second component: [ComponentProtocol]) -> [ComponentProtocol] {
        component
    }
}

public func module(@ModuleBuilder makeChildren: () -> [ComponentProtocol]) -> DependencyContainer {
    DependencyContainer { container in makeChildren().forEach { c in container.register(c) } }
}

@resultBuilder
public struct ModulesBuilder {
    public static func buildBlock(_ children: DependencyContainer...) -> [DependencyContainer] {
        children.compactMap { $0 }
    }

    public static func buildBlock(_ component: DependencyContainer) -> [DependencyContainer] {
        [component]
    }
}

public func modules(@ModulesBuilder makeChildren: () -> [DependencyContainer]) -> DependencyContainer {
    DependencyContainer.derive(from: makeChildren())
}

public func resolvable<T>(createdAtStart: Bool,
                          lifetime: Lifetime = .singleton,
                          _ factory: @escaping () -> T) -> ComponentProtocol {
    Component(createdAtStart: createdAtStart,
              lifetime: lifetime,
              factory: factory) as ComponentProtocol
}

public func resolvable<T>(
    createdAtStart: Bool,
    lifetime: Lifetime = .singleton,
    tag: AnyHashable,
    _ factory: @escaping () -> T
) -> ComponentProtocol {
    Component(createdAtStart: createdAtStart,
              lifetime: lifetime,
              tag: tag,
              factory: factory) as ComponentProtocol
}

public func factory<T>(factory: @escaping () -> T) -> [ComponentProtocol] {
    [resolvable(createdAtStart: false, lifetime: .factory, factory)]
}

public func factory<T>(tag: AnyHashable, factory: @escaping () -> T) -> [ComponentProtocol] {
    [resolvable(createdAtStart: false, lifetime: .factory, tag: tag, factory)]
}

public func single<T>(createdAtStart: Bool = false,
                      factory: @escaping () -> T) -> [ComponentProtocol] {
    [resolvable(createdAtStart: createdAtStart, lifetime: .singleton, factory)]
}

public func single<T>(createdAtStart: Bool = false,
                      tag: AnyHashable,
                      factory: @escaping () -> T) -> [ComponentProtocol] {
    [resolvable(createdAtStart: createdAtStart, lifetime: .singleton, tag: tag, factory)]
}
