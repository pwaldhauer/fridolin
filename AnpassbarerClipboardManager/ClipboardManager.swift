//
//  ClipboardManager.swift
//  AnpassbarerClipboardManager
//
//  Created by Philipp Waldhauer on 15.02.19.
//  Copyright © 2019 io.pwa. All rights reserved.
//

import HotKey
import JavaScriptCore
import Cocoa

class ClipboardManager {

    static let shared = ClipboardManager()
    
    var lastContent: String
    var pasteboardContents : Array<String>
    var pasteboardWatcher : Timer?
    
    
    var transformerName : String
    var transformerCode : String
    
    func chooseTransformer(_ name: String) {
        transformerName = name;
        
        
        let fileManager = FileManager.default
        let path = "\(Bundle.main.resourcePath!)/\(name).js"
        
        
        print(path)
        
        do {
            
            transformerCode = try String(contentsOfFile: path)
            
            
            print(transformerCode)
        } catch {
            
        }
        
        
    }
    
    // Initialization
    
    private init() {
        
        transformerName = ""
        transformerCode = ""
        lastContent = ""
        pasteboardContents = []
        pasteboardWatcher = nil
        
        
        
        hotKey = HotKey(key: .b, modifiers: [.command])
        
        hotKey!.keyDownHandler = {
            
            
            print("LOOL buttong2")
            
            if(!self.pasteboardContents.isEmpty) {
                
                print("LOOL buttong3")
                
                let popFromStack: @convention(block) () -> String = {
                    return self.pasteboardContents.removeLast();
                }
                
                let paste: @convention(block) (String) -> Void = { content in
                    self.lastContent = content;
                    NSPasteboard.general.clearContents();
                    NSPasteboard.general.setString(self.lastContent, forType: .string)
                    
                    let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: true)
                    keyDownEvent?.flags = CGEventFlags.maskCommand
                    keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
                    
                    let keyDownEventUp = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: false)
                    keyDownEventUp?.flags = CGEventFlags.maskCommand
                    keyDownEventUp?.post(tap: CGEventTapLocation.cghidEventTap)
                }
                
                let context = JSContext()
                context?.exceptionHandler = { context, exception in
                    print("JS Error: \(exception!)")
                }
                
                context?.setObject(unsafeBitCast(paste, to: AnyObject.self), forKeyedSubscript: "paste" as (NSCopying & NSObjectProtocol)!)
                context?.setObject(unsafeBitCast(popFromStack, to: AnyObject.self), forKeyedSubscript: "popFromStack" as (NSCopying & NSObjectProtocol)!)
                
                context?.evaluateScript(self.transformerCode)
                
                let entryFunction = context?.objectForKeyedSubscript("entry")
                entryFunction?.call(withArguments: [self.pasteboardContents])
            }
            
        }
        print("init clipbm")
        
    }
    
    func clear() {
        self.pasteboardContents.removeAll()
        
        NotificationCenter.default.post(name: Notification.Name("pasteboardCount"), object: nil, userInfo: ["count": self.pasteboardContents.count])
    }
    
    func startWatching() {
        pasteboardWatcher = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
            let contents = NSPasteboard.general.string(forType: .string)
            if(contents != nil && self.lastContent != contents) {
                self.lastContent = contents!;
                self.pasteboardContents.append(contents!)
                
                NotificationCenter.default.post(name: Notification.Name("pasteboardCount"), object: nil, userInfo: ["count": self.pasteboardContents.count])
            }
            
        });
    }
    
    func stopWatching() {
        pasteboardWatcher?.invalidate()
    }

  var hotKey: HotKey?
    
}
