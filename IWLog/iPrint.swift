//
//  iPrint.swift
//  haoduobaduo
//
//  Created by iWe on 2017/10/27.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation

#if DEBUG
let isDebugMode = true
#else
let isDebugMode = false
#endif

private let config = IWLogConfiguration.shared

// Print in Debug mode.
func iPrint(_ item: Any..., file: String = #file, _ function: String = #function, _ line: Int = #line) -> Void {
	
    var output = handlerPrint(fileName: file.lastPath, functionName: function, line: line)
    output += ": \(item.last!)\n"
	if isDebugMode == true {
        print(output)
    }
    saveToLocal(output)
}

// Print Error in Debug mode.
func iPrint(_ desc: String? = "", error: Error?, file: String = #file, _ function: String = #function, _ line: Int = #line) -> Void {
    var output = handlerPrint(fileName: file.lastPath, functionName: function, line: line)
	
	var info = ""
    if let er = error {
        let nsError = er as NSError
		info = ": \((desc == nil || desc == "") ? "" : "\(desc!)," ) errorCode=\(nsError.code), description: \(nsError.localizedDescription)\n"
    } else {
        info = ": \(desc ?? "")\n"
    }
	
	output += info.replace("  ", to: " ")
    
	if isDebugMode == true, info != ": \n" {
        print(output)
    }
	
	if info != ": \n" {
		saveToLocal(output)
	}
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
		output += "\(IWTime.current("YYYY-MM-dd HH:mm:ss.SSS"))"
    }
}

private func outputFileName(_ output: inout String, fileName: String) {
    if config.isOutputFileName {
        output += " \(fileName)"
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
	iw.subThread.execution {
		if IWLogConfiguration.shared.isSaveToLocal {
			if let path = IWLogConfiguration.shared.recordLogPath {
				if let logData = IWFileManage.default.contents(atPath: path) {
					let logString = logData.stringValue + "\n\(output)"
					do {
						try logString.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
					} catch {
						iPrint("Record failed.")
					}
				}
			}
		}
	}
}
