//
//  SamplePage.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI

struct SamplePage: View {
    @Binding var pageNumber: Int
    var color: Color
    
    init(pageNumber: Binding<Int>) {
        self._pageNumber = pageNumber
        self.color = Color(red: Double.random(in: 0...1),
                                       green: Double.random(in: 0...1),
                                       blue: Double.random(in: 0...1))
        print("sample page initialized")
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(self.color)
            
            Text("\(pageNumber)")
                .font(.title)
        }
    }
}


struct SamplePage_Previews: PreviewProvider {
    @State static var pageNumber = 0
    static var previews: some View {
        SamplePage(pageNumber: $pageNumber)
    }
}
