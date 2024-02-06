//
//  TryingTips.swift
//  Experimentation
//
//  Created by James Valaitis on 10/01/2024.
//

import SwiftUI
import TipKit

struct TryingTips: View {
    @State private var isReady = false
    private let toolbarTip = LiftingTip()
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "swirl.circle.righthalf.filled")
                .imageScale(.large)
                .font(.largeTitle)
            Text("Let's Do This")
            TipView(RPETip())
                .tipBackground(.black)
                .foregroundStyle(.white)
                .tint(.yellow)
                .tipImageSize(.init(width: 32, height: 32))
                .tipCornerRadius(32)
            if isReady {
                Text("That's what I'm talking about!")
                    .font(.largeTitle)
                    .foregroundStyle(.indigo)
                    .padding()
                    .background { RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.yellow)
                    }
            }
            
            if RPETip.worthAsking == false {
                Button("Ask me") { RPETip.worthAsking = true }
            }
            
            
            Button("Open app") { RPETip.appOpenedCount.sendDonation() }
            
            Button("Invalidate toolbar tip") { toolbarTip.invalidate(reason: .actionPerformed) }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                } label: {
                    Image(systemName: "figure.strengthtraining.traditional")
                }
                .popoverTip(toolbarTip) { action in
                    guard action.id == "get-muscle" else { return }
                    isReady = true
                }
            }
        }
        
    }
}

struct LiftingTip: Tip {
    var title: Text { .init("Be stronger") }
    var message: Text? { .init("Lift more to grain muscle.") }
    var image: Image? { .init(systemName: "figure.strengthtraining.traditional") }
    var actions: [Action] {
        [
            Action(id: "get-muscle") { Text("Get muscle") }
        ]
    }
    var options: [TipOption] {
        [
            Tip.MaxDisplayCount(3),
            Tip.IgnoresDisplayFrequency(true)
        ]
    }
}

struct RPETip: Tip {
    @Parameter
    static var worthAsking: Bool = false
    static let appOpenedCount = Event(id: "appOpenedCount")
    var rules: [Rule] {
//        #Rule(Self.$worthAsking) { $0 == true }
        #Rule(Self.appOpenedCount) { $0.donations.count >= 3 }
    }
    
    var title: Text {
        Text("Push harder")
            .foregroundStyle(.white)
            .font(.title)
            .fontDesign(.serif)
            .bold()
    }
    
    var message: Text? {
        Text("Most of the hypertrophy stimulus in a set comes in the reps closest to failure.")
            .foregroundStyle(.white)
            .fontDesign(.monospaced)
    }
    
    var image: Image? { .init(systemName: "hands.clap") }
    
    var actions: [Action] {
        [
            Action(id: "learn-more") { Text("Learn more").foregroundStyle(.yellow) }
        ]
    }
}

#Preview {
    NavigationView {
        TryingTips()
            .onAppear { Tips.showAllTipsForTesting() }
    }
}
