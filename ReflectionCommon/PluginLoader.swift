//
//  PluginLoader.swift
//  ReflectionCommon
//
//  Created by William Kent on 8/2/19.
//  Copyright © 2019 William Kent. All rights reserved.
//

import Foundation
import Symbolic

public func loadPlugin(bundle: Bundle) throws -> PluginProtocol {
	guard let executableURL = bundle.executableURL else {
		let userInfo = [NSLocalizedDescriptionKey: "Bundle has no main executable"]
		throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: userInfo)
	}

	return try loadPlugin(sharedLibrary: executableURL)
}

public func loadPlugin(sharedLibrary location: URL) throws -> PluginProtocol {
	let dylib = try SharedObject(object: location, behavior: .now)
	guard let entryPoint = dylib.function(forSymbol: "ReflectionCreateObject", ofType: PluginEntryPoint.self) else {
		let userInfo = [NSLocalizedDescriptionKey: "Could not resolve ReflectionCreateObject"]
		throw NSError(domain: NSOSStatusErrorDomain, code: paramErr, userInfo: userInfo)
	}

	guard let ptr = entryPoint("PluginMain") else {
		let userInfo = [NSLocalizedDescriptionKey: "ReflectionCreateObject(\"PluginMain\") returned NULL pointer"]
		throw NSError(domain: NSOSStatusErrorDomain, code: paramErr, userInfo: userInfo)
	}

	return bridgeUnwrap(ptr)
}
