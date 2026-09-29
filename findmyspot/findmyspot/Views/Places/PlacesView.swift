//
//  PlacesView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

struct PlacesView: View {
    private let placeRepository = PlaceRepository()
    
    var body: some View {
        PlacesMapView {
            try await placeRepository.getAll()
        }
    }
}

#Preview {
    ContentView()
}
