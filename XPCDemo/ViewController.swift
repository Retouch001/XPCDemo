//
//  ViewController.swift
//  XPCDemo
//
//  Created by Retouch on 2020/9/22.
//

import Cocoa

class ViewController: NSViewController {
    
    let client = HelpClient.share
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func tapButton(_ sender: Any) {
        client.test(name: "retouch")
    }
    
}

