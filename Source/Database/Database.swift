//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public class Database {

    let path: String

    private let db: OpaquePointer

    public init(path: String) throws {
        self.path = path
        let option = leveldb_options_create()

        leveldb_options_set_create_if_missing(option, 1)

        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        guard let db = leveldb_open(option, path, &errorPtr) else {
            var message: String? = nil
            if let error = errorPtr {
                message = String(cString: error)
            }
            throw Error.internal(message: message)
        }

        self.db = db

        leveldb_options_destroy(option)
    }

    deinit {
        leveldb_close(self.db)
    }
}
