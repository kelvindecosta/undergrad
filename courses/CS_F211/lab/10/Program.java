class Node {
    int data, height;
    Node left, right;

    Node(int data) {
        this.data = data;
        height = 1;
    }
}

class AVLTree {

    Node root;

    int height(Node N) {
        if (N == null)
            return 0;

        return N.height;
    }

    int max(int a, int b) {
        return (a > b) ? a : b;
    }

    Node rightRotate(Node y) {
        Node x = y.left;
        Node T2 = x.right;

        x.right = y;
        y.left = T2;

        y.height = max(height(y.left), height(y.right)) + 1;
        x.height = max(height(x.left), height(x.right)) + 1;

        return x;
    }

    Node leftRotate(Node x) {
        Node y = x.right;
        Node T2 = y.left;

        y.left = x;
        x.right = T2;

        x.height = max(height(x.left), height(x.right)) + 1;
        y.height = max(height(y.left), height(y.right)) + 1;

        return y;
    }

    int getBalance(Node N) {
        if (N == null)
            return 0;

        return height(N.left) - height(N.right);
    }

    Node insert(Node node, int data) {
        if (node == null)
            return (new Node(data));

        if (data < node.data)
            node.left = insert(node.left, data);
        else if (data > node.data)
            node.right = insert(node.right, data);
        else
            return node;

        node.height = 1 + max(height(node.left), height(node.right));

        int balance = getBalance(node);

        if (balance > 1 && data < node.left.data)
            return rightRotate(node);

        if (balance < -1 && data > node.right.data)
            return leftRotate(node);

        if (balance > 1 && data > node.left.data) {
            node.left = leftRotate(node.left);
            return rightRotate(node);
        }

        if (balance < -1 && data < node.right.data) {
            node.right = rightRotate(node.right);
            return leftRotate(node);
        }

        return node;
    }

    void print(Node node) {
        if (node != null) {
            System.out.print(node.data + ", ");
            print(node.left);
            print(node.right);
        }
    }
}

class Program {
    public static void main(String[] args) {
        AVLTree tree = new AVLTree();
        int array[] = { 1, 2, 3, 4, 5, 10, 9, 8, 7, 6 };
        for (int i = 0; i < array.length; i++)
            tree.root = tree.insert(tree.root, array[i]);

        System.out.println("Preorder : ");
        tree.print(tree.root);
        System.out.println();
    }
}
