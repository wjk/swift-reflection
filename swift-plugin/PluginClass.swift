//
//  PluginClass.swift
//  swift-plugin
//
//  Created by William Kent on 8/2/19.
//  Copyright © 2019 William Kent. All rights reserved.
//

import Foundation
import ReflectionCommon

public class PluginMain: PluginProtocol {
	public func main(arguments: [String]) -> Int {
		if arguments.count > 2 {
			print("Hello from \(arguments[2])")
		} else {
			print("Hello from PluginMain!")
		}

		return 0
	}
}

@_cdecl("ReflectionCreateObject")
public func createObject(namePtr: UnsafePointer<CChar>) -> UnsafeMutableRawPointer? {
	let name = String(cString: namePtr)
	guard name == "PluginMain" else {
		return nil
	}

	let object = PluginMain()
	let iface = object as PluginProtocol
	return bridgeWrap(iface)
}
