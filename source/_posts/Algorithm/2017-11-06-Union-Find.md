---
title: "Union Find"
date: 2017-11-6
tags:
    - Union Find
categories: Algorithm
---


# Union Find

Typically, Union-find use `Tree` data structure and provide two methods,
- `Union`: combine two sets into one
- `Find`: Determine which data set that an element belongs to.

<!-- more -->

## Abstractions

```
Objects
0 1 2 3 4 5 6 7 8 9
```

```
Disjoint sets of objects
0 1 { 2 3 9 } { 5 6 } 7 { 4 8 }
```

```
Find query: are objects 2 and 9 in the same set?
0 1 { 2 3 9 } { 5 6 } 7 { 4 8 }
```

```
Union command: merge sets containing 3 and 8.
0 1 { 2 3 4 8 9 } { 5 6 } 7
```

## Example in life: Friend Circle

Imaging that we have n students in school. At the beginning, they don't know each other.

When the time goes by, circle of friends start to form and grow. If a and b are friends, b and c are friend, then we say that a and c becomes indirect friends, and a, b, c are in the same friend circle.

We can use `Union` function to establish connections between two students, and use `find` function to determine if `student i` and `student j` are in the same friend circle.

## Basic Idea

we can use `Tree` data structure to store the root (group ID) information of a
node. In the above example, each student is in a group of themselves at the beginning.

```
id[i] is parent of i

i       0 1 2 3 4 5 6 7 8 9
id[i]   0 1 9 9 9 6 6 7 8 9
```

we define an array `group[]`, each value denote as group ID. (Obviously, at the beginning, group ID are index of themselves)
```java
int[] group = new int[n];
for(int i = 0; i < size; i++) {
    group[i] = i;
}
```

## Union
`Union(x,y)`

The idea of union is that, we unite their root. (which means that, we find roots of `x` and `y` respectively, and let one root point to another root)

```
Union(2,9);
Union(4,9);
Union(3,4);
Union(5,6);

id[i] is parent of i, and we have

i       0 1 2 3 4 5 6 7 8 9
id[i]   0 1 9 4 9 6 6 7 8 9
```

```java
public void unite(int e, int g) {
    int c = root(e);
    int f = root(g);
    id[c] = f;
}
```

## Find
`Find(x,y)`

the function is quite simple, just check if they have the same root (ID).
```java
public boolean find(int p, int q) {
    return root(p) == root(q);
}
```

### Find Root
How do we know that the value is the Group ID?

When `root(i) == i`, we are sure that id(i) is the root and i is the group ID.

```java
public int root(int i) {
    while (id(i) != i) {
        i = id(i);
    }
    return i;
}
```
## Problem

We've known that we use `tree` to store the parent information so that we can traverse and find the root.

but if the tree is very deep, it may take long time to operate `root` function.

The worst case for finding root (group ID) is **O(N)**
```
i       0 1 2 3 4 5 6 7 8 9
id[i]   1 2 3 4 5 6 7 9 9 9
```

## Improvement
To avoid this problem, one possible solution is `Path Compression`

Just after computing the root of i, set the id of each examined node to root(i).

```java
public int root(int i) {
    while (i != id[i]) {
        id[i] = id[id[i]];
        i = id[i];
    }
    return i;
}
```

## Sample Question: Friend Circle

There are `N` students in a class. Some of them are friends, while some are not. Their friendship is transitive in nature. For example, if A is a direct friend of B, and B is a direct friend of C, then A is an indirect friend of C. And we defined a friend circle is a group of students who are direct or indirect friends.

Given a `N*N` matrix `M` representing the friend relationship between students in the class. If `M[i][j] = 1`, then the `ith` and `jth` students are direct friends with each other, otherwise not. And you have to output the total number of friend circles among all the students.

Example 1:
```
Input:
[[1,1,0],
 [1,1,0],
 [0,0,1]]
```
Output: 2

**Explanation**:The 0th and 1st students are direct friends, so they are in a friend circle.
The 2nd student himself is in a friend circle. So return 2.

Example 2:
```
Input:
[[1,1,0],
 [1,1,1],
 [0,1,1]]
```

Output: 1

**Explanation**:The 0th and 1st students are direct friends, the 1st and 2nd students are direct friends,
so the 0th and 2nd students are indirect friends. All of them are in the same friend circle, so return 1.

```java
public class Solution {
    class UnionFind {
        private int count = 0;
        private int[] parent, rank;

        public UnionFind(int n) {
            count = n;
            parent = new int[n];
            rank = new int[n];
            for (int i = 0; i < n; i++) {
                parent[i] = i;
            }
        }

        public int find(int p) {
        	while (p != parent[p]) {
                parent[p] = parent[parent[p]];    // path compression by halving
                p = parent[p];
            }
            return p;
        }

        public void union(int p, int q) {
            int rootP = find(p);
            int rootQ = find(q);
            if (rootP == rootQ) return;
            if (rank[rootQ] > rank[rootP]) {
                parent[rootP] = rootQ;
            }
            else {
                parent[rootQ] = rootP;
                if (rank[rootP] == rank[rootQ]) {
                    rank[rootP]++;
                }
            }
            count--;
        }

        public int count() {
            return count;
        }
    }

    public int findCircleNum(int[][] M) {
        int n = M.length;
        UnionFind uf = new UnionFind(n);
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                if (M[i][j] == 1) uf.union(i, j);
            }
        }
        return uf.count();
    }
}
```

Reference [Algorithm-Union-Find](https://www.cs.princeton.edu/~rs/AlgsDS07/01UnionFind.pdf)
