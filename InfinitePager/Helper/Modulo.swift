//
//  Modulo.swift
//  InfinitePageSwiftUI
//
//  Created by tanashou on 2023/05/06
//  
//

import Foundation

func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
