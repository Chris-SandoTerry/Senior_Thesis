//
//  LoginView.swift
//  Software Project New Part
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift



struct SignUp: View {
    
    @StateObject private var viewModel = SignUpViewModel()
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
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark,style: .icon,state: .normal)) {
                Task{
                    do{
                        try await viewModel.SignInGoogle()
                        showSignUpView = false
                    }catch{
                        print(error)
                    }
                }
            }

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
