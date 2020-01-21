//
//  ContentView.swift
//  Apex.iOS.Demo
//
//  Created by Mengyu Li on 2020/1/20.
//  Copyright © 2020 Mengyu Li. All rights reserved.
//

import SwiftUI
import Apex

struct ContentView: View {
    var body: some View {
        Text("Hello, World!").onAppear(perform: test)
    }
}

private extension ContentView {
    func test() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("db.apex").path else { return }
        do {
            let db = try Database(path: path, option: Option())
            if let data1 = try db.get(key: "111") {
                if let string = String(data: data1, encoding: .utf8) {
                    print(string)
                }
            }
            if let data2 = "value222".data(using: .utf8) {
                try db.put(key: "111", value: data2)
            }

            if let data3 = try db.get(key: "111") {
                if let string = String(data: data3, encoding: .utf8) {
                    print(string)
                }
            }
        } catch let error {
            print("===\(error)===")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
