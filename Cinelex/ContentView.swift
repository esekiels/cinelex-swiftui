//
//  ContentView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import SwiftUI
import Common
import Design

struct ContentView: View {
    var body: some View {
        VStack {
            Image.module("Cinelex")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(LocalizeConstant.app)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
