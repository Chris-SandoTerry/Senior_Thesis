//
//  RegisterView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 11/13/23.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var showStudentScene = false
    @State private var showProfessorScene = false
    @StateObject private var viewModel = ProfileViewModel()
    let uni = unilist

    var body: some View {
        NavigationView {
            VStack {
                Text("Choose to which apply")
                    .font(.title)
    
                let user = viewModel.user

                NavigationLink(destination: ProfileView(showSingnedInView: $showStudentScene).navigationBarBackButtonHidden(true), isActive: $showStudentScene) {
                    Text("Apply as a Student")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .isDetailLink(false)
                
               
                
                NavigationLink(destination: ProfileView(showSingnedInView: $showProfessorScene).navigationBarBackButtonHidden(true), isActive: $showProfessorScene) {
                    Text("Apply as a Professor")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .isDetailLink(false)
            }
            .navigationTitle("Apply")
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
