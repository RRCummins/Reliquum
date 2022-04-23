//
//  ContentView.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

struct ContentView: View {
    var entries: [Entry] = []
    @State private var colors:[Color] = [.indigo, .white]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    //
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.title)
                        .labelStyle(.iconOnly)
                        .padding()
                        .background(colors[0])
                        .foregroundColor(colors[1])
                        .clipShape(Capsule())
                        .padding(.horizontal)
                }
            }
            
            List(entries) { entry in
                HStack {
                    Text(entry.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                    
                    Text("\(entry.date.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline.italic())
                    
                    Image(systemName: "\(entry.reminder ? "bell.fill" : "bell.slash.fill")")
                        .foregroundColor(colors[0])
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(entries: [Entry.example])
    }
}
