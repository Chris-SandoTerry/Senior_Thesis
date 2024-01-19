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
                    NavigationLink(destination: StudentScene(uni: uni).navigationBarBackButtonHidden(true), isActive: $showStudentScene) {
                        Text("Student")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }

                Button(action: {
                    // Handle Professor button tap
                    showProfessorScene.toggle()
                }) {
                    NavigationLink(destination: ProfessorScene(uni: uni).navigationBarBackButtonHidden(true), isActive: $showProfessorScene) {
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





struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
