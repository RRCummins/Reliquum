//
//  ContentView.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

struct ContentView: View {
    @State private var entries: [Entry] = []
    var body: some View {
        VStack {
            Button {
                //
            } label: {
                Label("Add", image: "plus")
            }
            
            List(entries) { entry in
                HStack {
                    Text(entry.name)
                    
                    Text("\(entry.date)")
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
