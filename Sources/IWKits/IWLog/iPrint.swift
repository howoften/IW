//
//  iPrint.swift
//  haoduobaduo
//
//  Created by iWe on 2017/10/27.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

private let config = IWLogConfiguration.shared

// Print in Debug mode.
public func iPrint(_ item: Any..., file: String = #file, _ function: String = #function, _ line: Int = #line) -> Void {
    
    let output = getFinalOutput(item, fileName: file.lastPath, functionNamee: function, line: line)
    if iw.isDebugMode {
        print(output)
    }
    saveToLocal(output)
}

// Print Error in Debug mode.
public func iPrint(_ desc: String? = "", error: Error?, file: String = #file, _ function: String = #function, _ line: Int = #line) -> Void {
    
    var output = handlerPrint(fileName: file.lastPath, functionName: function, line: line)
    
    var info = ""
    if let er = error {
        info = ": \((desc == nil) ? "" : "\(desc!)," ) code=\(er.code), desc: \(er.description)"
    } else {
        info = ": \(desc ?? "")"
    }
    
    output += info.replace("  ", to: " ")
    
    if iw.isDebugMode, info != ": " {
        print(output)
    }
    
    if info != ": " {
        saveToLocal(output)
    }
}

// Print in Debug mode.
public func _Warning(_ item: Any..., file: String = #file, _ function: String = #function, _ line: Int = #line) -> Void {
    
    var output = getFinalOutput(item, fileName: file.lastPath, functionNamee: function, line: line)
    output = "[Warning] \(output)"
    if iw.isDebugMode {
        print(output)
    }
    saveToLocal(output)
}

private func getFinalOutput(_ item: Any..., fileName: String, functionNamee: String, line: Int) -> String {
    var output = handlerPrint(fileName: fileName, functionName: functionNamee, line: line)
    output += ":\n\(item.last!)"
    return output
}

private func handlerPrint(fileName: String, functionName: String, line: Int) -> String {
    var output = ""
    outputTime(&output)
    outputFileName(&output, fileName: fileName)
    outputFunctionName(&output, functionName: functionName)
    outputLine(&output, line: line)
    return output
}


private func outputTime(_ output: inout String) {
    if config.isOutputTime {
        output += "---- \(IWTime.current("YYYY-MM-dd HH:mm:ss.SSS"))"
    }
}

private func outputFileName(_ output: inout String, fileName: String) {
    if config.isOutputFileName {
        output += ", \(fileName)"
    }
}

private func outputFunctionName(_ output: inout String, functionName: String) {
    if config.isOutputFunctionName {
        if output.contains("(") {
            output += (", " + functionName + ":")
        } else {
            output += ("(" + functionName + ":")
        }
    }
}

private func outputLine(_ output: inout String, line: Int) {
    if output.contains("("), output.contains(",") {
        output += " \(line))"
    } else if output.contains("("), !output.contains(",") {
        output += "\(line))"
    } else if !output.contains("(") {
        output += "(\(line))"
    }
}

private func saveToLocal(_ output: String) {
    iw.queue.subThread(label: "iw.writelog") {
        if IWLogConfiguration.shared.isSaveToLocal {
            if let path = IWLogConfiguration.shared.recordLogPath {
                // 追加写入 而不是覆盖写入
                if let fileHandler = FileHandle.init(forUpdatingAtPath: path) {
                    fileHandler.seekToEndOfFile()
                    if let writingData = "\n\(output)".data(using: .utf8) {
                        fileHandler.write(writingData)
                        fileHandler.closeFile()
                    }
                }
            }
        }
    }
}
