//
//  HelpClient.swift
//  XPCDemo
//
//  Created by Retouch on 2020/9/22.
//

import Foundation

class HelpClient: NSObject {
    
    static let share = HelpClient()
    
    var xpcConnection: NSXPCConnection?
    var tasks: [String]
    
    override init() {
        tasks = []
        super.init()
        initialConnection()
    }
    
    func validateXPC(with name: String) -> Bool {
        var isContinue = true
        objc_sync_enter(tasks)
        if checkXPCServiceIsReInital() {
            tasks.removeAll()
        }else{
            for task in tasks {
                if task == name {
                    isContinue = false
                    break
                }
            }
        }
        
        if isContinue {
            tasks.append(name)
        }
        
        objc_sync_exit(tasks)
        
        return isContinue
    }
    
    func checkXPCServiceIsReInital() -> Bool {
        var isNew = false
        guard let xpcConnection = xpcConnection else {
            print("xpcconnection is nil")

            initialConnection()
            return !isNew
        }
        print("xpcconnection is exist")
        let mySemaphore = DispatchSemaphore(value: 0)
        let now = Date().timeIntervalSince1970
        let remote = xpcConnection.remoteObjectProxy as! HelperProtocol
        remote.checkIsNewConnection(start: now) { (result) in
            print(result)
            isNew = result
            mySemaphore.signal()
        }
        
        let timeout = DispatchTime.now() + .seconds(5)
        _ = mySemaphore.wait(timeout: timeout)
        
        print("out checkXPCServiceIsReInital with result:\(isNew)")
        return isNew
    }

    func initialConnection() {
        xpcConnection = NSXPCConnection(serviceName: "com.tencent.test.Helper")
        xpcConnection?.remoteObjectProxyWithErrorHandler({ (error) in
            print(error)
        })
        xpcConnection?.remoteObjectInterface = NSXPCInterface(with: HelperProtocol.self)
        xpcConnection?.resume()
    }
    
    func test(name: String) {

        guard validateXPC(with: name) else { return }
        
        let downloader = xpcConnection?.remoteObjectProxyWithErrorHandler { (error) in
            print(error)
            } as! HelperProtocol
        
        downloader.upperCaseString(aString: "retouch") { (data) in
            print(data!)
//            self.closeXPC()
        }
    }
    
    func closeXPC() {
        let remote = xpcConnection?.remoteObjectProxy as! HelperProtocol
        remote.closeXPC()
        
        xpcConnection?.invalidate()
        xpcConnection = nil
    }
    
}
