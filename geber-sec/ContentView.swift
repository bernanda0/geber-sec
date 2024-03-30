//
//  ContentView.swift
//  geber-sec
//
//  Created by bernanda on 31/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "dog")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Watch dog!").font(.title2)
            Spacer().frame(height: 20)
            Text(Util.dateFormatter.string(from: Date()))
            
        }
        .padding()
        Spacer().frame(height: 10)
        List {
            HStack {
                Text("Location").bold()
                Spacer()
                Text("Counter").bold()
                Spacer()
                Text("Latest Call").bold()
            }
            ForEach(mock_data, id: \.location) { call in
                HStack {
                    Text(call.location)
                    Spacer()
                    Text("\(call.numberOfCalls)")
                    Spacer()
                    Text(call.latestCall)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
