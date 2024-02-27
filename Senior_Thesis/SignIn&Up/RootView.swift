//
//  RootView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 2/21/24.
//

import SwiftUI

struct RootView: View {
    @State private var ShowSignedInView: Bool = false
    var body: some View {
       
        ZStack
        {
            NavigationStack
            {
                SettingsView(showSignedInView: $ShowSignedInView)
            }
        }
        .onAppear()
        {
            let authUser = try? AuthentaticationManager.shared.getAuthenticatedUser()
            self.ShowSignedInView = authUser == nil ? true:false
            
            try? AuthentaticationManager.shared.getProvider()
        }
        .fullScreenCover(isPresented: $ShowSignedInView)
        {
            NavigationStack
            {
                SignUp(showSignUpView: $ShowSignedInView)
            }
        }
    }
}

#Preview {
    RootView()
}
