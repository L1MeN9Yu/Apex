//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public struct Repairer { private init() {} }

extension Repairer {
    static func repair(path: String, option: Option) throws {

        var lastErrorPtr: UnsafeMutablePointer<Int8>? = nil
        leveldb_repair_db(option.pointer, path, &lastErrorPtr)
        
        if let error = lastErrorPtr {
            let message = String(cString: error)
            leveldb_free(error)
            throw Error.repair(message: message)
        }
    }
}
