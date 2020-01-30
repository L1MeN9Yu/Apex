//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public class WriteOption {
    let pointer: OpaquePointer

    public var sync: Bool {
        didSet {
            leveldb_writeoptions_set_sync(pointer, sync.uint8)
        }
    }

    public init(sync: Bool = false) {
        pointer = leveldb_writeoptions_create()

        self.sync = sync
        leveldb_writeoptions_set_sync(pointer, sync.uint8)
    }

    deinit {
        leveldb_writeoptions_destroy(pointer)
    }
}

public extension WriteOption {
    static let `default`: WriteOption = WriteOption()
}