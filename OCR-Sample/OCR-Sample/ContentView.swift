//
//  ContentView.swift
//  OCR-Sample
//
//  Created by birdsea on 2024/01/02.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    @ObservedObject var model = OCR_SampleModel()
    
    var body: some View {
        NavigationView {
            
            VStack{
                HStack{
                    Label(
                        title: {
                            Text(
                                "images"
                            )
                        },
                        icon: {
                            Image(
                                systemName: "photo"
                            )
                        }
                    ).padding(EdgeInsets(
                        top: 0,
                        leading: 10,
                        bottom: 0,
                        trailing: 0
                    ))
                    Spacer()
                }
                List {
                    ForEach(
                        model.imageArray,
                        id: \.self
                    ) { image in
                        Image(
                            uiImage: image
                        )
                        .resizable()
                        .aspectRatio(
                            contentMode: .fit
                        )
                    }
                }
                HStack{
                    Label(
                        title: {
                            Text(
                                "texts"
                            )
                        },
                        icon: {
                            Image(
                                systemName: "doc.text"
                            )
                        }
                    ).padding(EdgeInsets(
                        top: 0,
                        leading: 10,
                        bottom: 0,
                        trailing: 0
                    ))
                    Spacer()
                }
                List {
                    ForEach(
                        model.textArray,
                        id: \.self
                    ) { text in
                        Text(
                            text
                        )
                    }
                }
                .navigationTitle(
                    "OCR Sample"
                )
                .toolbar {
                    ToolbarItem {
                        Button(
                            "scan"
                        ) {
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let window = windowScene?.windows
                            window?.filter({
                                $0.isKeyWindow
                            }).first?.rootViewController?.present(
                                model.getDocumentCameraViewController(),
                                animated: true
                            )
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

