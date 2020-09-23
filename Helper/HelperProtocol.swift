//
//  HelperProtocol.swift
//  Helper
//
//  Created by Retouch on 2020/9/22.
//

import Foundation

@objc(HelperProtocol)
protocol HelperProtocol {
    func upperCaseString(aString: String, withReply: @escaping (String?)->Void)
    func closeXPC()
    func checkIsNewConnection(start: TimeInterval, complete: @escaping (Bool)->Void)
}
