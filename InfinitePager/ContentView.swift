//
//  ContentView.swift
//  InfinitePager
//
//  Created by tanashou on 2023/05/07
//  
//

import SwiftUI

struct ContentView: View {
    @State var currentPageNum = 0
    
    var body: some View {
        InfinitePager(currentPageNum: $currentPageNum) { pageNum in
            SamplePage(pageNumber: pageNum)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
