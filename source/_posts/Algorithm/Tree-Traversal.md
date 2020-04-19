---
title: Tree Traversal
tags:
    - Tree
categories: Algorithm
date: 2017-12-12 13:45:56
---

# Tree traversals
常见的三种树的遍历：pre-order traversal, in-order traversal, post-order traversal.
```
    1
   / \
  2   3
 / \
4   5
```
## Pre-order
for any node, root - left - right
上述的树遍历的结果是：1 2 4 5 3

### Recursive
```java
public static List<Integer> preOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    helper(root, res);
    return res;
}

private static void helper(TreeNode root, List<Integer> res) {
    if (root == null) {
        return;
    }

    res.add(root.val);
    helper(root.left, res);
    helper(root.right, res);
}
```
<!-- more -->

### Iterative
```java
public static List<Integer> preOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    Stack<TreeNode> stack = new Stack<>();
    TreeNode cur = root;

    while (cur != null || !stack.isEmpty()) {
        while (cur != null) {
            res.add(cur.val);
            stack.push(cur);
            cur = cur.left;
        }
        cur = stack.pop().right;
    }
    return res;
}
```

## In-order
for any node, left - root - right
上述的树遍历的结果是：4 2 5 1 3

### Recursive
```java
public static List<Integer> inOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    helper(root, res);
    return res;
}

private static void helper(TreeNode root, List<Integer> res) {
    if (root == null) {
        return;
    }

    helper(root.left, res);
    res.add(root.val);
    helper(root.right, res);
}
```

### Iterative
```java
public static List<Integer> inOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    Stack<TreeNode> stack = new Stack<>();
    TreeNode cur = root;

    while (!stack.isEmpty() || cur != null) {
        while (cur != null) {
            stack.push(cur);
            cur = cur.left;
        }
        res.add(stack.peek().val);
        cur = stack.pop().right;
    }
    return res;
}
```

## Post-order
for any node, left - right - root
上述的树遍历的结果是：4 5 2 3 1

### Recursive
```java
public static List<Integer> postOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    helper(root, res);
    return res;
}

private static void helper(TreeNode root, List<Integer> res) {
    if (root == null) {
        return;
    }

    helper(root.left, res);
    helper(root.right, res);
    res.add(root.val);
}
```

### Iterative (One Stack)
1. Create an empty stack
2. Do following while root is not NULL
    - Push root's right child and then root to stack.
    - Set root as root's left child.
3. Pop an item from stack and set it as root.
    - If the popped item has a right child and the right child is at top of stack, then remove the right child from stack, push the root back and set root as root's right child.
    - Else print root's data and set root as NULL.
4. Repeat steps 2 and 3 while stack is not empty.

```java
public static List<Integer> postOrderTraversal (TreeNode root) {
    List<Integer> res = new ArrayList<>();
    Stack<TreeNode> stack = new Stack<>();
    TreeNode cur = root;

    while (!stack.isEmpty() || cur != null) {
        while (cur != null) {
            if (cur.right != null) {
                stack.push(cur.right);
            }
            stack.push(cur);
            cur = cur.left;
        }
        while (cur == null) {
            TreeNode temp = stack.pop();
            if (stack.isEmpty()) {
                res.add(temp.val);
                break;
            }
            if (temp.right == stack.peek()) {
                stack.pop();
                stack.push(temp);
                cur = temp.right;
            } else {
                res.add(temp.val);
            }
        }
    }
    return res;
}
```
# Level Order Traversal
level order就是一层一层的把数组遍历
```
    1
   / \
  2   3
 / \
4   5
```
上述的树level order traversal就是
`[[1],[2,3],[4,5]]`

## Recursive
```java
public static List<List<Integer>> levelOrderTraversal(TreeNode root) {
    List<List<Integer>> res = new ArrayList<>();
    helper(res, root, 0);
    return res;
}

public static void helper(List<List<Integer>> res, TreeNode cur, int level) {
    if (cur == null) {
        return;
    }

    if (res.size() < level+1) {
        res.add(new ArrayList<Integer>());
    }
    res.get(level).add(cur.val);
    helper(res, cur.left, level+1);
    helper(res, cur.right, level+1);
}
```
