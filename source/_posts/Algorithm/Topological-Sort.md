---
title: Topological Sort
date: 2018-03-19 21:03:51
tags: 
    - Graph
    - Topological Sort
categories: Algorithm
---

# Topological sort
定义: 对一个有向无环图(DAG)G进行拓扑排序, 是将G中所有顶点排成一个线性序列, 使得图中任意一对顶点u和v, 若边(u,v)∈E(G), 则u在线性序列中出现在v之前.


## DFS Solution
用dfs的搜索的方法, 维护一个linkedlist和visited set, 保证每次加入到list中时, 可访问的节点都已经在list中.

<!-- more -->

``` java
class Node {
    List<Node> neighbors;
    int val;
}

class Graph {
    List<Nodes> nodes;
}

class Solution {
    public List<Node> topoSearch (Graph graph) {
        LinkedList<Node> list = new LinkedList<>();
        Set<Node> visited = new HashSet<>();
        for (Node node : graph.nodes) {
            dfs(node, visited, list);
        }
        return list;
    }

    private void dfs(Node node, Set<Node> visited, List<Node> list) {
        if (visited.contains(node)) {
            return;
        }
        for (Node neighbor : node.neighbors) {
            dfs(neighbor, visited, list);
        }
        visited.add(node);
        list.addlast(node);
    }
}
```

## BFS Solution
BFS 的方法参考Kahn Algorithm, 意图在于维护一个入度为0的list, 迭代更新.
```java
class Node {
    List<Node> neighbors;
    int val;
}

class Graph {
    List<Nodes> nodes;
}

class Solution {
    public List<Node> topoSearch (Graph graph) {
        List<Node> list = new ArrayList<>();
        Map<Node, Integer> map = new HashMap<>();

        for (Node node: graph.nodes) {
            map.putIfAbsent(n, 0);
            for (Node neighbor : node.neighbors) {
                map.put(neighbor, map.getOrDefault(neighbor, 0) + 1);
            }
        }

        Deque<Node> dq = new ArrayDeque<>();
        for (Node key : map.keySet()) {
            if (map.get(key) == 0) {
                dq.offer(key);
            }
        }

        while (!dq.isEmpty()) {
            Node node = dq.pollFirst();
            list.add(node);
            for (Node neighbor : node.neighbors) {
                int degree = map.get(neighbor);
                map.put(neighbor, degree - 1);
                if (degree == 1) {
                    dq.offer(neighbor);
                }
            }
        }

        return list;

    }
}
```

# Cycle Detection

## DFS
上述两个方法同样可以用来检测有向图中的环, dfs需要维护的不是t/f的set, 而是三色的map, 白色表示未访问, 灰色表示正在访问, 黑色表示已经访问. dfs搜索的时候, 如果搜索到白色的节点则标灰色并继续搜索, 如果节点为黑色则回溯, 如果灰色则表示有环.

```java
class Node {
    List<Node> neighbors;
    int val;
}

class Graph {
    List<Nodes> nodes;
}

class Solution {
    public List<Node> topoSearch (Graph graph) {
        LinkedList<Node> list = new LinkedList<>();
        Map<Node, Integer> map = new HashMap<>();
        // 0 - unvisited; 
        // 1 - visiting; 
        // 2 - visited
        for (Node node : graph.nodes) {
            map.put(node, 0);
        }

        for (Node node : graph.nodes) {
            if (!dfs(node, map, list)) {
                return null;
            }
        }
        return list;
    }

    private boolean dfs(Node node, Set<Node> map, List<Node> list) {
        if (map.get(node) == 2) {
            return true;
        }

        if (map.get(node) == 1) {
            return false;
        }

        map.put(node, 1);
        for (Node neighbor : node.neighbors) {
            if (!dfs(neighbor, map, list)) {
                return false;
            }
        }
        map.put(node, 2);
        list.addlast(node);
        return true;
    }
}
```

## BFS
BFS的算法相对简单, 如果当出度为0的节点全部遍历完之后, 如果还存在edge, 则必定存在环. 这里用Adjacency Lists的数组形式储存节点的信息. (要知道图的几种表示方法)

```java
class Graph {
    int[][] adjacents;
}

class Solution {
    public List<Integer> topoSearch (Graph graph) {
        int len = graph.length;
        int[] degrees = new int[len];
        int edgeCount = 0;

        for (int i = 0; i < len; i++) {
            for (int node : graph.adjacents) {
                degrees[node]++;
                edgeCount++;
            }
        }
        
        Queue<Integer> q = new LinkedList<>();
        for (int i = 0; i < len; i++) {
            if (degrees[i] == 0) {
                q.offer(i);
            }
        }        

        List<Integer> list = new ArrayList<>();
        while (!q.isEmpty()) {
            int node = q.poll();
            list.add(node);
            for (int neighbor : graph.adjacents[node]) {
                degree[neighbor]--;
                edgeCount--;
                if (degree[neighbor] == 0) {
                    q.offer(neighbor);
                }
            }
        }

        if (edgeCount > 0) {
            return null;
        }

        return list;
    }
}
```
