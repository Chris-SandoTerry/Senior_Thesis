//
//  StudentClasses.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 6/8/24.
//

import SwiftUI





struct StudentClasses: View {
    var classList: [String]
    

    
    var body: some View {
        VStack{
            NavigationView {
                List{
                    HStack{
                        EditButton()
                        
                        Image(systemName: "plus")
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    StudentClasses(classList: [""])
}
