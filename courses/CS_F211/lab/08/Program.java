import java.util.*;

class Node {
    Integer data;
    Node left;
    Node right;
    Node parent;

    public Node(Integer data) {
        this.data = data;
        left = null;
        right = null;
        parent = null;
    }
}

class BinarySearchTree {
    Node root;

    public BinarySearchTree() {
        root = null;
    }

    public void insert(int data) {
        Node newNode = new Node(data);
        if (root == null) {
            root = newNode;
            expandExternal(newNode);
            return;
        }

        Node current = root;
        Node parent = null;
        while (true) {
            parent = current;
            if (data < current.data) {
                current = current.left;
                if (isExternal(current)) {
                    parent.left = newNode;
                    newNode.parent = parent;
                    expandExternal(newNode);
                    return;
                }
            } else {
                current = current.right;
                if (isExternal(current)) {
                    parent.right = newNode;
                    newNode.parent = parent;
                    expandExternal(newNode);
                    return;
                }
            }
        }
    }

    public boolean find(int data) {
        Node current = root;
        while (isInternal(current)) {
            if (current.data == data)
                return true;
            else if (data > current.data)
                current = current.right;
            else
                current = current.left;
        }
        return false;
    }

    public Integer size(Node v) {
        if (isExternal(v))
            return 0;
        else
            return size(v.left) + 1 + size(v.right);
    }

    public Node getNode(int data) {
        Node current = root;
        while (isInternal(current)) {
            if (current.data == data)
                return current;
            else if (data > current.data)
                current = current.right;
            else
                current = current.left;
        }
        return null;
    }

    public Integer delete(int data) {
        Node temp;
        if (find(data))
            temp = getNode(data);
        else {
            System.out.println("Key not in tree!");
            return null;
        }

        if (isInternal(temp.left) && isInternal(temp.right)) {
            Node succ = inorderSuccessor(temp);
            temp.data = succ.data;
            removeAboveExternal(succ.left);
        } else if (isInternal(temp.left) || isInternal(temp.right)) {
            if (isRoot(temp)) {
                Node succ = inorderSuccessor(temp);
                temp.data = succ.data;
                removeAboveExternal(succ.left);
            } else if (isExternal(temp.left))
                removeAboveExternal(temp.left);
            else
                removeAboveExternal(temp.right);
        } else {
            if (isRoot(temp)) {
                root = null;
            } else {
                temp.data = null;
                temp.right = null;
                temp.left = null;
            }
        }
        return data;
    }

    public Integer removeAboveExternal(Node x) {
        if (!isExternal(x))
            return null;

        Node gp = x.parent.parent;
        Node sib = sibling(x);
        int data = x.parent.data;

        if (x.parent == gp.left) {
            if (sib == null) {
                gp.left.data = null;
                gp.left.right = null;
                gp.left.left = null;
            } else {
                gp.left = sib;
                sib.parent = gp;
            }
        } else {
            if (sib == null) {
                gp.right.data = null;
                gp.right.right = null;
                gp.right.left = null;
            } else {
                gp.right = sib;
                sib.parent = gp;
            }
        }

        return data;
    }

    public void expandExternal(Node v) {
        if (!isExternal(v))
            return;

        v.left = new Node(null);
        v.left.parent = v;
        v.right = new Node(null);
        v.right.parent = v;
    }

    public void inorder(Node v) {
        Node current = v;
        if (isInternal(v.left))
            inorder(leftChild(v));
        System.out.print(v.data + ", ");

        if (isInternal(v.right))
            inorder(rightChild(v));
    }

    public void preorder(Node v) {
        Node current = v;
        System.out.print(v.data + ", ");
        if (isInternal(v.left))
            preorder(leftChild(v));

        if (isInternal(v.right))
            preorder(rightChild(v));
    }

    public void postorder(Node v) {
        Node current = v;

        if (isInternal(v.left))
            postorder(leftChild(v));

        if (isInternal(v.right))
            postorder(rightChild(v));

        System.out.print(v.data + ", ");
    }

    public Node inorderSuccessor(Node v) {
        if (!isInternal(v))
            return null;

        if (!isInternal(v.right))
            return null;

        Node current = rightChild(v);
        while (current != null) {
            if (isInternal(current.left)) {
                Node successor = leftChild(current);
                while (successor != null) {
                    if (isInternal(successor.left))
                        successor = leftChild(successor);
                    else
                        return successor;
                }
            } else
                return current;
            current = rightChild(current);
        }
        return null;
    }

    public Node leftChild(Node v) {
        if (isInternal(v.left))
            return v.left;
        else
            return null;
    }

    public Node rightChild(Node v) {
        if (isInternal(v.right))
            return v.right;
        else
            return null;
    }

    public Node sibling(Node v) {
        if (isRoot(v)) {
            System.out.println("Root has no sibling!");
            return null;
        }
        Node p = v.parent;
        if (p.left == v)
            return rightChild(p);
        else
            return leftChild(p);
    }

    public boolean isInternal(Node v) {
        return v.left != null || v.right != null;
    }

    public boolean isExternal(Node v) {
        return !(isInternal(v));
    }

    public boolean isRoot(Node v) {
        return v.parent == null;
    }
}

class Program {
    public static void main(String args[]) {
        BinarySearchTree tree = new BinarySearchTree();
        tree.insert(3);
        tree.insert(2);
        tree.insert(4);
        tree.insert(1);
        tree.insert(5);

        tree.inorder(tree.root);
        System.out.println();

        tree.delete(2);
        tree.inorder(tree.root);
        System.out.println();

        tree.delete(3);
        tree.inorder(tree.root);
        System.out.println();
        tree.delete(1);
        tree.inorder(tree.root);
        System.out.println();
        tree.delete(4);
        tree.inorder(tree.root);
        System.out.println();
        tree.delete(5);

    }
}
