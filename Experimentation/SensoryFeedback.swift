//
//  SensoryFeedback.swift
//  Experimentation
//
//  Created by James Valaitis on 14/01/2024.
//

import SwiftUI

struct SensoryFeedback: View {
    @State private var items = (0..<32).map { "\($0)" }
    @State private var selected: String?
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        List(items, id: \.self, selection: $selected) { item in
            Text(item)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .backgroundStyle(Color.pink.gradient)
        }
        //  pre–iOS 17
//        .onChange(of: selected) { old, new in if new != nil { generator.selectionChanged() } }
        //  iOS 17
        .sensoryFeedback(trigger: selected) { old, new in
            guard let new, let code = Int(new) else { return .error }
            switch code {
            case 0: return .selection
            case 1: return .alignment
            case 2: return .warning
            case 3: return .error
            case 4: return .impact(weight: .heavy, intensity: 5)
            case 5: return .levelChange
            default: return .success
            }
        }
        
    }
}

#Preview {
    SensoryFeedback()
}


