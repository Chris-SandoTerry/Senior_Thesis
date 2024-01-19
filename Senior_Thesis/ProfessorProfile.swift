//
//  ProfessorProfile.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/19/24.
//

import Foundation
import SwiftUI
import MapKit

struct ProfessorProfile: View {
    @State private var selection = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var showloginscreen = false
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                VStack(spacing: 20) {
                    Image("SeniorPoject")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text("CST")
                        .font(.title)
                        .bold()
                    
                    Text("Professor")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    
                    Divider()
                    

                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        showloginscreen = true
                    })
                    {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                    
                    }
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $showloginscreen)
                    {
                        EmptyView()
                    }
                    
                }
                .padding()
                .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(0)
            
            Classes()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Classes")
                }
                .tag(1)

            QrCodeImage()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Qr Code")
                }
                .tag(2)
            
            
        }
    }
}

#Preview {
    ProfessorProfile()
}
