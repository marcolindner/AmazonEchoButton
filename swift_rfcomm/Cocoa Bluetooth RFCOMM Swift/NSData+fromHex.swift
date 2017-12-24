//
//  String+hex.swift
//  LDIO
//
//  Created by Eric Betts on 9/29/15.
//  Copyright © 2015 Eric Betts. All rights reserved.
//

import Foundation

public extension Data {
    init(fromHex: String) {
        let hexArray = fromHex.trimmingCharacters(in: CharacterSet.whitespaces).components(separatedBy: " ")
        let hexBytes : [UInt8] = hexArray.map({UInt8($0, radix: 0x10)!})
        self.init(bytes: hexBytes)
    }
    
    subscript(origin: Int) -> UInt8 {
        get {
            var result: UInt8 = 0;
            if (origin < self.count) {
                (self as NSData).getBytes(&result, range: NSMakeRange(origin, 1))
            }
            return result
        }
    }
    
    func hexadecimalString() -> String {
        return String(map { String(format: "%02hhx ", $0) }.joined().dropLast())
    }
}
