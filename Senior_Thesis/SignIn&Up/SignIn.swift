//
//  LoginView.swift
//  Software Project New Part
//

import SwiftUI

struct SignIn: View {
    var body: some View {
        VStack{
            NavigationLink {
                SignInEmailView()
            } label: {
                Text("Sign Up With Email")
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            }

        }
        .padding()
        .navigationTitle("Sign In")
    }
}
        struct LoginView_Previews: PreviewProvider {
            static var previews: some View {
                NavigationStack
                {
                    SignIn()
                }
               
            }
        }
