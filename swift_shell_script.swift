#!/usr/bin/swift

import Foundation

func shellExecute(cmd :String, args: [String], currentDirectoryPath : String = ".") -> String
{
	let task = NSTask()
	if cmd.hasPrefix("/") {
		task.launchPath = cmd
	}
	else {
		let fullpathCmd = shellExecute("/usr/bin/which", args:[cmd])
		if fullpathCmd.characters.count > 0 {
			task.launchPath = fullpathCmd.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		}
		else {
			return "Unknown command."
		}
	}
	task.arguments = args
	task.currentDirectoryPath = currentDirectoryPath
	let pipe: NSPipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    let out : NSData = pipe.fileHandleForReading.readDataToEndOfFile()
    let result : String? = NSString(data: out, encoding: NSUTF8StringEncoding) as? String
    return result ?? ""
}

let result = shellExecute("ls", args: [])
print("\(result)")
