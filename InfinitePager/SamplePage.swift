//
//  SamplePage.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI

struct SamplePage: View {
    @Binding var pageNumber: Int
    let color = Color(red: Double.random(in: 0...1),
                      green: Double.random(in: 0...1),
                      blue: Double.random(in: 0...1))
    
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
