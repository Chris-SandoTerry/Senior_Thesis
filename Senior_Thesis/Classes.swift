//
//  Classes.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/17/24.
//

import SwiftUI

struct Classes: View {
    let _class = classlist
    
    var body: some View {
        List(_class, id: \.self) 
        { _class in
        NavigationLink(destination: Text(_class)) 
            {
                Image(systemName: "folder.fill")
                Text(_class)
            }
            .padding()
        }
        .navigationTitle("Classes")
    }
}


#Preview {
    Classes()
}
