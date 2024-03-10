//
//  ProfessorView.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 11/14/23.
//

import Foundation
import SwiftUI

struct ProfessorScene: View 
{
    let uni: [String]

    var body: some View 
    {
        List(uni, id: \.self) { university in
            NavigationLink(destination: ProfessorProfile(showSingnedInView: .constant(false)).navigationBarBackButtonHidden(true)) 
            {
                Image(systemName: "star.fill")
                Text(university)
            }
            .padding()
        }
        .navigationTitle("Universities")
    }
}
