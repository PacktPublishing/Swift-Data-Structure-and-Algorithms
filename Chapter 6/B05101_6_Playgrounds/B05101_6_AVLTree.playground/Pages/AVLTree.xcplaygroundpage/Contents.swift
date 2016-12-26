/*:
 # Chapter 6
 ## Advanced Search methods
 */

//: ## Demonstrate use of the AVL tree type.
//:
//: ### Find the AVLTreeNode implementation in the Sources/AVLTreeNode.swift file located within this project.

//: Create a nonbalanced AVLTree
var avlRootNode = AVLTreeNode.init(value: 100)
avlRootNode.insertNodeFromRoot(value: 50)
avlRootNode.insertNodeFromRoot(value: 200)
avlRootNode.insertNodeFromRoot(value: 150)
avlRootNode.insertNodeFromRoot(value: 125)
avlRootNode.insertNodeFromRoot(value: 250)

avlRootNode.balanceFactor = 2
avlRootNode.rightChild?.balanceFactor = -1
avlRootNode.rightChild?.rightChild?.balanceFactor = 0
avlRootNode.rightChild?.leftChild?.balanceFactor = -1
avlRootNode.rightChild?.leftChild?.leftChild?.balanceFactor = 0
avlRootNode.leftChild?.balanceFactor = 0

print("Invalid AVL tree")
AVLTreeNode.printTree(nodes: [avlRootNode])

//: Perform rotations to fix it
if let newRoot = avlRootNode.rightChild?.leftChild?.rotateRightLeft() {
    avlRootNode = newRoot
}

//: Print each layer of the tree
print("Valid AVL tree")
AVLTreeNode.printTree(nodes: [avlRootNode])

/*:
 
 The license for this document is available [here](License).
 */
