//
//  TransformerSelectDataSource.swift
//  AnpassbarerClipboardManager
//
//  Created by Philipp Waldhauer on 15.02.19.
//  Copyright © 2019 io.pwa. All rights reserved.
//

import Cocoa

class TransformerSelectDataSource: NSObject, NSComboBoxCellDataSource, NSComboBoxDataSource, NSComboBoxDelegate  {
    var states: Array<String>
    
    override init() {
        
        states = []
        
        print("init")
        
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path!);
            
            
            
            for file in files {
                if(file.contains(".js")) {
                    states.append(file.replacingOccurrences(of: ".js", with: ""))
                }
            }
            
            print("\(files)")
        } catch {
            
            print(error.localizedDescription)
        }
        
        

    }
    
    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        
        print("SubString = \(string)")
        
        for state in states {
            // substring must have less characters then stings to search
            if string.count < state.count{
                // only use first part of the strings in the list with length of the search string
                let statePartialStr = state.lowercased()[state.lowercased().startIndex..<state.lowercased().index(state.lowercased().startIndex, offsetBy: string.count)]
                if statePartialStr.range(of: string.lowercased()) != nil {
                    print("SubString Match = \(state)")
                    return state
                }
            }
        }
        return ""
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return(states.count)
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return(states[index] as AnyObject)
    }
    
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        var i = 0
        for str in states {
            if str == string{
                return i
            }
            i += 1
        }
        return -1
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        print("lol \(notification)")
        
        let combo = notification.object as! NSComboBox
        ClipboardManager.shared.chooseTransformer(states[combo.indexOfSelectedItem])
    }
    
}
