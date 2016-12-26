//
// AVLTreeNode.swift
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

public class AVLTreeNode<T:Comparable> {
    
    //Value and children-parent vars
    public var value:T
    public var leftChild:AVLTreeNode?
    public var rightChild:AVLTreeNode?
    public weak var parent:AVLTreeNode?
    public var balanceFactor:Int = 0
    
    //Initialization
    public convenience init(value: T) {
        self.init(value: value, left: nil, right: nil, parent:nil)
    }
    
    public init(value:T, left:AVLTreeNode?, right:AVLTreeNode?, parent:AVLTreeNode?) {
        self.value = value
        self.leftChild = left
        self.rightChild = right
        self.parent = parent
        self.balanceFactor = 0
    }
    
    //Right
    public func rotateRight()  -> AVLTreeNode {
        guard let parent = parent else {
            return self
        }
        
        // Step 1: Rotation
        // 0.Lets store some temporary references to use them later
        let grandParent = parent.parent
        let newRightChildsLeftChild = self.rightChild
        var wasLeftChild = false
        if parent === grandParent?.leftChild {
            wasLeftChild = true
        }
        
        //1. My new right child is my old parent
        self.rightChild = parent
        self.rightChild?.parent = self
        
        //2. My new parent is my old grandparent
        self.parent = grandParent
        if wasLeftChild {
            grandParent?.leftChild = self
        }else {
            grandParent?.rightChild = self
        }
        
        //3. The left child of my new right child is my old right child
        self.rightChild?.leftChild = newRightChildsLeftChild
        self.rightChild?.leftChild?.parent = self.rightChild
        
        // Step 2: Height update
        if self.balanceFactor == 0 {
            self.balanceFactor = 1
            self.rightChild?.balanceFactor = -1
        } else {
            self.balanceFactor = 0
            self.rightChild?.balanceFactor = 0
        }
        
        return self
    }
    
    //Left
    public func rotateLeft()  -> AVLTreeNode {
        guard let parent = parent else {
            return self
        }
        
        // Step 1: Rotation
        // 0.Lets store some temporary references to use them later
        let grandParent = parent.parent
        let newLeftChildsRightChild = self.leftChild
        var wasLeftChild = false
        if parent === grandParent?.leftChild {
            wasLeftChild = true
        }
        
        //1. My new left child is my old parent
        self.leftChild = parent
        self.leftChild?.parent = self
        
        //2. My new parent is my old grandparent
        self.parent = grandParent
        if wasLeftChild {
            grandParent?.leftChild = self
        }else {
            grandParent?.rightChild = self
        }
        
        //3. The right child of my new left child is my old left child
        self.leftChild?.rightChild = newLeftChildsRightChild
        self.leftChild?.rightChild?.parent = self.leftChild
        
        // Step 2: Height update
        if self.balanceFactor == 0 {
            self.balanceFactor = -1
            self.leftChild?.balanceFactor = 1
        } else {
            self.balanceFactor = 0
            self.leftChild?.balanceFactor = 0
        }
        
        return self
    }
    
    //Right - Left
    public func rotateRightLeft() -> AVLTreeNode {
        
        // 1: Double rotation
        _ = self.rotateRight()
        _ = self.rotateLeft()
        
        // 2: Update Balance Factors
        if (self.balanceFactor > 0) {
            self.leftChild?.balanceFactor = -1;
            self.rightChild?.balanceFactor = 0;
        }
        else if (self.balanceFactor == 0) {
            self.leftChild?.balanceFactor = 0;
            self.rightChild?.balanceFactor = 0;
        }
        else {
            self.leftChild?.balanceFactor = 0;
            self.rightChild?.balanceFactor = 1;
        }
        
        self.balanceFactor = 0;
        
        return self
    }
    
    //Left - Right
    public func rotateLeftRight() -> AVLTreeNode {
        
        // 1: Double rotation
        _ = self.rotateLeft()
        _ = self.rotateRight()
        
        // 2: Update Balance Factors
        if (self.balanceFactor > 0) {
            self.leftChild?.balanceFactor = -1;
            self.rightChild?.balanceFactor = 0;
        }
        else if (self.balanceFactor == 0) {
            self.leftChild?.balanceFactor = 0;
            self.rightChild?.balanceFactor = 0;
        }
        else {
            self.leftChild?.balanceFactor = 0;
            self.rightChild?.balanceFactor = 1;
        }
        
        self.balanceFactor = 0;
        
        return self
    }
    
    // MARK: Helper method to build a initial AVL-tree (not a insertion by retracing)
    
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
                let newNode = AVLTreeNode(value: value)
                newNode.parent = self
                leftChild = newNode
                
            }
        }else {
            // Value is greater than root value: We should insert it in the right subtree
            // Insert it into the right subtree if it exists, if not, create a new node and put it as the right child.
            if let rightChild = rightChild {
                rightChild.addNode(value: value)
            }else {
                let newNode = AVLTreeNode(value: value)
                newNode.parent = self
                rightChild = newNode
            }
        }
    }
    
    // Prints each layer of the tree from top to bottom with the node value and the balance factor
    public static func printTree(nodes:[AVLTreeNode]) {
        var children:[AVLTreeNode] = Array()
        
        for node:AVLTreeNode in nodes {
            print("\(node.value)" + " " + "\(node.balanceFactor)")
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
}
