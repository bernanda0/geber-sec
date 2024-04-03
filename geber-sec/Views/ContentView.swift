//
//  ContentView.swift
//  geber-sec
//
//  Created by bernanda on 31/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    @StateObject var notificationManager = NotificationManager()
    
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
        VStack{
            Button("Request Notification"){
                Task{
                    await notificationManager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(notificationManager.hasPermission)
            .task {
                await notificationManager.getAuthStatus()
            }
        }
        List {
            HStack {
                Text("Location").bold()
                Spacer()
                Text("Counter").bold()
                Spacer()
                Text("Latest Call").bold()
            }
            SectionRow(row: vm.s1_event).task {
                await vm.subscribe(loc: "s1")
            }
            SectionRow(row: vm.s2_event).task {
                await vm.subscribe(loc: "s2")
            }
            SectionRow(row: vm.s3_event).task {
                await vm.subscribe(loc: "s3")
            }
            
        }.listStyle(GroupedListStyle())
        
    }
}

struct SectionRow: View {
    var row: Row
    
    var body: some View {
        HStack {
            Text(String(describing: row.location))
            Spacer()
            Text("\(row.numberOfCalls)")
            Spacer()
            Text("\(row.latestCall)")
        }
    }
}

#Preview {
    ContentView()
}
