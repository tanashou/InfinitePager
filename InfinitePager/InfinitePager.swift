//
//  InfinitePager.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI

struct InfinitePager<PageView: View>: View {
    @Binding var currentPageNum: Int
    // need 3 state variables to manage the view independently.
    @State var pageNum0: Int
    @State var pageNum1: Int
    @State var pageNum2: Int
    
    private var currentPageId: Int
    private var indexOffset: Int
    
    let pageView: (Binding<Int>) -> PageView
    
    init(currentPageNum: Binding<Int>, @ViewBuilder pageView: @escaping (Binding<Int>) -> PageView) {
        self._currentPageNum = currentPageNum
        let pageNums: (Int, Int, Int)
        
        // pageNum and pageId are in one-to-one correspondence.
        switch mod(currentPageNum.wrappedValue, 3) {
        case 0:
            pageNums = (currentPageNum.wrappedValue, currentPageNum.wrappedValue + 1, currentPageNum.wrappedValue - 1)
        case 1:
            pageNums = (currentPageNum.wrappedValue - 1, currentPageNum.wrappedValue, currentPageNum.wrappedValue + 1)
        case 2:
            pageNums = (currentPageNum.wrappedValue + 1, currentPageNum.wrappedValue - 1, currentPageNum.wrappedValue)
        default:
            // never executes
            pageNums = (0, 0, 0)
        }
        
        self._pageNum0 = State(initialValue: pageNums.0)
        self._pageNum1 = State(initialValue: pageNums.1)
        self._pageNum2 = State(initialValue: pageNums.2)
        self.currentPageId = mod(currentPageNum.wrappedValue, 3)
        self.indexOffset = currentPageNum.wrappedValue >= 0 ? currentPageNum.wrappedValue / 3 : currentPageNum.wrappedValue / 3 - 1
        self.pageView = pageView
    }
    
    
    var body: some View {
        // First element is set to be the middle.
        let pages = [pageView($pageNum0),
                     pageView($pageNum1),
                     pageView($pageNum2)]
        
        PageViewController(pages: pages, currentPageNum: $currentPageNum, pageNum0: $pageNum0, pageNum1: $pageNum1, pageNum2: $pageNum2, currentPageId: currentPageId, indexOffset: indexOffset)
        
        
    }
}

struct InfinitePager_Previews: PreviewProvider {
    @State static var pageNum = 0
    static var previews: some View {
        InfinitePager(currentPageNum: $pageNum) { pageNum in
            SamplePage(pageNumber: pageNum)
        }
    }
}
