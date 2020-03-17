---
title: Segment Tree
date: 2018-03-23 22:52:56
tags: 
    - Tree
    - Segment Tree
categories: Data Structure
---

# Segment Tree
线段树是一棵二叉树, 树中的每一个非叶子结点表示了一个区间[a,b].  
该节点的左儿子表示区间[a,(a+b)/2], 右儿子表示[(a+b)/2+1,b].

## Feature 
- 是一个满二叉树(Full Binary Tree), 及每个节点的子节点个数为0或2.
- 是一个平衡树, 深度不超过log(L), L是区间长度
- 非叶子节点长度>1, 叶子节点长度=1

## Application
线段树主要用于高效解决连续区间的动态查询问题. 比如某些数据可以按区间进行划分, 按区间动态进行修改, 而且还需要按区间多次进行查询, 那么使用线段树可以达到较快查询速度. 

例如
- 对区间求sum
- 对区间求Max/Min
- 对区间求Count

<!-- more -->

## Build Segment Tree
这个是Segment Tree的基本结构
```java
public class SegNode {
    int lo;
    int hi;
    int val; // val根据不同情况不同
    SegNode left;
    SegNode right;

    public SegNode(int lo, int hi, int val) {
        this.lo = lo;
        this.hi = hi;
        this.val = val;
    }
}
```
下面是给定一个数组, 为了找区间**最小值**, 建立一个相应的Segment Tree, recursively
```java
public SegNode buildTree(int[] arr) {
    return buildHelper(arr, 0, arr.length - 1);
}

public SegNode buildHelper(int[] arr, int lo, int hi) {
    if (lo > hi) {
            return null;
        }
        if (lo == hi) {
            return new SegNode(lo, hi, arr[lo]);
        }
        int mid = lo + (hi - lo) / 2;
        SegNode left = buildHelper(arr, lo, mid);
        SegNode right = buildHelper(arr, mid + 1, hi);
        SegNode root = new SegNode(lo, hi, Math.min(left.val, right.val));
        root.left = left;
        root.right = right;

        return root;
}
```
```
index: 0 1 2 3 4 5 6  
array: 2 7 4 3 6 5 1
```

转化成segment tree, 建树时间复杂度**O(N)**
<img src = "/images/segtree.jpg" width = "50%">        

## Search in Segment Tree
线段树的查询时间为O(log(N)), 核心在于查找区间的并集. 

以RMQ为例, 需要动态查询区间的最小值. 用recursive function来求解.  
每一层搜索节点的时候比较当前节点代表的区间和目标区间的交集情况.
- 如果当前节点区间和目标区间不想交, 则不在查询范围内, 返回最大值Integer.MAX_VALUE;
- 如果当前节点区间和目标区间相交或者当前节点完整包含目标区间, 则递归到下一层, 返回下一层的小值
- 如果目标区间完整包含当前节点区间, 则在查询的范围之内, 返回节点值.

```java
public int RMQ(SNode root, int a, int b) {
    if (root == null || a >root.hi || b < root.lo) {
        return Integer.MAX_VALUE;
    }

    if (a <= root.lo && b >= root.hi) {
        return root.val;
    }

    int left = RMQ(root.left, a, b);
    int right = RMQ(root.right, a, b);

    return Math.min(left, right);
}
```

## Update in Segment Tree

### Update Value
单个节点更新比较简单, 只需要递归地比较并更改点所在区间的值即可. O(log(N)).

```java
public void update(SegNode root, int index, int val) {
        if (root.lo > val || root.hi < val) {
            return;
        }
        root.val = Math.min(root.val, val);
        update(root.left, index, val);
        update(root.right, index, val);
    }
```

### Update Range
区间更新待更新

# Segment Array Tree
更好的办法是用array来储存区间树的信息. 有两种操作, 一种是严格地按照上述Segment Tree的定义, 将树的结构转化成Array. 


















