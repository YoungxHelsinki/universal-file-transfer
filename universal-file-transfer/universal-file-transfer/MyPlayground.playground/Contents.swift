//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let fullName = "/0"
let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
// or simply:
// let fullNameArr = fullName.characters.split{" "}.map(String.init)

fullNameArr[0] // First
//fullNameArr[1] // Last

var a = [Int:Int]()
a[1] = 10
if let value = a[2] {
    print(1)
}
a.keys.contains()