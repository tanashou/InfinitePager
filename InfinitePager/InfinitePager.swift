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
    
    @State var currentPageId: Int
    @State var indexOffset: Int
    
    private var initialPageNum: Int
    private var modValue: Int
    private var pageNums: (Int, Int, Int)
    @Binding var shouldReset: Bool
    
    let pageView: (Binding<Int>) -> PageView
    
    init(_ initialPageNum: Int, shouldReset: Binding<Bool>, @ViewBuilder pageView: @escaping (Binding<Int>) -> PageView) {
        self.initialPageNum = initialPageNum // use in reset function
        self._shouldReset = shouldReset
        self.modValue = mod(initialPageNum, 3)
        
        // pageNum and pageId are in one-to-one correspondence.
        switch modValue {
        case 0:
            self.pageNums = (initialPageNum, initialPageNum + 1, initialPageNum - 1)
        case 1:
            self.pageNums = (initialPageNum - 1, initialPageNum, initialPageNum + 1)
        case 2:
            self.pageNums = (initialPageNum + 1, initialPageNum - 1, initialPageNum)
        default:
            // never executes
            self.pageNums = (0, 0, 0)
        }
        
        self._pageNum1 = State(initialValue: pageNums.0)
        self._pageNum2 = State(initialValue: pageNums.1)
        self._pageNum3 = State(initialValue: pageNums.2)
        self._currentPageId = State(initialValue: modValue)
        self._indexOffset = State(initialValue: initialPageNum >= 0 ? initialPageNum / 3 : initialPageNum / 3 - 1)
        self.pageView = pageView
    }
    
    
    var body: some View {
        let pages = [pageView($pageNum1),
                     pageView($pageNum2),
                     pageView($pageNum3)]
        
        PageViewController(pages: pages, pageNum1: $pageNum1, pageNum2: $pageNum2, pageNum3: $pageNum3, currentPageId: $currentPageId, indexOffset: $indexOffset, reset: $shouldReset)
            .onChange(of: shouldReset) { _ in
                if shouldReset {
                    DispatchQueue.main.async {
                        resetPageNums()
                        shouldReset = false
                    }
                    
                }
            }
        
    }
    
    func resetPageNums() {
        self.pageNum1 = pageNums.0
        self.pageNum2 = pageNums.1
        self.pageNum3 = pageNums.2
        currentPageId = modValue
        indexOffset = initialPageNum >= 0 ? initialPageNum / 3 : initialPageNum / 3 - 1
    }
}

struct InfinitePager_Previews: PreviewProvider {
    @State static var shouldReset = false
    static var previews: some View {
        InfinitePager(0, shouldReset: $shouldReset) { pageNum in
            SamplePage(pageNumber: pageNum)
        }
    }
}
