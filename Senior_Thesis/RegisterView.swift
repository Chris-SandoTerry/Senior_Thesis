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
    let uni = unilist 

    var body: some View {
        NavigationView {
            VStack {
                Text("Choose to which apply")
                    .font(.title)
                    .padding()

                Button(action: {
                    // Handle Student button tap
                    showStudentScene.toggle()
                }) {
                    NavigationLink(destination: StudentScene(uni: uni), isActive: $showStudentScene) {
                        Text("Student")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }

                Button(action: {
                    // Handle Professor button tap
                    showProfessorScene.toggle()
                }) {
                    NavigationLink(destination: ProfessorScene(), isActive: $showProfessorScene) {
                        Text("Professor")
                            .foregroundColor(.green)
                            .padding()
                    }
                }

                Spacer()
            }
            .navigationTitle("Apply")
        }
    }
}

struct StudentScene: View {
    let uni: [String]

    var body: some View {
        List(uni, id: \.self) { university in
            NavigationLink(destination: Text(university)) {
                Image(systemName: "star.fill")
                Text(university)
                
            }
            .padding()
        }
        .navigationTitle("Universities")
    }
}

struct ProfessorScene: View {
    var body: some View {
        Text("Professor Scene")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
