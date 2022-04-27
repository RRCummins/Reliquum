//
//  ScrollPicker.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/23/22.
// By David Rozmajzl 

import SwiftUI

struct ScrollPicker<Content, Item: Hashable>: View where Content: View {
  @State private var persistentOffset: CGFloat = 0
  @State private var offset: CGFloat = 0
  
  @Binding var selection: Item?
  
  let options: [Item]
  let itemWidth: CGFloat?
  let onChange: ((Item?) -> ())?
  
  let content: (Item) -> Content
  
  func itemWidthOverride(_ geometry: GeometryProxy) -> CGFloat {
    return itemWidth ?? geometry.size.width * 0.15
  }
  
  func width(_ geometry: GeometryProxy) -> CGFloat {
    return geometry.size.width
  }
  
  init(selection: Binding<Item?>, options: [Item], width itemWidth: CGFloat? = nil, onChange: ((Item?) -> ())? = nil, _ content: @escaping (Item) -> Content) {
    _selection = selection
    self.options = options
    self.itemWidth = itemWidth
    self.onChange = onChange
    self.content = content
  }
  
  var body: some View {
    GeometryReader { geometry in
      Picker(geometry)
    }
    .onChange(of: selection) { onChange?($0) }
  }
}

extension ScrollPicker {
  @ViewBuilder
  private func Picker(_ geometry: GeometryProxy) -> some View {
    Group {
      HStack (spacing: 0) {
        Spacer()
          .frame(width: geometry.size.width / 2 - itemWidthOverride(geometry) / 2)
        
        ForEach (options, id: \.self) { option in
          GeometryReader { geo in
            HStack (spacing: 0) {
              let relativeX = geo.frame(in: .named("scrollPicker")).midX
              let ratio: Double = (geometry.size.width / 2 - relativeX) / (geometry.size.width / 2)
              let angle = Angle(degrees: Double(90) * -ratio)
              let scale = 1 - abs(ratio) <= 0 ? 0.001: 1 - abs(ratio) / 1
              Group {
                if scale == 0.001 {
                  content(option)
                    .hidden()
                } else {
                  content(option)
                    .scaleEffect(scale)
                }
              }
              .position(x: geo.size.width / 2, y: geo.size.height / 2)
              .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
            }
          }
          .frame(width: itemWidthOverride(geometry))
          .onTapGesture { onTapped(option, geometry) }
        }
        .onAppear {
          if let selection = selection, let index = options.firstIndex(of: selection) {
            persistentOffset = -CGFloat(index) * itemWidthOverride(geometry)
          } else if let first = options.first {
            selection = first
          } else {
            selection = nil
          }
        }
        
        Spacer()
          .frame(width: geometry.size.width / 2 - itemWidthOverride(geometry) / 2)
      }
      .contentShape(Rectangle())
      .offset(x: persistentOffset + offset, y: 0)
      .coordinateSpace(name: "scrollPicker")
    }
    .gesture(
      DragGesture()
        .onChanged{ onDragChanged($0, geometry) }
        .onEnded{ onDragEnded($0, geometry) }
    )
  }
}

extension ScrollPicker {
  private func onTapped(_ option: Item, _ geometry: GeometryProxy) {
    guard let index = options.firstIndex(of: option) else { return }
    
    withAnimation (.spring()) {
      self.persistentOffset = CGFloat(index) * itemWidthOverride(geometry) * -1
      self.offset = 0
    }
    
    selection = option
  }
  
  private func onDragChanged(_ drag: DragGesture.Value, _ geometry: GeometryProxy) {
    let totalOffset = persistentOffset + drag.translation.width
    
    var newOffset: CGFloat!
    var calculatedIndex: Int!
    let length = CGFloat(options.count - 1) * itemWidthOverride(geometry)
    
    if totalOffset > 0 {
      let offsetToEdge = drag.translation.width - abs(totalOffset)
      newOffset = offsetToEdge + totalOffset / 2.5
      calculatedIndex = 0
    } else if totalOffset < -length {
      let offsetOffEdge = totalOffset + length
      let offsetToEdge = drag.translation.width - offsetOffEdge
      newOffset = offsetToEdge + offsetOffEdge / 2.5
      calculatedIndex = options.count - 1
    } else {
      newOffset = drag.translation.width
      calculatedIndex = Int(round(abs(totalOffset / itemWidthOverride(geometry))))
    }
    
    guard calculatedIndex >= 0 && calculatedIndex < options.count else {
      selection = nil
      return
    }
    
    withAnimation (.easeOut(duration: 0.15)) {
      self.offset = newOffset
    }
    
    selection = options[calculatedIndex]
  }
  
  private func onDragEnded(_ drag: DragGesture.Value, _ geometry: GeometryProxy) {
    let totalOffset = persistentOffset + drag.translation.width
    
    var calculatedIndex: Int!
    let length = CGFloat(options.count - 1) * itemWidthOverride(geometry)
    
    if totalOffset > 0 {
      calculatedIndex = 0
    } else if totalOffset < -length {
      calculatedIndex = options.count - 1
    } else {
      calculatedIndex = Int(round(abs(totalOffset / itemWidthOverride(geometry))))
    }
    
    guard calculatedIndex >= 0 && calculatedIndex < options.count else {
      selection = nil
      return
    }
    
    withAnimation (.spring()) {
      self.persistentOffset = CGFloat(calculatedIndex) * itemWidthOverride(geometry) * -1
      self.offset = 0
    }
    
    selection = options[calculatedIndex]
  }
}
