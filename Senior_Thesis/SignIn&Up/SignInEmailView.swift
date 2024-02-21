//
//  SignUpView.swift
//  Senior_Thesis

import Foundation
import SwiftUI


final class SignUpEmailViewModel: ObservableObject
{
    @Published var email = ""
    @Published var password = ""
    
    func signIn()async throws{
        guard !email.isEmpty, !password.isEmpty else
        {
            print("No email or password found.")
            return
        }
        let returnedUserData = try await AuthentaticationManager.shared.createUser(email: email, password: password)
        
        
    }
}

struct SignUpEmailView: View {
    @State private var viewmodel = SignUpEmailViewModel()
    @State private var navigateToRegister = false
    @Binding var ShowSignUpView : Bool
   
    var body: some View {
        
        VStack {
            TextField("Email...", text: $viewmodel.email)
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            SecureField("Password...", text: $viewmodel.password)
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            
            NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true), isActive: $navigateToRegister) {
                              EmptyView()
            }
            
            
            Button(action: 
            {
                Task
                {
                    do{
                        try await viewmodel}
                    catch
                    {
                        
                    }
                }
                navigateToRegister = true
            },
                
                   label:
                {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            })
            
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}

       

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack
        {
            SignUpEmailView(ShowSignUpView: .constant(false))
        }
      
    }
}

