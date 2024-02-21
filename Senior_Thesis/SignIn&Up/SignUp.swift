//
//  LoginView.swift
//  Software Project New Part
//

import SwiftUI

struct SignUp: View {
    @Binding var showSignUpView : Bool
    var body: some View {
        VStack{
            NavigationLink {
                SignUpEmailView(ShowSignUpView: $showSignUpView)
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
        .navigationTitle("Sign Up / Login")
        
        NavigationLink{
            SignUp(showSignUpView: $showSignUpView)
        } label:{
            Text("Sign In With Email")
                .foregroundColor(.blue)
               
        }
        .padding()
        .navigationTitle("Sign Up / Login")
    }
}
        struct LoginView_Previews: PreviewProvider {
            static var previews: some View {
                NavigationStack
                {
                    SignUp(showSignUpView: .constant(false))
                }
               
            }
        }
