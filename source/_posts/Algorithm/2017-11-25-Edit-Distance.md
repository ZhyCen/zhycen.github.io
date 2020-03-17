---
title: Edit Distance and Levenshtein Algorithm
date: 2017-11-25 21:51:37
tags:
    - Dynamic Programming
    - String
categories: Algorithm
---

刚好复习考试的时候出现了Edit Distance这个概念而这个概念又比较重要，在面试和应用中都有一席之地。因此抽出了一点时间总结一些这个算法。

编辑距离（Edit Distance），又称Levenshtein距离，是指两个字串之间，由一个转成另一个所需的最少编辑操作次数，如果它们的距离越大，说明它们越不同。这些操作包括
- 插入一个字符，例如：fj -> fxj
- 删除一个字符，例如：fxj -> fj
- 替换一个字符，例如：jxj -> fyj

算法的应用很广泛，例如用于DNA序列检查，字符的拼写和纠正，抄袭的侦测等等。

<!-- more -->

<hr>

```
// Given a string s1 and s2, with length l1 and l2.
// We define D(i,j) as the edit distance between l1.substring(0,i+1) and l2.substring(0,j+1）
// the edit distance between s1 and s2 is D(l1-1,l2-1).

// Relations between states

    // for deletion
    // D(i,j) = D(i-1,j) + 1;

    // for insertion
    // D(i,j) = D(i,j-1) + 1;

    // for substitution
    // D(i,j) = D(i-1,j-1) + s1.charAt(i) == s2.charAt(j) ? 0 : 2;

// Base case

    // D(0,j) = j;
    // D(i,0) = i;
    // D(0,0) = 0;

```

```java
public int editDistance (String s1, String s2) {

    int[][] dist = new int[s1.length()][s2.length()];

    for (int i = 0; i < dist.length; i++) {
        for (int j = 0; j < dist[0].length; j++) {
            if (i == 0) {
                dist[i][j] = j;
            } else if (j == 0) {
                dist[i][j] = i;
            } else {
                int temp = s1.charAt(i) == s2.charAt(j) ? 0 : 2;
                dist[i][j] = Math.min(dist[i-1][j]+1, Math.min(dist[i][j-1]+1, dist[i-1][j-1]+temp));
            }
        }
    }

    return dist[s1.length()-1][s2.length()-1];
}
```

Time Complexity: O(l1*l2)

Space Complexity: O(l1*l2)

Backtrace: O(l1+l2)
