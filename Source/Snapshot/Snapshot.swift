//
// Created by Mengyu Li on 2020/1/30.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public class Snapshot {
    let pointer: OpaquePointer
    let databasePointer: OpaquePointer

    public init(database: Database) {
        databasePointer = database.pointer
        pointer = leveldb_create_snapshot(databasePointer)
    }

    deinit {
        leveldb_release_snapshot(databasePointer, pointer)
    }
}
