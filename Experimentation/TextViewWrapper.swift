//
//  TextViewWrapper.swift
//  Experimentation
//
//  Created by James Valaitis on 16/01/2024.
//

import SwiftUI

#if canImport(AppKit)
struct TextViewWrapper: View {
    @State var text = "James"
    @State var selection = NSRange(location: 0, length: 0)
    
    var body: some View {
        MyTextView(text: $text, selection: $selection)
    }
}

struct MyTextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var selection: NSRange
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        context.coordinator.textView = textView
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateNSView(_ textView: NSTextView, context: Context) {
        print("🔸 🔸 🔸 🔸 🔸")
        print("Begin \(#function)", textView.selectedRanges)
        let attrString = NSAttributedString(string: text,
                                            attributes: [.backgroundColor : NSColor.yellow])
        textView.textStorage?.setAttributedString(attrString)
        textView.selectedRanges = [.init(range: selection)]
        print("End \(#function)", textView.selectedRanges)
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MyTextView
        unowned var textView: NSTextView!
        
        init(parent: MyTextView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            parent.text = textView.string
        }
        
        func textViewDidChangeSelection(_ notification: Notification) {
            parent.selection = textView.selectedRange()
        }
    }
}

#Preview {
    TextViewWrapper()
}
#endif
