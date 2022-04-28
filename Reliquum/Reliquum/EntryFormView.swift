//
//  EntryFormView.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import WidgetKit
import SwiftUI

extension EntryFormView {
    class ViewModel: ObservableObject {
        @Published var name: String = ""
        @Published var date: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        @Published var color1: ColorItems? = .indigo
        @Published var color2: ColorItems? = .pink
        @Published var colorFont: ColorItems? = .white
        
        init() {
            
        }
        
        func save() {
            guard let color1 = color1, let color2 = color2, let colorFont = colorFont else { return }
            
//            let userDefaults = UserDefaults(suiteName: "group.widgetcacheplace")
            
            let newEntry = Event(name: name, date: date, colors: [color1, color2, colorFont], imageURL: "", description: "", reminder: false)
            
            let userDefaults = UserDefaults.shared
            do {
                try userDefaults.setObject(newEntry, forKey: "1Entry")
            } catch {
                print(error.localizedDescription)
            }
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct EntryFormView: View {
    @ObservedObject var vm = EntryFormView.ViewModel()
    
    var body: some View {
        Form {
            Section {
                Text("Name")
                    .font(.title)
                TextField("", text: $vm.name)
            }
            
            Section {
                Text("Date")
                    .font(.title)
                DatePicker("Date", selection: $vm.date)
            }
            
            Section {
                Text("Colors")
                    .font(.title)
                ScrollPicker(selection: $vm.color1, options: ColorItems.allCases) { color in
                    Circle()
                        .fill(color.itemColor)
                        .frame(width: 44, height: 44)
                        .padding()
                }
                
                ScrollPicker(selection: $vm.color1, options: ColorItems.allCases) { color in
                    Circle()
                        .fill(color.itemColor)
                        .frame(width: 44, height: 44)
                        .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    vm.save()
                } label: {
                    Label("Save", systemImage: "circle.hexagonpath")
                }

            }
        }
    }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView()
    }
}
