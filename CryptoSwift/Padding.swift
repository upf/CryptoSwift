//
//  Padding.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/02/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public protocol Padding {
    func add(data: RawData, blockSize:Int) -> RawData
    func remove(data: RawData, blockSize:Int?) -> RawData
}