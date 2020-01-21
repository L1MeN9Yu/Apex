//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public struct Property: Equatable {
    public let name: String

    public init(name: String) { self.name = name }

    public static func ==(lhs: Property, rhs: Property) -> Bool { lhs.name == rhs.name }
}

//  "leveldb.num-files-at-level<N>" - return the number of files at level <N>,
//     where <N> is an ASCII representation of a level number (e.g. "0").
//  "leveldb.stats" - returns a multi-line string that describes statistics
//     about the internal operation of the DB.
//  "leveldb.sstables" - returns a multi-line string that describes all
//     of the sstables that make up the db contents.
//  "leveldb.approximate-memory-usage" - returns the approximate number of
//     bytes of memory in use by the DB.

public extension Property {
    static let stats: Self = Property(name: "leveldb.stats")
    static let sstables: Self = Property(name: "leveldb.sstables")
    static let approximateMemoryUsage: Self = Property(name: "leveldb.approximate-memory-usage")
    static let numFilesAtLevel: (_ level: UInt) -> Self = { level in Property(name: "leveldb.num-files-at-level\(level)") }
}
