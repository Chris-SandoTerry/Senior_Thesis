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
            if !ShowSignedInView{
                NavigationStack
                {
                  RegisterView(showSingnedInView: $ShowSignedInView)
                 //ProfileView(showSingnedInView: $ShowSignedInView)//profileView
                }
            }
            
        }
        .onAppear()
        {
            let authUser = try? AuthentaticationManager.shared.getAuthenticatedUser()
            self.ShowSignedInView = authUser == nil ? true:false
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
