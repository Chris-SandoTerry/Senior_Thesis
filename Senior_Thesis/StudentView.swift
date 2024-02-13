//
//  StudentView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 11/14/23.
//

import Foundation
import SwiftUI


struct StudentScene: View {
    let uni: [String]
    @State private var selectedUniversity: String?
    var body: some View {
        NavigationView {
            List(uni, id: \.self) { university in
                NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)) {
                   
                    HStack {
                        Image(systemName: "star.fill")
                        Text(university)
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Universities")
        }
    }
}
