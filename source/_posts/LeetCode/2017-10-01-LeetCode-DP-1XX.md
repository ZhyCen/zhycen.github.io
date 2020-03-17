---
title: "LeetCode DP (100-200)"
date: 2017-10-01
tags: DP
categories: LeetCode
---

# 121. Best Time to Buy and Sell Stock
`easy`

Say you have an array for which the `ith` element is the price of a given stock on day i.

If you were only permitted to complete at most one transaction (ie, buy one and sell one share of the stock), design an algorithm to find the maximum profit.

Example 1:
```
Input: [7, 1, 5, 3, 6, 4]
Output: 5
```

max. difference = 6-1 = 5 (not 7-1 = 6, as selling price needs to be larger than buying price)

Example 2:
```
Input: [7, 6, 4, 3, 1]
Output: 0
```

In this case, no transaction is done, i.e. max profit = 0.

<!-- more -->

```java

class Solution {
    public int maxProfit(int[] prices) {

        if (prices.length <= 1) {
            return 0;
        }

        int[] diff = new int[prices.length - 1];
        for (int i = 0; i < diff.length; i++) {
            diff[i] = prices[i+1] - prices[i];
        }

        int[] dp = new int[prices.length - 1];
        int max = Math.max(diff[0], 0);
        dp[0] = diff[0];
        for (int i = 1; i < dp.length; i++) {
            dp[i] = Math.max(diff[i], dp[i-1] + diff[i]);
            max = Math.max(max, dp[i]);
        }

        return max;
    }
}
```

# 139. Word Break
`hard`

Given a non-empty string s and a dictionary wordDict containing a list of non-empty words, determine if s can be segmented into a space-separated sequence of one or more dictionary words. You may assume the dictionary does not contain duplicate words.

For example, given

s = `"leetcode"`,

dict = `["leet", "code"]`.

Return true because `"leetcode"` can be segmented as `"leet code"`.

```java
class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        boolean[] dp = new boolean[s.length()+1];

        if (s.length() == 0 || wordDict.size() == 0) {
            return false;
        }

        // dp[i] = wordDict.contains(s.substring(0,i))
        // dp[0] = true
        // dp[i] = true if exist j that
        // dp[j] is true and s.substring(j,i) in wordDict

        dp[0] = true;

        for (int i = 1; i < dp.length; i++) {
            for (int j = 0; j < i; j++) {
                if (dp[j] && wordDict.contains(s.substring(j, i))) {
                    dp[i] = true;
                    break;
                }
            }
        }

        return dp[dp.length - 1];

    }
}
```

# 140. Word Break II
`hard`

Given a non-empty string s and a dictionary wordDict containing a list of non-empty words, add spaces in s to construct a sentence where each word is a valid dictionary word. You may assume the dictionary does not contain duplicate words.

Return all such possible sentences.

For example, given

s = `"catsanddog"`,

dict = `["cat", "cats", "and", "sand", "dog"]`.

A solution is `["cats and dog", "cat sand dog"]`.

```java
public List<String> wordBreak(String s, Set<String> wordDict) {
    return DFS(s, wordDict, new HashMap<String, LinkedList<String>>());
}

// DFS function returns an array including all substrings derived from s.
List<String> DFS(String s, Set<String> wordDict, HashMap<String, LinkedList<String>>map) {
    if (map.containsKey(s))
        return map.get(s);

    LinkedList<String>res = new LinkedList<String>();
    if (s.length() == 0) {
        res.add("");
        return res;
    }
    for (String word : wordDict) {
        if (s.startsWith(word)) {
            List<String>sublist = DFS(s.substring(word.length()), wordDict, map);
            for (String sub : sublist)
                res.add(word + (sub.isEmpty() ? "" : " ") + sub);
        }
    }
    map.put(s, res);
    return res;
}
```

# 152. Maximum Product Subarray
`medium`

Find the contiguous subarray within an array (containing at least one number) which has the largest product.

For example, given the array `[2,3,-2,4]`,
the contiguous subarray `[2,3]` has the largest product = `6`.

```java
class Solution {
    public int maxProduct(int[] nums) {
        if (nums.length == 0) {
            return 0;
        }

        long[] dpMin = new long[nums.length];
        long[] dpMax = new long[nums.length];
        dpMin[0] = nums[0];
        dpMax[0] = nums[0];
        long max = dpMax[0];

        for (int i = 1; i < nums.length; i++) {
            dpMin[i] = Math.min((long)nums[i], Math.min(dpMin[i-1]*nums[i], dpMax[i-1]*nums[i]));
            dpMax[i] = Math.max((long)nums[i], Math.max(dpMin[i-1]*nums[i], dpMax[i-1]*nums[i]));
            max = Math.max(max, dpMax[i]);
        }

        return (int)max;
    }
}
```


# 174. Dungeon Game
`hard`

The demons had captured the princess (P) and imprisoned her in the bottom-right corner of a dungeon. The dungeon consists of `M x N` rooms laid out in a 2D grid. Our valiant knight (K) was initially positioned in the top-left room and must fight his way through the dungeon to rescue the princess.

The knight has an initial health point represented by a positive integer. If at any point his health point drops to 0 or below, he dies immediately.

Some of the rooms are guarded by demons, so the knight loses health (negative integers) upon entering these rooms; other rooms are either empty (0's) or contain magic orbs that increase the knight's health (positive integers).

In order to reach the princess as quickly as possible, the knight decides to move only rightward or downward in each step.


Write a function to determine the knight's minimum initial health so that he is able to rescue the princess.

For example, given the dungeon below, the initial health of the knight must be at least 7 if he follows the optimal path RIGHT-> RIGHT -> DOWN -> DOWN.
![](/img/lc-174.png)

```java
class Solution {
    public int calculateMinimumHP(int[][] dungeon) {
        int[][] dp = new int[dungeon.length][dungeon[0].length];

        for (int i = dungeon.length-1; i >=0; i--) {
            for (int j = dungeon[0].length-1; j >=0; j--) {
                if (i == dungeon.length -1 && j == dungeon[0].length -1) {
                    dp[i][j] = Math.max (1, -dungeon[i][j] + 1);
                } else if (i == dungeon.length -1) {
                    dp[i][j] = dp[i][j+1] - dungeon[i][j] <=0 ? 1 : dp[i][j+1] - dungeon[i][j];
                } else if (j == dungeon[0].length -1) {
                    dp[i][j] = dp[i+1][j] - dungeon[i][j] <=0 ? 1 : dp[i+1][j] - dungeon[i][j];
                } else {
                    int min = Math.min(dp[i][j+1], dp[i+1][j]);
                    dp[i][j] = min - dungeon[i][j] <=0 ? 1 : min - dungeon[i][j];
                }
            }
        }

        return dp[0][0];
    }
}
```




























-
