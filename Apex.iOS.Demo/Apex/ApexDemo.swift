//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import Apex

struct ApexDemo { private init() {} }

extension ApexDemo {
    static func test() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("db.apex").path else { return }

        do {
            let db = try Database(path: path, option: Option())

            let keys = [
                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            ]
            let writeBatch = WriteBatch()
            try keys.forEach { key in
                guard let data = String(Int.random(in: 0..<100)).data(using: .utf8) else { return }
                try writeBatch.put(key: key, value: data)
            }
            try db.writeBatch(writeBatch)

            print("============")
            try db.iterator { key, value, stop in
                print("key = \(key) value = \(String(data: value, encoding: .utf8) ?? "data to string error")")
            }

            print("============")
            try db.iterator(reverse: true, startKey: "4") { key, value, stop in
                print("key = \(key) \(String(data: value, encoding: .utf8) ?? "data to string error")")
                if key == "1" {
                    stop = true
                }
            }

            let printState: (Database) -> Void = { db in
                print("stats = \(db.getProperty(Property.stats) ?? "")")
                print("sstables = \(db.getProperty(Property.sstables) ?? "")")
                print("approximateMemoryUsage = \(db.getProperty(Property.approximateMemoryUsage) ?? "")")
                print("numFilesAtLevel 0 = \(db.getProperty(Property.numFilesAtLevel(0)) ?? "")")
                print("numFilesAtLevel 1 = \(db.getProperty(Property.numFilesAtLevel(1)) ?? "")")
                print("numFilesAtLevel 2 = \(db.getProperty(Property.numFilesAtLevel(2)) ?? "")")
                print("numFilesAtLevel 3 = \(db.getProperty(Property.numFilesAtLevel(3)) ?? "")")
                print("numFilesAtLevel 4 = \(db.getProperty(Property.numFilesAtLevel(4)) ?? "")")
                print("numFilesAtLevel 5 = \(db.getProperty(Property.numFilesAtLevel(5)) ?? "")")
                print("numFilesAtLevel 6 = \(db.getProperty(Property.numFilesAtLevel(6)) ?? "")")
            }

            print("============")
            printState(db)
            writeBatch.clear()

            keys.forEach { key in
                writeBatch.delete(key: key)
            }

            try db.writeBatch(writeBatch)

            db.compact()

            print("============")
            printState(db)

        } catch let error {
            print("===\(error)===")
        }
    }
}
