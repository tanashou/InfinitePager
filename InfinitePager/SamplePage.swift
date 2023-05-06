//
//  DemoView.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI

struct SamplePage: View {
    @Binding var pageNumber: Int
    
    init(pageNumber: Binding<Int>) {
        self._pageNumber = pageNumber
        print("Sample page initialized")
    }
    
    var body: some View {
        ZStack {
            Rectangle()
            // forgroundColor changes when pageNumber updates. You can see that only one page is updated per scroll. This helps the app to use less memory.
                .foregroundColor(Color(red: Double.random(in: 0...1),
                                       green: Double.random(in: 0...1),
                                       blue: Double.random(in: 0...1)))
            
            Text("\(pageNumber)")
        }
    }
}


struct SamplePage_Previews: PreviewProvider {
    @State static var pageNumber = 0
    static var previews: some View {
        SamplePage(pageNumber: $pageNumber)
    }
}
