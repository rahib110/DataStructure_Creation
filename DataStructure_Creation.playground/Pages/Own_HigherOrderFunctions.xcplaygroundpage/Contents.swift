import UIKit

var greeting = "Welcome to iMRhb 👋 code playground"

/// ============== ``Map ==============
///
extension Sequence {
    func myMap<Result>(_ transform: (Element) -> Result) -> [Result] {
        var result: [Result] = []
        for item in self {
            result.append(transform(item))
        }
        return result
    }
}

// Array
let mapArr = [1, 2, 3, 4, 5]
print("Map Array:", mapArr.myMap({ $0 * 2 }))
// Dictionary
let mapDic = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5]
print("Map Dict:", mapDic.myMap({ $0.value * 2 }))
// Set
let mapSet: Set<Int> = [1, 2, 3, 4, 5]
print("Map Set:", mapSet.myMap({ $0 * 2 }))
print("========== \n")


/// ============== ``Compact Map ==============
///

extension Sequence {
    func myCompactMap<Result>(_ transform: (Element) -> Result?) -> [Result] {
        var result = [Result]()
        for item in self {
            if let value = transform(item) {
                result.append(value)
            }
        }
        return result
    }
}

// Array
let compMapArr = ["1", "2", "abc", "10"]
print("C Map Array:", compMapArr.myCompactMap( { Int($0)} ))
// Dictionary
let compMacDict: [String: String] = ["name": "M Rahib", "Address": "Raja Ji Puram", "Pincode": "226017"]
print("C Map Dic:", compMacDict.myCompactMap({ Int($0.value) }))
// Set
let compMapSet: Set<String> = ["1", "2", "abc", "10"]
print("C Map Set:", compMapSet.myCompactMap( { Int($0) } ))
print("========== \n")



/// ============== ``Filter ==============
///

extension Sequence {
    func myFilter(_ predicate: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for item in self {
            if predicate(item) {
                result.append(item)
            }
        }
        return result
    }
}

// Array
let filterArr = [1, 2, 3, 4, 5, 6]
print("Filter Array:", filterArr.myFilter({ $0 % 2 == 0 }))
let filterStringArr = ["M Rahib", "Gautam", "Miku", "Ankit"]
print("Filter Array:", filterStringArr.myFilter( { $0.first == "M"} ))
// Dictionary
let filterDict: [String: Int] = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5]
print("Filter Dictionary:", filterDict.myFilter( { $0.value.isMultiple(of: 2)} ))
// Set
let filterSet: Set<Int> = [1, 2, 3, 4, 5]
print("Filter Set:", filterSet.myFilter( { $0.isMultiple(of: 2) } ))
print("========== \n")



/// ============== ``Reduce ==============
///

extension Sequence {
    func myReduce<Result>(_ initialValue: Result, _ operation: (Result, Element) -> Result) -> Result {
        var accumulativeValue = initialValue
        for item in self {
            accumulativeValue = operation(accumulativeValue, item)
        }
        return accumulativeValue
    }
}

// Array
let reduceArr = [1, 2, 3, 4, 5]
print("Reduce Array:", reduceArr.myReduce(0, { $0 + $1 }))
// Dictionary
let reduceDict: [String: Int] = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5]
print("Reduce Dict:", reduceDict.myReduce(0, { $0 + $1.value }))
print("Reduce Dict:", reduceDict.myReduce(5, { result, dict in
    return result + dict.value
}))
// Set
let reduceSet: Set<Int> = [1, 2, 3, 4, 5]
print("Reduce Set:", reduceSet.myReduce(0, +))
print("========== \n")


/// ============== ``Sort ==============
///

extension Sequence {
    func mySorted(by isIncreasing: (Element, Element) -> Bool) -> [Element] {
        var result: [Element] = Array(self) /// Note:  convert Array(self) and assign into result
        guard result.count > 1 else {
            return result
        }
        for i in 1..<result.count {
            var j = i
            while j > 0 && isIncreasing(result[j], result[j - 1]) {
                result.swapAt(j, j - 1)
                j -= 1
            }
        }
        return result
    }
}

// Array
let sortArr = [3, 1, 77, 99, 22, 12]
print("Sort Array:", sortArr.mySorted(by: >))
let sortStringArr = ["M Rahib", "Gautam", "Miku", "Ankit"]
print("Sort Array:", sortStringArr.mySorted(by: <))
print("Sort Array:", sortStringArr.mySorted(by: { val1, val2 in
    return val1 > val2
}))
// Dictionary
let softDict = ["a": 10, "b": 1, "c": 7, "d": 5, "e": 2]
print("Sort Dict:", softDict.mySorted(by: { $0.value > $1.value }))
print("Sort Dict:", softDict.mySorted(by: { $0.key < $1.key }))
// Set
let setArr: Set<Int> = [1, 3, 5, 2, 4]
print("Sort Set:", setArr.mySorted(by: <))
print("========== \n")

/// ============== ``ForEach ==============
///

extension Sequence {
    func myForEach(_ action: (Element) -> Void) {
        for item in self {
            action(item)
        }
    }
}

// Array
let forEachArr = [1, 2, 3, 4, 5]
print("ForEach Array:", forEachArr.myForEach ( { print($0 * 2) } ))
// Dictionary
let forEachDict: [String: Int] = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5]
print("ForEach Dict:", forEachDict.myForEach { print($0.value * 3) })
// Set
let forEachSet: Set<Int> = [1, 2, 3, 4, 5]
print("ForEach Set:", forEachSet.myForEach { print($0) })
print("========== \n")

//Note: forEach, first it's printing the result in console then printing the string like: "ForEach Array:"
