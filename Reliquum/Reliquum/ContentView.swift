//
//  ContentView.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var entries: [Event] = []
        @Published var colors: [Color] = [.indigo, .white]
        
        init() {
            loadItems()
        }
        
        func loadItems() {
            let userDefaults = UserDefaults.shared
            do {
                let event = try userDefaults.getObject(forKey: "1Event", castTo: Event.self)
                entries.append(event)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .bottomTrailing) {
                List(vm.entries) { entry in
                    HStack {
                        Text(entry.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                        
                        Text("\(entry.date.formatted(date: .omitted, time: .shortened))")
                            .font(.subheadline.italic())
                        
                        Image(systemName: "\(entry.reminder ? "bell.fill" : "bell.slash.fill")")
                            .foregroundColor(vm.colors[0])
                            .padding()
                    }
                }
                
                CommandButton(color1: vm.colors[0], color2: vm.colors[1])
                    .padding()
            }
            .navigationTitle("Reliquum")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CommandButton: View {
    var color1: Color
    var color2: Color
    
    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                EntryFormView()
            } label: {
                Label("Add", systemImage: "plus")
                    .font(.title)
                    .labelStyle(.iconOnly)
                    .padding()
                    .background(color1)
                    .foregroundColor(color2)
                    .clipShape(Capsule())
                    .padding(.horizontal)
            }
            
        }
    }
}
