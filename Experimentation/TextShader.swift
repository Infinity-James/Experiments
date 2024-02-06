//
//  TextShader.swift
//  Experimentation
//
//  Created by James Valaitis on 11/01/2024.
//

import SwiftUI

struct TextShader: View {
    private let shader = ShaderLibrary.stripes(.float(4))
    var body: some View {
        Text("Is this striped?")
            .font(.largeTitle)
            .foregroundStyle(shader)
    }
}


#Preview {
    TextShader()
}
