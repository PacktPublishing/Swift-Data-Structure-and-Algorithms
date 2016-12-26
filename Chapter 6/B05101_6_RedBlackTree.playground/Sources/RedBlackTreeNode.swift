//
// RedBlackTreeNode.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Erik J. Azar & Mario Eguiluz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//Enumeration to model the possible colors of a node
public enum RedBlackTreeColor : Int {
    case red = 0
    case black = 1
}

public class RedBlackTreeNode<T:Comparable> {
    //Value and children-parent vars
    public var value:T
    public var leftChild:RedBlackTreeNode?
    public var rightChild:RedBlackTreeNode?
    public weak var parent:RedBlackTreeNode?
    //Color var
    public var color:RedBlackTreeColor
    
    //Initialization
    public convenience init(value: T) {
        self.init(value: value, left: nil, right: nil, parent:nil, color: RedBlackTreeColor.black)
    }
    
    public init(value:T, left:RedBlackTreeNode?, right:RedBlackTreeNode?, parent:RedBlackTreeNode?, color:RedBlackTreeColor) {
        self.value = value
        self.color = color
        self.leftChild = left
        self.rightChild = right
        self.parent = parent
    }
    
    //MARK: Helper methods
    
    //Returns the grandparent of the node, or nil
    public func grandParentNode() -> RedBlackTreeNode? {
        guard let grandParentNode = self.parent?.parent else {
            return nil
        }
        return grandParentNode
    }
    
    //Returns the "uncle" of the node, or nil if doesn't exist. This is the sibling of its parent node
    public func uncleNode() -> RedBlackTreeNode? {
        guard let grandParent = self.grandParentNode() else {
            return nil
        }
        
        if parent === grandParent.leftChild {
            return grandParent.rightChild
        }else {
            return grandParent.leftChild
        }
    }
    
    // Prints each layer of the tree from top to bottom with the node value and the color
    public static func printTree(nodes:[RedBlackTreeNode]) {
        var children:[RedBlackTreeNode] = Array()
        
        for node:RedBlackTreeNode in nodes {
            print("\(node.value)" + " " + "\(node.color)")
            if let leftChild = node.leftChild {
                children.append(leftChild)
            }
            if let rightChild = node.rightChild {
                children.append(rightChild)
            }
        }
        
        if children.count > 0 {
            printTree(nodes: children)
        }
    }
    
    //MARK: Rotations
    
    //Right
    public func rotateRight() {
        guard let parent = parent else {
            return
        }
        
        //1.Lets store some temporary references to use them later
        let grandParent = parent.parent
        let newRightChildsLeftChild = self.rightChild
        var wasLeftChild = false
        if parent === grandParent?.leftChild {
            wasLeftChild = true
        }
        
        //2. My new right child is my old parent
        self.rightChild = parent
        self.rightChild?.parent = self
        
        //3. My new parent is my old grandparent
        self.parent = grandParent
        if wasLeftChild {
            grandParent?.leftChild = self
        }else {
            grandParent?.rightChild = self
        }
        
        //4. The left child of my new right child is my old right child
        self.rightChild?.leftChild = newRightChildsLeftChild
        self.rightChild?.leftChild?.parent = self.rightChild
    }
    
    //Left
    public func rotateLeft() {
        guard let parent = parent else {
            return
        }
        
        //1.Lets store some temporary references to use them later
        let grandParent = parent.parent
        let newLeftChildsRightChild = self.leftChild
        var wasLeftChild = false
        if parent === grandParent?.leftChild {
            wasLeftChild = true
        }
        
        //2. My new left child is my old parent
        self.leftChild = parent
        self.leftChild?.parent = self
        
        //3. My new parent is my old grandparent
        self.parent = grandParent
        if wasLeftChild {
            grandParent?.leftChild = self
        }else {
            grandParent?.rightChild = self
        }
        
        //4. The right child of my new left child is my old left child
        self.leftChild?.rightChild = newLeftChildsRightChild
        self.leftChild?.rightChild?.parent = self.leftChild
    }
    
    // MARK: Insertion
    
    //Insert operation methods
    public func insertNodeFromRoot(value:T) {
        //To mantain the binary search tree property, we must ensure that we run the insertNode process from the root node
        if let _ = self.parent {
            // If parent exists, it is not the root node of the tree
            print("You can only add new nodes from the root node of the tree");
            return
        }
        
        self.addNode(value: value)
    }
    
    private func addNode(value:T) {
        if value < self.value {
            // Value is less than root value: We should insert it in the left subtree.
            // Insert it into the left subtree if it exists, if not, create a new node and put it as the left child.
            if let leftChild = leftChild {
                leftChild.addNode(value: value)
            }else {
                let newNode = RedBlackTreeNode(value: value)
                newNode.parent = self
                newNode.color = RedBlackTreeColor.red
                leftChild = newNode
                
                //Review tree color structure
                insertionReviewStep1 (node: newNode)
            }
        }else {
            // Value is greater than root value: We should insert it in the right subtree
            // Insert it into the right subtree if it exists, if not, create a new node and put it as the right child.
            if let rightChild = rightChild {
                rightChild.addNode(value: value)
            }else {
                let newNode = RedBlackTreeNode(value: value)
                newNode.parent = self
                newNode.color = RedBlackTreeColor.red
                rightChild = newNode
                
                //Review tree color structure
                insertionReviewStep1(node: newNode)
            }
        }
    }
    
    // 1. Root must be black
    private func insertionReviewStep1(node:RedBlackTreeNode) {
        if let _ = node.parent {
            insertionReviewStep2(node: node)
        } else {
            node.color = .black
        }
    }

    // 2. Parent is black?
    private func insertionReviewStep2(node:RedBlackTreeNode) {
        if node.parent?.color == .black {
            return
        }
        
        insertionReviewStep3(node: node)
    }

    // 3. Parent and uncle are red?
    private func insertionReviewStep3(node:RedBlackTreeNode) {
        if let uncle = node.uncleNode() {
            if uncle.color == .red {
                node.parent?.color = .black
                uncle.color = .black
                if let grandParent = node.grandParentNode() {
                    grandParent.color = .red
                    insertionReviewStep1(node: grandParent)
                }
                return
            }
        }
        
        insertionReviewStep4(node: node)
    }

    // 4. Parent is red, uncle is black. Node is left child of a right child or right child of a left child
    private func insertionReviewStep4(node:RedBlackTreeNode) {
        var node = node
        guard let grandParent = node.grandParentNode() else {
            return
        }
        
        if node === node.parent?.rightChild && node.parent === grandParent.leftChild {
            node.parent?.rotateLeft()
            node = node.leftChild!
        } else if node === node.parent?.leftChild && node.parent === grandParent.rightChild {
            node.parent?.rotateRight()
            node = node.rightChild!
        }
        insertionReviewStep5(node: node)
    }

    // 5. Parent is red, uncle is black. Node is left child of a left child or it is right child of a right child
    private func insertionReviewStep5(node:RedBlackTreeNode) {
        guard let grandParent = node.grandParentNode() else {
            return
        }
        node.parent?.color = .black
        grandParent.color = .red
        if node === node.parent?.leftChild {
            grandParent.rotateRight()
        }else {
            grandParent.rotateLeft()
        }
    }
    
}


