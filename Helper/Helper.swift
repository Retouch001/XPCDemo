//
//  Helper.swift
//  Helper
//
//  Created by Retouch on 2020/9/22.
//

import Foundation

class Helper : NSObject, HelperProtocol {

    var lastTimeInterval = 0.0
    
    func checkIsNewConnection(start: TimeInterval, complete: @escaping (Bool) -> Void) {
        if lastTimeInterval == 0 {
            lastTimeInterval = start
            print("lastTimeInterval == 0 back true")
            complete(true)
        }else{
            lastTimeInterval = start
            print("lastTimeInterval != 0 back false")
            complete(false)
        }
    }
    
    func closeXPC() {
        CFRunLoopStop(CFRunLoopGetMain())
        exit(0)
    }
    
    func upperCaseString(aString: String, withReply: @escaping (String?) -> Void) {
//        sleep(10)

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 10)
            DispatchQueue.main.async {
                withReply("Hello \(aString)")
            }
        }

    }
    
}
