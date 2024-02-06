//
//  DraggableLazyGrid.swift
//  Experimentation
//
//  Created by James Valaitis on 12/01/2024.
//

import SwiftUI

struct DraggableLazyGrid: View {
    @State private var items = (1...100).map { PretendData(id: $0) }
    @State private var active: PretendData?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: 200))]) {
                ReorderableForEach(items, active: $active) { item in
                    shape
                        .fill(.white.opacity(0.5))
                        .frame(height: 100)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, shape)
                    
                } preview: { item in
                    Color.white
                        .frame(height: 150)
                        .frame(minWidth: 250)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, shape)
                } moveAction: { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
                
            }
            .padding()
        }
        .background(Color.pink.gradient)
        .scrollContentBackground(.hidden)
    }
    
    private var shape: some Shape {
        RoundedRectangle(cornerRadius: 16)
    }
}

public typealias Reorderable = Identifiable & Equatable

fileprivate struct PretendData: Reorderable {
    let id: Int
}

public struct ReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {
    @Binding private var active: Item?
    @State private var hasChangedLocation = false
    
    private let items: [Item]
    private let content: (Item) -> Content
    private let preview: ((Item) -> Preview)?
    private let moveAction: (IndexSet, Int) -> Void
    
    init(_ items: [Item],
         active: Binding<Item?>,
         @ViewBuilder content: @escaping (Item) -> Content,
         @ViewBuilder preview: @escaping (Item) -> Preview,
         moveAction: @escaping (IndexSet, Int) -> Void) {
        self.items = items
        _active = active
        self.content = content
        self.preview = Preview.self == EmptyView.self ? nil : preview
        self.moveAction = moveAction
    }
    
    public var body: some View {
        ForEach(items) { item in
            if let preview {
                contentView(for: item)
                    .onDrag { itemProvider(for: item) } preview: { preview(item) }
            } else {
                contentView(for: item)
                    .onDrag { itemProvider(for: item) }
            }
        }
    }
    
    public func contentView(for item: Item) -> some View {
        content(item)
            .opacity(active == item && hasChangedLocation ? 0.5 : 1)
            .onDrop(of: [.text],
                    delegate: ReorderableDragRelocateDelegate(item: item, items: items, active: $active, hasChangedLocation: $hasChangedLocation) { from, to in
                withAnimation { moveAction(from, to) }
            })
    }
    
    public func itemProvider(for item: Item) -> NSItemProvider {
        active = item
        return NSItemProvider(object: "\(item.id)" as NSString)
    }
}

fileprivate struct ReorderableDragRelocateDelegate<Item: Reorderable>: DropDelegate {
    let item: Item
    var items: [Item]
    @Binding var active: Item?
    @Binding var hasChangedLocation: Bool
    
    let moveAction: (IndexSet, Int) -> ()
    
    func dropEntered(info: DropInfo) {
        guard item != active,
              let current = active,
              let from = items.firstIndex(of: current),
              let to = items.firstIndex(of: item) else { return }
        hasChangedLocation = true
        if items[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
        
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        active = nil
        return true
    }
}

#Preview {
    DraggableLazyGrid()
}
