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
        Button(action: ApexDemo.test) { Text("Button") }
//        Text("Hello, World!").onAppear(perform: ApexDemo.test)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
