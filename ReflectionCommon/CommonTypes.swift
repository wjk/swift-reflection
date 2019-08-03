//
//  CommonTypes.swift
//  ReflectionCommon
//
//  Created by William Kent on 8/2/19.
//  Copyright © 2019 William Kent. All rights reserved.
//

import Foundation

public protocol PluginProtocol: class {
	func main(arguments: [String]) -> Int
}

public typealias PluginEntryPoint = @convention(c) (UnsafePointer<CChar>) -> UnsafeRawPointer?
