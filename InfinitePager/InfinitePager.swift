//
//  InfinitePager.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI

struct InfinitePager<PageView: View>: View {
    // need 3 state variables to manage the view independently.
    @State var pageNum1: Int
    @State var pageNum2: Int
    @State var pageNum3: Int
    
    private var currentPageId: Int
    private var indexOffset: Int
    
    let pageView: (Binding<Int>) -> PageView
    
    init(initialPageNum: Int, @ViewBuilder pageView: @escaping (Binding<Int>) -> PageView) {
        let modValue = mod(initialPageNum, 3)
        let pageNums: (Int, Int, Int)
        
        // pageNum and pageId are in one-to-one correspondence.
        switch modValue {
        case 0:
            pageNums = (initialPageNum, initialPageNum + 1, initialPageNum - 1)
        case 1:
            pageNums = (initialPageNum - 1, initialPageNum, initialPageNum + 1)
        case 2:
            pageNums = (initialPageNum + 1, initialPageNum - 1, initialPageNum)
        default:
            // never executes
            pageNums = (0, 0, 0)
        }
        
        self._pageNum1 = State(initialValue: pageNums.0)
        self._pageNum2 = State(initialValue: pageNums.1)
        self._pageNum3 = State(initialValue: pageNums.2)
        self.currentPageId = modValue
        self.indexOffset = initialPageNum >= 0 ? initialPageNum / 3 : initialPageNum / 3 - 1
        self.pageView = pageView
    }
    
    
    var body: some View {
        // First element is set to be the middle.
        let pages = [pageView($pageNum1),
                     pageView($pageNum2),
                     pageView($pageNum3)]
        
        PageViewController(pages: pages, pageNum1: $pageNum1, pageNum2: $pageNum2, pageNum3: $pageNum3, currentPageId: currentPageId, indexOffset: indexOffset)
        
    }
}

struct InfinitePager_Previews: PreviewProvider {
    static var previews: some View {
        InfinitePager(initialPageNum: 0) { pageNum in
            SamplePage(pageNumber: pageNum)
        }
    }
}
