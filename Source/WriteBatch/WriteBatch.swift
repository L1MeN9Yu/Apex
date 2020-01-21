//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public class WriteBatch {
    let pointer: OpaquePointer

    public init() {
        pointer = leveldb_writebatch_create()
    }

    public init(pointer: OpaquePointer) {
        self.pointer = pointer
    }

    deinit {
        leveldb_writebatch_destroy(pointer)
    }
}

public extension WriteBatch {
    func put(key: String, value: Data) throws {
        try value.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Int8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                throw Error.put(message: nil)
            }
            leveldb_writebatch_put(pointer, key, key.count, unsafePointer, value.count)
        }
    }

    func delete(key: String) {
        leveldb_writebatch_delete(pointer, key, key.count)
    }

    func clear() {
        leveldb_writebatch_clear(pointer)
    }
}

public extension WriteBatch {
    static func +(lhs: WriteBatch, rhs: WriteBatch) -> WriteBatch {
        let pointer: OpaquePointer = leveldb_writebatch_create()
        leveldb_writebatch_append(pointer, lhs.pointer)
        leveldb_writebatch_append(pointer, rhs.pointer)
        return WriteBatch(pointer: pointer)
    }
}
