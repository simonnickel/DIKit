// DIKit.swift
//
// - Authors:
// Ben John
//
// - Date: 17.08.18
//
// Copyright © 2018 Ben John. All rights reserved.

/// Resolves given `Component<T>`.
///
/// - Returns: The resolved `Component<T>`.
public func resolve<T>() -> T { DependencyContainer.shared.resolve() }

public func resolveOptional<T>() -> T? { DependencyContainer.shared.resolveOptional() }

/// Injects a generic method to resolve given `Component<T>`.
public func resolveFunc<T>() -> (() -> T) { { resolve() } }

public func resolveOptionalFunc<T>() -> (() -> T?) { { resolveOptional() } }
