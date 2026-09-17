//
//  DashboardView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

struct DashboardView: View {
    var body: some View{
        Text("Dashboard")
            .navigationTitle("Dashboard")
    }
}

#Preview{
    NavigationStack{
        DashboardView()
    }
}
