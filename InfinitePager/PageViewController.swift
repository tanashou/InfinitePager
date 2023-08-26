//
//  PageViewController.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2022/10/17.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    
    @Binding var pageNum1: Int
    @Binding var pageNum2: Int
    @Binding var pageNum3: Int
    @Binding var currentPageId: Int // Bindingにしないとresetできない。しかし，そうするとModifying state during view update エラーが起きる
    @Binding var indexOffset: Int
    
    @Binding var reset: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // need to change the pageNums when initialPageNum was modified.
        DispatchQueue.main.async {
            updatePages()
        }
        
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPageId]], direction: .forward, animated: false)
    }
    
    func updatePages() {
        let currentPage = indexOffset * 3 + currentPageId
        let currentNewPageId = mod(currentPage, 3)
        let pageNums: (Int, Int, Int)
        switch currentNewPageId {
        case 0:
            pageNums = (currentPage, currentPage + 1, currentPage - 1)
        case 1:
            pageNums = (currentPage - 1, currentPage, currentPage + 1)
        case 2:
            pageNums = (currentPage + 1, currentPage - 1, currentPage)
        default:
            // never executes
            pageNums = (0, 0, 0)
        }
        self.pageNum1 = pageNums.0
        self.pageNum2 = pageNums.1
        self.pageNum3 = pageNums.2
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        private var previousPageId: Int
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
            previousPageId = parent.currentPageId
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
                guard let index = controllers.firstIndex(of: viewController) else {
                    return nil
                }
                
                DispatchQueue.main.async {
                    self.detectPageLoop(index)
                }
                
                if index == 0 {
                    return controllers.last
                }
                
                return controllers[index - 1]
            }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
                guard let index = controllers.firstIndex(of: viewController) else {
                    return nil
                }
                
                DispatchQueue.main.async {
                    self.detectPageLoop(index)
                }
                
                if index + 1 == controllers.count {
                    return controllers.first
                }
                return controllers[index + 1]
            }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
                if completed,
                   let visibleViewController = pageViewController.viewControllers?.first,
                   let index = controllers.firstIndex(of: visibleViewController) {
                    // To support continuous scrolling of multiple pages without lifting fingers from the screen.
                    detectPageLoop(index)
                }
            }
        
        private func detectPageLoop(_ currentPageId: Int) {
            switch currentPageId - previousPageId {
            case 1: // page moved forward
                let updatingPageId = (currentPageId + 1) % 3
                updatePage(updatingPageId: updatingPageId, newPageNum: parent.indexOffset * 3 + currentPageId + 1)
            case -2: // page looped forward
                let updatingPageId = (currentPageId + 1) % 3
                parent.indexOffset += 1
                updatePage(updatingPageId: updatingPageId, newPageNum: parent.indexOffset * 3 + currentPageId + 1)
            case -1: // page moved backward
                let updatingPageId = (currentPageId + 2) % 3
                updatePage(updatingPageId: updatingPageId, newPageNum: parent.indexOffset * 3 + currentPageId - 1)
            case 2: // page looped backward
                let updatingPageId = (currentPageId + 2) % 3
                parent.indexOffset -= 1
                updatePage(updatingPageId: updatingPageId, newPageNum: parent.indexOffset * 3 + currentPageId - 1)
            default:
                break
            }
            
            previousPageId = currentPageId // update
            parent.currentPageId = currentPageId
        }
        
        private func updatePage(updatingPageId: Int, newPageNum: Int) {
            switch updatingPageId {
            case 0:
                parent.pageNum1 = newPageNum
            case 1:
                parent.pageNum2 = newPageNum
            case 2:
                parent.pageNum3 = newPageNum
            default:
                break
            }
        }
    }
    
}
