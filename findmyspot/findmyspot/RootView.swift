//
//  RootView.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AuthViewModel.self) private var auth
    
    var body: some View {
        switch auth.state{
        case .loading:
            ProgressView("Loading...")
            
        case .signedOut:
            NavigationStack{
                SignInView()
            }
            
        case .signedIn:
            ContentView()
            
        }
    }
}
