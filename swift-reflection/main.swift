//
//  main.swift
//  swift-reflection
//
//  Created by William Kent on 8/2/19.
//  Copyright © 2019 William Kent. All rights reserved.
//

import Foundation
import ReflectionCommon

fileprivate extension FileManager {
	func directoryExists(at location: URL) -> Bool {
		assert(location.isFileURL, "location must be file URL")

		var isDir: ObjCBool = false
		let result = fileExists(atPath: location.path, isDirectory: &isDir)
		return result && isDir.boolValue
	}
}

func main() {
	if CommandLine.argc < 2 {
		print("usage: swift-reflection path/to/plugin")
		print("plugin can be either an NSBundle or a raw dylib")
		exit(1)
	}

	let pluginURL = URL(fileURLWithPath: CommandLine.arguments[1])
	let plugin: PluginProtocol

	do {
		if FileManager.default.directoryExists(at: pluginURL) {
			guard let bundle = Bundle(url: pluginURL) else {
				print("\(pluginURL) does not point to a valid NSBundle")
				exit(1)
			}

			plugin = try loadPlugin(bundle: bundle)
		} else {
			plugin = try loadPlugin(sharedLibrary: pluginURL)
		}
	} catch {
		print(error.localizedDescription)
		exit(1)
	}

	exit(Int32(plugin.main(arguments: CommandLine.arguments)))
}

main()
