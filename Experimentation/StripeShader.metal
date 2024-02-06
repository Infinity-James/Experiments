//
//  StripeShader.metal
//  Experimentation
//
//  Created by James Valaitis on 11/01/2024.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 stripes(float2 position, float stripeWidth) {
    bool isAlternativeColor = uint(position.x / stripeWidth) & 1;
    return isAlternativeColor ? half4(0.4, 0.2, 0.2, 1) : half4(0.1, 0.5, 0.3, 1);
}
