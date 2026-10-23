<div align="center">

# ✨ Swift Higher-Order Functions

### Build `map`, `compactMap`, `filter`, `reduce`, `forEach` & `sorted` from scratch

**One generic `Sequence` extension. Arrays, dictionaries, sets, and more.**

![Swift](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=for-the-badge&logo=swift&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-222?style=for-the-badge&logo=apple&logoColor=white)
![Learning](https://img.shields.io/badge/Focus-DSA%20%26%20Interviews-0B7285?style=for-the-badge)

*Understand the logic behind Swift's most useful functional programming APIs.*

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Why `Sequence` instead of `Array`?](#-why-sequence-instead-of-array)
- [Complete implementation](#-complete-implementation)
- [Usage examples](#-usage-examples)
- [Complexity cheat sheet](#-complexity-cheat-sheet)
- [Important differences from standard Swift APIs](#-important-differences-from-standard-swift-apis)
- [Interview questions](#-interview-questions)
- [Try it yourself](#-try-it-yourself)

## 🚀 Overview

Higher-order functions accept a function (or closure) as an argument, return a function, or both. In Swift, they make transformations, filtering, aggregation, and iteration expressive and reusable.

| Function | What it does | Example output |
| :--- | :--- | :--- |
| `myMap` | Transforms each element | `[1, 2]` → `[2, 4]` |
| `myCompactMap` | Transforms and discards `nil` | `["1", "x"]` → `[1]` |
| `myFilter` | Keeps matching elements | `[1, 2, 3]` → `[2]` |
| `myReduce` | Combines values into one result | `[1, 2, 3]` → `6` |
| `myForEach` | Performs an action on each element | Prints each value |
| `mySorted` | Returns elements in order | `[3, 1, 2]` → `[1, 2, 3]` |

## 🧩 Why `Sequence` instead of `Array`?

```text
             Sequence
                 │
             Collection
           ┌─────┼─────┐
         Array  Set  Dictionary
```

The diagram is simplified: these types have additional protocol conformances. The key idea is that **all three conform to `Sequence`**.

An `Array` extension works only on arrays. A `Sequence` extension also works on sets, dictionaries, strings (characters), ranges, and custom sequences.

> **Key insight:** `Element` is the input sequence's element type. `Result` is a generic output type inferred from the transformation closure.

## 🛠 Complete implementation

Copy this into `HigherOrderFunctions.swift` or a Swift Playground:

```swift
extension Sequence {
    // MARK: - Map
    func myMap<Result>(_ transform: (Element) -> Result) -> [Result] {
        var result: [Result] = []
        for element in self {
            result.append(transform(element))
        }
        return result
    }

    // MARK: - CompactMap
    func myCompactMap<Result>(_ transform: (Element) -> Result?) -> [Result] {
        var result: [Result] = []
        for element in self {
            if let value = transform(element) {
                result.append(value)
            }
        }
        return result
    }

    // MARK: - Filter
    func myFilter(_ predicate: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for element in self where predicate(element) {
            result.append(element)
        }
        return result
    }

    // MARK: - Reduce
    func myReduce<Result>(
        _ initialValue: Result,
        _ combine: (Result, Element) -> Result
    ) -> Result {
        var accumulator = initialValue
        for element in self {
            accumulator = combine(accumulator, element)
        }
        return accumulator
    }

    // MARK: - ForEach
    func myForEach(_ action: (Element) -> Void) {
        for element in self {
            action(element)
        }
    }

    // MARK: - Sorted (Insertion Sort for learning)
    func mySorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = Array(self)
        guard result.count > 1 else { return result }

        for i in 1..<result.count {
            var j = i
            while j > 0 && areInIncreasingOrder(result[j], result[j - 1]) {
                result.swapAt(j, j - 1)
                j -= 1
            }
        }
        return result
    }
}
```

## 💻 Usage examples

### 1. Array: transform, select, combine

```swift
let numbers = [1, 2, 3, 4, 5]

print(numbers.myMap { $0 * 2 })         // [2, 4, 6, 8, 10]
print(numbers.myFilter { $0.isMultiple(of: 2) }) // [2, 4]
print(numbers.myReduce(0, +))           // 15

numbers.myForEach { print("Value: \($0)") }
```

**Why doesn't `myForEach` print by itself?** It executes the closure you provide. Printing happens only when your closure calls `print` (or another side effect).

### 2. `compactMap`: remove invalid conversions

```swift
let inputs = ["10", "not-a-number", "30"]
let parsed = inputs.myCompactMap { Int($0) }
print(parsed) // [10, 30]
```

`map` keeps one output per input (including optional values); `compactMap` discards `nil` results.

### 3. Dictionary: `reduce` values

```swift
let reduceDict: [String: Int] = [
    "a": 1, "b": 2, "c": 3, "d": 4, "e": 5
]

let total = reduceDict.myReduce(0) { accumulator, entry in
    accumulator + entry.value
}
print(total) // 15

let doubledPairs = reduceDict.myMap { (key: $0.key, value: $0.value * 2) }
// Array of labeled tuples; dictionary iteration order is unspecified.
```

Build a **new dictionary** with built-in `reduce(into:)`:

```swift
let doubledDictionary = reduceDict.reduce(into: [String: Int]()) {
    partialResult, entry in
    partialResult[entry.key] = entry.value * 2
}
// ["a": 2, "b": 4, "c": 6, "d": 8, "e": 10]
```

### 4. Set: transform and sort

```swift
let uniqueNumbers: Set<Int> = [5, 2, 8, 1]
let squares = uniqueNumbers.myMap { $0 * $0 } // [Int], arbitrary order
let ordered = uniqueNumbers.mySorted(by: <)
print(ordered) // [1, 2, 5, 8]
```

### 5. String: process characters

```swift
let name = "Swift"
let letters = name.myMap { String($0).uppercased() }
print(letters) // ["S", "W", "I", "F", "T"]
```

## ⏱ Complexity cheat sheet

Let `n` be the number of elements.

| Method | Time | Extra space | Notes |
| :--- | :---: | :---: | :--- |
| `myMap` | O(n) | O(n) | Creates an array |
| `myCompactMap` | O(n) | O(n) | Up to `n` output elements |
| `myFilter` | O(n) | O(n) | Up to `n` output elements |
| `myReduce` | O(n) | O(1)* | Excluding accumulator/closure-owned storage |
| `myForEach` | O(n) | O(1)* | Excluding closure-owned storage |
| `mySorted` | O(n²) worst-case | O(n) | Educational insertion sort |

*Assumes constant-time closure work. Some closures (e.g. string concatenation or copying an array accumulator) may change total time and memory usage.*

## ⚠️ Important differences from standard Swift APIs

- These are **educational implementations**, not drop-in replacements for the standard library.
- Their closures are **non-throwing**; standard library variants support `throws` and `rethrows` as appropriate.
- `myMap`, `myCompactMap`, `myFilter`, and `mySorted` return **arrays** for every sequence. Swift provides specialized collection methods: for example, `Dictionary.filter` returns a dictionary and `Set.filter` returns a set.
- `mySorted` uses **insertion sort** (O(n²) worst case). Prefer Swift's optimized `sorted()` for production code.
- `Dictionary` and `Set` do **not** promise iteration order. Never depend on output ordering unless you explicitly sort.
- Some sequences are single-pass. Avoid assuming the same sequence can be iterated repeatedly.

## 🎯 Interview questions

<details>
<summary><strong>Why extend Sequence instead of Array?</strong></summary>

Because a generic extension on `Sequence` works for many data types that support iteration, not just arrays. It improves reuse and reduces duplicate implementations.
</details>

<details>
<summary><strong>What's the difference between map and compactMap?</strong></summary>

`map` transforms every element, preserving the number of outputs. `compactMap` removes results that are `nil`.
</details>

<details>
<summary><strong>Can reduce return something other than Int?</strong></summary>

Yes! The accumulator can be a string, dictionary, array, or custom type. It is inferred from the initial value and combining closure.
</details>

<details>
<summary><strong>Why use forEach rather than for-in?</strong></summary>

`forEach` works well when passing a closure as a reusable action. A regular `for-in` is better when you need `break`, `continue`, or more flexible control flow.
</details>

<details>
<summary><strong>Why can a custom generic filter differ from Dictionary.filter?</strong></summary>

Our `Sequence` extension returns `[Element]`, so dictionary entries become an array of `(key, value)` tuples. Swift's dictionary-specific `filter` method preserves dictionary structure.
</details>

## 🧪 Try it yourself

- [ ] Rewrite `myMap` using `myReduce`.
- [ ] Implement `myContains(where:)`.
- [ ] Add a `rethrows` version of `myMap`.
- [ ] Write a generic `mySorted()` overload for `Element: Comparable`.
- [ ] Write unit tests for empty arrays, dictionaries, sets, and optional conversions.

---

<div align="center">

**Learn the implementation. Understand the trade-offs. Explain it confidently.**

Made for hands-on Swift learning and iOS technical interview preparation. 🍎

</div>
