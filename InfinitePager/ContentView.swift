//
//  ContentView.swift
//  InfinitePager
//
//  Created by tanashou on 2023/05/07
//  
//

import SwiftUI

struct ContentView: View {
    @State var initialPageNum = 0
    @State private var shouldReset = false
    
    var body: some View {
        VStack {
            InfinitePager(initialPageNum, reset: shouldReset) { pageNum in
                SamplePage(pageNumber: pageNum)
            }
            Text("reset page")
                .onTapGesture {
                    shouldReset.toggle()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
