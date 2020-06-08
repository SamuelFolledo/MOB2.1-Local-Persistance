import UIKit

let anArray : [UInt8] = [226, 143, 179, 226, 156, 136, 239, 184, 143, 240, 159, 165, 179]
let exampleURL = URL(fileURLWithPath: "message", relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("txt") //message.txt file
let dataFromArray = Data(anArray)

print(exampleURL)
try dataFromArray.write(to: exampleURL, options: .atomic)

//read
let savedData = try Data.init(contentsOf: exampleURL)
print(savedData)

let arrayFromData = Array(savedData)
print(arrayFromData)

let stringWithMessage = String(data: savedData, encoding: .utf8)
print(stringWithMessage!)
