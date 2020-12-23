//
//   SelectPDFView.swift
//  testForFileManager
//
//  Created by 宍戸知行 on 2020/12/22.
//

import SwiftUI
import UIKit

struct SelectPDFView: View {
    
    @State var show = false
    @State var selectedURLString = ""
    @State var filename = ""
    @State var alert = false
    @State var restoredItems = [StoredItem]()
    
    var body: some View {
        
        VStack{
            Spacer()
            Text("Current PDF:\(self.filename)")
                .fontWeight(.bold)
                .font(.title)
            Button(action: {
                self.show.toggle()
            }) {
                Text("PDF Picker")
                    .fontWeight(.bold)
                    .font(.title)
                    //  .foregroundColor(.black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 5))
            }
            .sheet(isPresented: $show, onDismiss:{DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.reloadAndListPDFFiles() }
                   print("the sheet is dismissed.")}
            ) {
                DocumentPicker(urlString:self.$selectedURLString, filename:self.$filename)
            }
            
            Divider()
            
            List{
                ForEach(restoredItems, id: \.self) { item in
                    if item.id % 2 == 0 {
                        ZStack {
                            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                            PDFItemRow(pdfItem: item)
                                //.listRowBackground(Color.green )
                                .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        }
                        .padding(.top, 0)
                    } else {
                        ZStack {
                            
                            PDFItemRow(pdfItem: item)
                                .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .onDelete(perform: delete)
                Spacer()
            }
        }
        .onAppear{
            //UserDefaultsの値の読み込み
            if let tempURLString = UserDefaults.standard.object(forKey: "urlString")  {
                self.selectedURLString = tempURLString as! String
            }
            //1秒後にreloadとlist表示を実行
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reloadAndListPDFFiles()
            }
        }
     }

    func reloadAndListPDFFiles(){
        //restoredItemsを初期化
        self.restoredItems = [StoredItem]()
        do {
            //Getting a list of the docs directory
            let docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last) as NSURL?
            
            print("docURLは\(String(describing: docURL))")
            
            //put the contents in an array.
            let contents = try FileManager.default.contentsOfDirectory(at: docURL! as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            //print the file listing to the console
            print("contentsは\(contents)")
            
            //add to restoredItem
            if contents.count > 0  {
                for i in 0..<contents.count {
                    let fileName = contents[i].lastPathComponent
                    let tempUrlTitle = fileName.removingPercentEncoding!
                    let tempUrlString = contents[i].absoluteString
                    
                    let tempItem = StoredItem(id: i, urlString: tempUrlString, urlTitle: tempUrlTitle)
                    
                    self.restoredItems.insert(tempItem, at: 0)
                }
            }
            
        }catch {
            print("読み出しエラー")
        }
        print("restoredItemsは、\(self.restoredItems.count)個あり、具体的には\(self.restoredItems)")
    }
    
    //delete function
    
    func delete(at offsets: IndexSet) {
        //self.restoredItems[Int(offsets)]
        
        do {
            
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let deletingURL = documentsURL.appendingPathComponent(
                "\(self.restoredItems[offsets.first!].urlTitle)")
            let encodedSavedURLpath = deletingURL.path.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            print("deleting urlString is \(String(describing: encodedSavedURLpath))")
            
            try FileManager.default.removeItem(atPath: encodedSavedURLpath!)
            
        }catch {
            print("file is not removed")
        }
        self.restoredItems.remove(atOffsets: offsets)
    }
    
}
struct SelectPDFView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPDFView()
    }
}
