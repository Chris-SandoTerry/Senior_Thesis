//
//  SignUpView.swift
//  Senior_Thesis

import Foundation
import SwiftUI


final class SignInEmailViewModel: ObservableObject
{
    @Published var email = ""
    @Published var password = ""
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else
        {
            print("No email or password found.")
            return
        }
        Task
        {
            do
            {
                let returnedUserData = try await AuthentaticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            }
            catch
            {
                print("Error: \(error)")
            }
        }
    }
}

struct SignInEmailView: View {
    @State private var viewmodel = SignInEmailViewModel()
   
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
            
            Button(action: 
            {
                viewmodel.signIn()
                
            },
                
                   label:
                {
                Text("Sign In ")
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            })
            
        }
        .padding()
        .navigationTitle("Login")
    }
}

       

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack
        {
            SignInEmailView()
        }
      
    }
}

