/*:
 # Chapter 6
 ## Advanced Searching methods
 */

//: ## Demonstrate use of different String search methods.
//:
//: ### Find the StringSearch implementation in the Sources/StringSearch.swift file located within this project.

//: Brute force search
StringSearch.bruteForce(search: ["3","4"], in: ["1","2","3","4","5","6"])

//: RabinKarp search
let text = "2359023141526739921"
let pattern = "31415"
let modulo = 13
let base = 10
StringSearch.rabinKarpNumbers(search: pattern, in: text, modulo: modulo, base: base)

/*:
 
 The license for this document is available [here](License).
 */
