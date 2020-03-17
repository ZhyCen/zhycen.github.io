---
title: Google On-site Interview
tags: 
    - Interview
    - Google
categories: Interview
---

# [面经1](http://www.1point3acres.com/bbs/thread-366144-1-1.html)
## Sentence Similarity I,II
[LeetCode](https://leetcode.com/problems/sentence-similarity/description/)

```java
class Solution {
    public boolean areSentencesSimilarTwo(String[] words1, String[] words2, String[][] pairs) {
        Map<String, String> map = new HashMap<>();
        if (words1.length != words2.length) {
            return false;
        }
        
        for (String[] pair : pairs) {
            union(pair[0], pair[1], map);
        }
        
        int len = words1.length;
        for (int i = 0; i < len; i++) {
            if (!find(words1[i], map).equals(find(words2[i], map))) {
                return false;
            }
        }
        return true;
    }
    
    private void union(String s1, String s2, Map<String, String> map) {
        String s1Root = find(s1, map);
        String s2Root = find(s2, map);
        map.put(s1Root, s2Root);
    }
    
    private String find(String s, Map<String, String> map) {
        if (!map.containsKey(s) || map.get(s).equals(s)) {
            return s;
        }
        String root = find(map.get(s), map);
        map.put(s, root);
        return root; 
    }
}
```
## String Match
// TODO KMP 
## Max Difference in Binary Tree
```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
}

class Solution {
    public int calMaxDiff(TreeNode root) {
        return helper(root)[0];
    }

    private int[] helper(TreeNode root) {
        int[] res = new int[2]{0, Integer.MIN_VALUE};
        if (root == null) {
            return res;
        }
    }
}
```

# 面经II