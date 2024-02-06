//
//  ContentView.swift
//  Experimentation
//
//  Created by James Valaitis on 10/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TestingLiveActivity()
        }
    }
}

struct TransitioningScrollViews: View {
    @State private var items = (1...32).map { idx in String.random(ofLength: idx) }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ForEach(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.random)
                        .frame(height: 128)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .scrollTransition(.animated(.smooth)) { effect, phase in
                            effect
                                .opacity(1 - abs(phase.value))
                                .rotationEffect(.radians(phase.value))
                        }
                            
                }
            }
            .padding()
        }
    }
}

extension String {
    static func random(ofLength length: Int = 32) -> Self {
        String((0..<length).map { _ in
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
        })
    }
}

extension Color {
    static var random: Self {
        [red,
         pink,
         orange,
         blue,
         yellow,
         green,
         purple,
         cyan,
         brown,
         indigo,
         mint,
         teal].randomElement()!
    }
}

#Preview {
    ContentView()
}
