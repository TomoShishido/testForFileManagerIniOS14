//
//  ContentView.swift
//  testForFileManager
//
//  Created by 宍戸知行 on 2020/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            PlayView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text(verbatim: NSLocalizedString("Play", comment: "リスト"))
                    
                }.tag(1)
            
            SelectPDFView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text(verbatim: NSLocalizedString("PDF", comment: "設定"))
                }.tag(0)
            
           
            
        }//TableView
        .accentColor(Color(red: 255/255, green: 233/255, blue: 51/255, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
