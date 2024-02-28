//
//  SignUpView.swift
//  Senior_Thesis

import Foundation
import SwiftUI



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
            
            NavigationLink(destination: SettingsView(showSignedInView: .constant(false)).navigationBarBackButtonHidden(true), isActive: $navigateToRegister) {
                              EmptyView()
            }
            
            
            Button(action: 
            {
                Task
                {
                    do{
                        try await viewmodel.signUp()
                        ShowSignUpView = false
                        return
                    }
                    catch
                    {
                        print(error)
                    }
                    do{
                        try await viewmodel.signIn()
                        ShowSignUpView = false
                        return
                    }
                    catch
                    {
                        print(error)
                    }
                    //these should be seprate buttons^
                    
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

