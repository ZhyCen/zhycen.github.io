---
title: Graph Representation
date: 2018-03-18 15:21:48
tags: 
    - Graph
categories: Algorithm
---

# 图的表示
LeetCode上给出了一个[链接](https://www.khanacademy.org/computing/computer-science/algorithms/graph-representation/a/representing-graphs), 可以参考一下. 这里讲两个最常见的表示方法, Adjacency Matrices和Adjacency Lists.

## Adjacency Matrices
Adjacency Matrices用一个二维矩阵`A[][]`表示, 在无向图中, `A[i][j] = -1`表示节点i和j之间无edge, `A[i][j] = 1`表示有边, 无向图中矩阵是对称的. 在有向图中, `A[i][j] = 1`表示从i到j存在有向边. 在weighted edge list中, `A[i][j] = k`用具体的数字表示从i到j的边的权重.

<!-- more -->


```java
class Graph {
    int[][] matrix;
}
```

For Example
```
1 --> 2 --> 3
|     |     |
|     v     v
+ --> 4 --> 5
```
可以表示成
```
   1  2  3  4  5
 +--------------
1| *  1  *  1  *
2| *  *  1  1  *
3| *  *  *  *  1
4| *  *  *  *  1
5| *  *  *  *  *

```

优点: 
- 查询是否存在边O(1)
- 增删边O(1)

缺点:
- space consuming, O(V^2)
- 增加节点需要O(V)

## Adjacency Lists
Adjacency Lists用一个数据结构储存每一个点的标识以及和该点相邻的节点的list. 对于不同的情况比较灵活. 

优点:
- 省空间
- 增加节点只需要O(1)

缺点: 
- 查询是否存在边O(V)

例如还是上一个例子
```
0 --> 1 --> 2
|     |     |
|     v     v
+ --> 3 --> 4
```
可以用一个数组来表示
```
[
    [1,3],
    [2,3],
    [4],
    [4],
    []
]
```

这里用一个比较general的类来表示.
```java
class Graph {
    List<Node> nodeSet;
}

class Node {
    int value;
    List<Integer> neighbors;
}
```

对于有权重边的图来说, 用matrix会简单的很多.



