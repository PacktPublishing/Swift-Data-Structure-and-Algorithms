/*:
 # Chapter 6
 ## Advanced Search methods
 */

//: ## Demonstrate use of the Red-Black tree type.
//:
//: ### Find the RedBlackTreeNode implementation in the Sources/RedBlackTreeNode.swift file located within this project.

//: Create the root node
let rootNode = RedBlackTreeNode.init(value: 10)

//: Insert nodes in the proper place
rootNode.insertNodeFromRoot(value: 12)
rootNode.insertNodeFromRoot(value: 5)
rootNode.insertNodeFromRoot(value: 3)
rootNode.insertNodeFromRoot(value: 8)
rootNode.insertNodeFromRoot(value: 30)
rootNode.insertNodeFromRoot(value: 11)
rootNode.insertNodeFromRoot(value: 32)
rootNode.insertNodeFromRoot(value: 4)
rootNode.insertNodeFromRoot(value: 2)

//: Print the tree
RedBlackTreeNode.printTree(nodes: [rootNode])

/*:
 
 The license for this document is available [here](License).
 */
