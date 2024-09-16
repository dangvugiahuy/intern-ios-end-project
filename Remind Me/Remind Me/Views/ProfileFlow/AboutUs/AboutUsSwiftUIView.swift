//
//  AboutUsSwiftUIView.swift
//  Remind Me
//
//  Created by huy.dang on 9/16/24.
//

import SwiftUI

struct AboutUsSwiftUIView: View {
    var body: some View {
        Form {
            Section(header: Text("App Info").textCase(nil)) {
                Text("Name:\t\t\tRemind Me")
                Text("Version:\t\t1.0")
                Text("Type:\t\t\tTodo List")
            }
            Section(header: Text("Author Info").textCase(nil)) {
                Text("Name:\t\t\tDang Vu Gia Huy")
                Text("BirthDay:\t\t20/01/2002")
                Text("Company:\tS3 CORP")
                Text("Position:\t\tiOS Developer Intern")
            }
        }
        .font(.custom("Poppins-Medium", size: 16))
    }
}

#Preview {
    AboutUsSwiftUIView()
}
