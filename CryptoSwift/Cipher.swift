//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum Cipher {
    
    public enum Error: ErrorType {
        case EncryptError
        case DecryptError
    }
    
    /**
    ChaCha20
    
    - parameter key: Encryption key
    - parameter iv:  Initialization Vector
    
    - returns: Value of Cipher
    */
    case ChaCha20(key: [UInt8], iv: [UInt8])
    /**
    AES
    
    - parameter key:       Encryption key
    - parameter iv:        Initialization Vector
    - parameter blockMode: Block mode (CBC by default)
    
    - returns: Value of Cipher
    */
    case AES(key: RawData, iv: RawData, blockMode: CipherBlockMode)
    
    /**
    Encrypt message
    
    - parameter message: Plaintext message
    
    - returns: encrypted message
    */
    public func encrypt(bytes: RawData) throws -> RawData {
        switch (self) {
            case .ChaCha20(let key, let iv):
                guard let chacha = CryptoSwift.ChaCha20(key: key, iv: iv) else {
                    throw Error.EncryptError
                }
                return try RawData(chacha.encrypt(Array(bytes)))
            case .AES(let key, let iv, let blockMode):
                guard let aes = CryptoSwift.AES(key: key, iv: iv, blockMode: blockMode) else {
                    throw Error.EncryptError
                }
                return try aes.encrypt(bytes)
        }
    }
    
    /**
    Decrypt message
    
    - parameter message: Message data
    
    - returns: Plaintext message
    */
    public func decrypt(bytes: RawData) throws -> RawData {
        switch (self) {
            case .ChaCha20(let key, let iv):
                guard let chacha = CryptoSwift.ChaCha20(key: key, iv: iv) else {
                    throw Error.DecryptError
                }
                return try RawData(chacha.decrypt(Array(bytes)))
            case .AES(let key, let iv, let blockMode):
                guard let aes = CryptoSwift.AES(key: key, iv: iv, blockMode: blockMode) else {
                    throw Error.DecryptError
                }
                return try aes.decrypt(bytes)
        }
    }

    static public func randomIV(blockSize:Int) -> [UInt8] {
        var randomIV:[UInt8] = [UInt8]();
        for (var i = 0; i < blockSize; i++) {
            randomIV.append(UInt8(truncatingBitPattern: arc4random_uniform(256)));
        }
        return randomIV
    }
}