//
//  PlussingYourApp.swift
//  Experimentation
//
//  Created by James Valaitis on 14/01/2024.
//

import SwiftUI

//  MARK: Spacing System
public struct Grid {
    static let extraExtraSmall: CGFloat = 2
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 32
    static let extraLarge: CGFloat = 64
}

public struct CircleButton: View {
    public var body: some View {
        Button { 
            
        } label: {
            Image(systemName: "plus")
                .font(.system(size: Grid.large))
                .foregroundColor(.white)
                .frame(width: Grid.extraLarge, height: Grid.extraLarge)
                .background(Color.indigo.gradient)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: Grid.small, x: 0, y: Grid.small)
        }
    }
}

//  MARK: Typograhy Tweaks
extension UIFont {
    func fontWithFeature(key: Int, value:Int) -> UIFont {
        let originalDesc = self.fontDescriptor
        let features:[UIFontDescriptor.AttributeName: Any] = [
            UIFontDescriptor.AttributeName.featureSettings : [
                [
                    UIFontDescriptor.FeatureKey.type: key,
                    UIFontDescriptor.FeatureKey.selector: value
                ]
            ]
        ]
        let newDesc = originalDesc.addingAttributes(features)
        return UIFont(descriptor: newDesc, size: 0.0)
    }
    
    func fontWithHighLegibility() -> UIFont {
        return self.fontWithFeature(key: kStylisticAlternativesType, value: kStylisticAltSixOnSelector)
    }
}

struct HighlyLegibleText: View {
    var body: some View {
        Text("... THIS contains a capital 'i', while that was a lowercase 'l'. Highly legible, right?")
            .font(Font(UIFont
                .preferredFont(forTextStyle: .title2)
                .fontWithHighLegibility()
            ))
    }
    
}

//  MARK: Use Menus!
struct WithAMenu: View {
    var body: some View {
        VStack {
            Menu("So Many Activities") {
                Button {
                    
                } label: {
                    Label(
                        title: { Text("Running") },
                        icon: { Image(systemName: "figure.run") }
                    )
                    Text("The adrenaline! The speed! 🏎️")
                }
                
                Button {
                    
                } label: {
                    Label(
                        title: { Text("Jumping") },
                        icon: { Image(systemName: "figure.jumprope") }
                    )
                    Text("Like a kangaroo but even cooler. 😎")
                }
                
                Button {
                    
                } label: {
                    Label(
                        title: { Text("Climbing") },
                        icon: { Image(systemName: "figure.climbing") }
                    )
                    Text("This ain't only for Peter or Miles. 🙌")
                }
            }
        }
    }
}

#Preview {
    VStack {
        CircleButton()
        HighlyLegibleText()
        WithAMenu()
    }
    .padding()
}

