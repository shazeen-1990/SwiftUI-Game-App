//
//  InfoView.swift
//  Slot Machine
//
//  Created by Shazeen Thowfeek on 09/04/2024.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack(alignment:.center,spacing: 10){
            LogoView()
            
            Spacer()
            
            Form{
                Section(header: Text("About the application")){
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone/iPad/Mac")
                    FormRowView(firstItem: "Developer", secondItem: "John/jane")
                    FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
                    FormRowView(firstItem: "Music", secondItem: "Dan Lebowtiz")
                    FormRowView(firstItem: "Website", secondItem: "shaeen.com")
                    FormRowView(firstItem: "Copyright", secondItem: "@ 2020 All rights reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top,40)
        .overlay(
            Button(action: {
                //Action
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })
            .padding(.top,30)
            .padding(.trailing,20)
            .accentColor(.secondary)
            ,alignment: .topTrailing
        )
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack{
            Text(firstItem).foregroundColor(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

#Preview {
    InfoView()
}


