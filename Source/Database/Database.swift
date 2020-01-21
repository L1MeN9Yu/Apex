//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public class Database {

    let path: String

    private let pointer: OpaquePointer
    private let writeOption: OpaquePointer
    private let readOption: OpaquePointer
    private var lastErrorPtr: UnsafeMutablePointer<Int8>? = nil

    public init(path: String, option: Option) throws {
        self.path = path

        guard let db = leveldb_open(option.pointer, path, &lastErrorPtr) else {
            var message: String? = nil
            if let error = lastErrorPtr {
                message = String(cString: error)
            }
            throw Error.open(message: message)
        }

        guard let writeOption = leveldb_writeoptions_create() else {
            throw Error.writeOption
        }

        guard let readOption = leveldb_readoptions_create() else {
            throw Error.readOption
        }

        self.pointer = db
        self.writeOption = writeOption
        self.readOption = readOption

        Logger.trace(message: "db open success. path is \(path)")
    }

    deinit {
        leveldb_close(self.pointer)
        leveldb_writeoptions_destroy(self.writeOption)
        leveldb_readoptions_destroy(self.readOption)
        leveldb_free(lastErrorPtr)
        Logger.trace(message: "db close success. path is \(path)")
    }
}

public extension Database {
    func put(key: String, value: Data) throws {
        try value.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Int8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                throw Error.put(message: nil)
            }

            leveldb_put(pointer, writeOption, key, key.count, unsafePointer, value.count, &lastErrorPtr)

            if let error = lastErrorPtr {
                let message = String(cString: error)
                throw Error.put(message: message)
            }
        }
    }

    func get(key: String) throws -> Data? {
        var valueLength: Int = 0
        guard let dataPtr = leveldb_get(pointer, readOption, key, key.count, &valueLength, &lastErrorPtr) else {
            if let error = lastErrorPtr {
                let message = String(cString: error)
                throw Error.get(message: message)
            }
            return nil
        }
        let data = Data(bytes: dataPtr, count: valueLength)
        return data
    }

    func delete(key: String) throws {
        leveldb_delete(pointer, writeOption, key, key.count, &lastErrorPtr)
        if let error = lastErrorPtr {
            let message = String(cString: error)
            throw Error.delete(message: message)
        }
    }
}

public extension Database {
    func getProperty(_ property: Property) -> String? {
        guard let value = leveldb_property_value(pointer, property.name) else {
            return nil
        }
        return String(cString: value)
    }
}

public extension Database {
    func compact(beginKey: String? = nil, endKey: String? = nil) {
        leveldb_compact_range(pointer, beginKey, beginKey?.count ?? 0, endKey, endKey?.count ?? 0)
    }
}