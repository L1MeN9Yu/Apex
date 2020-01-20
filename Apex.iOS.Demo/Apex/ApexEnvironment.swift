//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import Apex

struct ApexEnvironment { private init() {} }

extension ApexEnvironment {
    static func register() {
        Apex.register(environment: self)
    }
}

extension ApexEnvironment: Apex.Environment {
    public static func log(logFlag: LogFlag, message: CustomStringConvertible?, filename: String, function: String, line: Int) {
        print("[\(logFlag.t)] \(filename):\(line) \(function) --- \(message ?? "")")
    }
}


private extension LogFlag {
    var t: String {
        switch self {
        case .trace:
            return "T"
        case .debug:
            return "D"
        case .info:
            return "I"
        case .warn:
            return "W"
        case .error:
            return "E"
        case .crit:
            return "C"
        case .off:
            return ""
        @unknown default:
            return ""
        }
    }
}
