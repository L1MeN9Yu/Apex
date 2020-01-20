//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

private(set) var __environment: Environment.Type? = nil

public func register(environment: Environment.Type) {
    __environment = environment

    Logger.trace(message: """
                          Apex registered. Internal LevelDB version is \(leveldb_major_version()).\(leveldb_minor_version()).0
                          """)
}

let bundleID = "top.limengyu.Apex"