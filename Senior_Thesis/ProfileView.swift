//
//  ProfileView.swift
//  Senior_Thesis
//

import Foundation


import SwiftUI
import MapKit

struct ProfileView: View {
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
                    
                    Text("Senior")
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

            CameraViewDemo()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
                .tag(2)
            
            
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}