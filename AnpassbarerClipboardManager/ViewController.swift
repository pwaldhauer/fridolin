//
//  ViewController.swift
//  AnpassbarerClipboardManager
//
//  Created by Philipp Waldhauer on 14.02.19.
//  Copyright © 2019 io.pwa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var countLabel: NSTextField!
    @IBOutlet weak var selectTransformer: NSComboBox!
    
    var transformers: Array<String>?;
    
    @IBAction func clearButton(_ sender: Any) {
        ClipboardManager.shared.clear()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCountLabel), name: Notification.Name("pasteboardCount"), object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        
        self.view.window?.title = "Fridolin"
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func updateCountLabel(_ notification:Notification) {
        
        countLabel.stringValue = "\(notification.userInfo!["count"]!) items"
    }


}

