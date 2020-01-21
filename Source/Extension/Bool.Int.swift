//
// Created by Mengyu Li on 2020/1/21.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Bool {
    var uint8: UInt8 {
        switch self {
        case true:
            return 1
        case false:
            return 0
        }
    }
}