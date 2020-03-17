---
title: Java Exception
date: 2017-11-17 12:11:24
tags:
    - Java
    - Exception
categories: Java
---

Here is the basic idea to custom an Exception in Java.

<!-- more -->

```java
class Main {
    public static void main(String[] args) {
        TreeNode test = new TreeNode(1);
        try {
            System.out.println(printNodeValue(null));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static int printNodeValue(TreeNode p) throws solutionException {
        if (p == null) {
            throw new solutionException("null treenode p");
        } else {
            return p.val;
        }
    }
}

class solutionException extends Exception {
    solutionException(String s) {
        super(s);
    }
}

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode (int x) {
        val = x;
    }
}
```
