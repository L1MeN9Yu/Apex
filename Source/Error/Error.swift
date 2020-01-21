//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case open(message: String?)
    case writeOption
    case readOption
    case put(message: String?)
    case get(message: String?)
    case delete(message: String?)
    case writeBatch(message: String?)
    case iterator(message: String?)
    case repair(message: String?)
}
