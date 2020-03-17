---
title: Dynamic Programming
date: 2018-02-03 13:26:26
tags:
    - Dynamic Programming
categories: Algorithm
---

## 动态规划的核心思想
其核心思想同分治法相似, 即将一个问题分解成若干个子问题; 通过递归地求解子问题的值并合并子问题得到该问题的最终解.但是动态规划和分治法最大的差别在于, 分治法得到的子问题是相互独立的, 而动态规划的子问题之间是相互联系的.

## 适用情况
能采用动态规划求解的问题的一般要具有3个性质:

- 最优化原理: 如果问题的最优解所包含的子问题的解也是最优的, 就称该问题具有最优子结构, 即满足最优化原理.
- **无后效性**: 即某阶段状态一旦确定, 就不受这个状态以后决策的影响. 即状态以后的的过程不会影响该状态.
- 有重叠子问题: 即子问题之间不是相互独立的, 一个子问题的下一个阶段的决策中可能被多次用到.

<!-- more -->

## 经典例子
斐波那契数列的求解, 同时满足最优原理无效后性和重叠子问题. 子问题的重叠关系为`f(n) = f(n-1) + f(n-2)`.
```java
class Fibonacci {
    // 1 1 2 3 5 8 13 21 34 ...
    public static int calNum(int N) {
        if (N < 0) {
            return -1;
        }

        int first = 1;
        int second = 1;

        for (int i = 2; i <= N; i++) {
            int temp = first + second;
            first = second;
            second = temp;
        }

        return second;
    }
}
```

## 经典例子II Coin Change
You are given coins of different denominations and a total amount of money amount. Write a function to compute the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1.

Example 1:
coins = [1, 2, 5], amount = 11
return 3 (11 = 5 + 5 + 1)

Example 2:
coins = [2], amount = 3
return -1.

Note:
You may assume that you have an infinite number of each kind of coin.

```java
public class Solution {
    public int coinChange(int[] coins, int amount) {
        int max = amount + 1;
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, max);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) {
            for (int j = 0; j < coins.length; j++) {
                if (coins[j] <= i) {
                    dp[i] = Math.min(dp[i], dp[i - coins[j]] + 1);
                }
            }
        }
        return dp[amount] > amount ? -1 : dp[amount];
    }
}
```
