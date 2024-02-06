//
//  FirstClassRepresentables.swift
//  Experimentation
//
//  Created by James Valaitis on 14/01/2024.
//

import MapKit
import SwiftUI

internal struct UsingMap: View {
    static let initialPosition = CLLocationCoordinate2D(latitude: 52.518611, longitude: 13.408333)
    @State private var position = Self.initialPosition
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HybridMap(position: $position)
            VStack {
                Text("\(position.latitude), \(position.longitude)")
                Button {
                    position = Self.initialPosition
                } label: {
                    Text("Reset position")
                    .padding()
                    .foregroundStyle(Color.white) }
                    .backgroundStyle(Color.pink)
            }
        }
        .ignoresSafeArea()
    }
}

public struct HybridMap: UIViewRepresentable {
    @Binding var position: CLLocationCoordinate2D
    
    public func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.preferredConfiguration = MKHybridMapConfiguration()
        return map
    }
    
    public func updateUIView(_ map: MKMapView, context: Context) {
        context.coordinator.parent = self
        guard map.centerCoordinate != position else { return }
        map.centerCoordinate = position
    }
    
    public func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    public final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: HybridMap
        init(parent: HybridMap) { self.parent = parent }
        
        public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                parent.position = mapView.centerCoordinate
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}

#Preview {
    UsingMap()
}
