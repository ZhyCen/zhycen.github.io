---
title: LeetCode Stock Problems
date: 2018-01-15 11:52:34
tags: LeetCode
categories: LeetCode
---

# Stock Problems

在刷题过程中遇到股票买卖一类的问题，把该类问题归类为线性查找的subarray问题，一般方法有two pointer, greedy, dynamic programming等。下面对该类题型进行总结和拓展。

## Stock Problem I
给定一列整数数组，表示每天股票的价格，求多次交易使得获利最大，有两个条件
- 卖出在买入之后
- 买入之后只有卖出之后才可再买入

For Example, given an array [1, 4, 3, 8, 4, 3, 1, 3, 6, 9]
The max profit can made is `16`.

```java
// 典型的贪心算法，增长买入不增长卖出。
public static int calMax (int nums) {
    int sum = 0;
    for (int i = 1; i < nums.length; i++) {
        int diff = nums[i] - nums[i-1];
        if (diff > 0) {
           sum += diff;
        }
    }
    return sum;
}
```
时间复杂度O(N)，空间复杂度O(1)

<!-- more -->

## Stock Problem II - Transaction limitation

### Transaction only once
在Stock Problem I的基础上，如果限制买卖的次数为一次，求最大的利润。

Example 1:
Input: [7, 1, 5, 3, 6, 4]
Output: 5

Example 2:
Input: [7, 6, 4, 3, 1]
Output: 0

最简单的方法是brute force，两两组合求最大。
```java
public static int calMax(int[] nums) {
    int maxP = 0;
    for (int i = 0; i < nums.length; i++) {
        for (int j = i+1; j < nums.length; j++) {
            maxP = Math.max(maxP, nums[j] - nums[i]);
        }
    }
    return maxP;
}
```
时间复杂度为O(N^2)，空间复杂度O(1)


#### Follow up
换个思路，给定一组数组，表示的是相邻两天的差值，那么该问题就转换成在array中找subarray，使得sum值最大，则这题就转化成[LeetCode #53. Maximum Subarray](https://leetcode.com/problems/maximum-subarray/description/)。可以用dp的思路去考虑。

先介绍一下Kadane’s Algorithm，该算法可以用来解决maximum subarray的问题，用到的思想就是DP。
```
Initialize:
    max_so_far = 0
    max_ending_here = 0

Loop for each element of the array
  (a) max_ending_here = max_ending_here + a[i]
  (b) if(max_ending_here < 0)
            max_ending_here = 0
  (c) if(max_so_far < max_ending_here)
            max_so_far = max_ending_here

return max_so_far
```

```java
// given an array, calculate the subarray that have maximum sum
// example, given [-2,1,-3,4,-1,2,1,-5,4]
// return 6, ([4,-1,2,1])

// dp[] denote as the maximum sum end with ith value
// dp[i] = Math.max(dp[i-1]+arr[i], arr[i]);

public static int calMax(int[] nums) {
    int max_sofar = 0;
    int max_ending_here = 0;

    for (int i = 1; i < nums.length; i++) {
        max_ending_here = Math.max(max_ending_here+nums[i]-nums[i-1], nums[i]-nums[i-1]);
        max_sofar = Math.max(max_sofar, max_ending_here);
    }

    return max_sofar;
}
```
时间复杂度O(N)，空间复杂度O(1)。

### Transaction at most twice
在Stock Problem I的基础上，如果限制买卖的次数至多两次，求最大的利润。

**（重要）此类有条件的一维/多维问题显然用DP做，但在这之前要想清楚两件事情**
1. **可能存在的状态**
2. **每个状态之间的关系**

<img src="/images/stock-3.JPG" alt="" style="width:40%">

```java
/*
there are five states
s0 s1 s2 s3 s4

relations
s1 = Math.max(s1, s0-prices[i])
s2 = Math.max(s2, s1+prices[i])
s3 = Math.max(s3, s2-prices[i])
s4 = Math.max(s4, s3+prices[i])

base case
s0 = 0
s1 = -prices[0]
s2 = s3 = s4 = Integer.MIN_VALUE

*/
public static int calMaxTwice(int[] prices) {
    if (prices.length == 0) {
        return 0;
    }

    int s0 = 0;
    int s1 = -prices[0];
    int s2 = 0;
    int s3 = Integer.MIN_VALUE;
    int s4 = 0;
    int maxP = 0;

    for (int i = 1; i < prices.length; i++) {
        int st1 = Math.max(s1, s0-prices[i]);
        int st2 = Math.max(s2, s1+prices[i]);
        int st3 = Math.max(s3, s2-prices[i]);
        int st4 = Math.max(s4, s3+prices[i]);
        maxP = Math.max(maxP, Math.max(Math.max(st1, st2), Math.max(st3, st4)));
        s1 = st1;
        s2 = st2;
        s3 = st3;
        s4 = st4;
    }

    return maxP;
}
```

### Transaction at most k times (*)
在Stock Problem I的基础上，如果限制买卖的次数至多k次，求最大的利润。
```java
public static int calMaxKTimes(int[] prices, int k) {
    if (prices.length == 0 || k == 0) {
        return 0;
    }

    int[] states = new int[2*k+1];
    int maxP = 0;

    states[1] = -prices[0];
    for (int i = 1; i < k; i++) {
        states[2*i+1] = Integer.MIN_VALUE;
    }

    for (int i = 1; i < prices.length; i++) {
        for (int j = 1; j < states.length; j++) {
            if (j%2 == 1) {
                states[j] = Math.max(states[j], states[j-1]-prices[i]);
            } else {
                states[j] = Math.max(states[j], states[j-1]+prices[i]);
            }
            maxP = Math.max(maxP, states[j]);
        }
    }

    return maxP;
}
```

## Stock Problem III - with Cool Down
在Stock Problem I的基础上，新增一个cool down时间，即在卖出股票之后第二天无法进行任何交易。求最大利润。
这个问题的最大挑战在于cool down上面，错误的选择可能会导致不能获得最大的利润。

例如：[1, 2, 3, 0, 2]
如果1买入3卖出，则最大的利润为2；
而如果1买入2卖出，冷却过后0买入2卖出则可以获得3利润。


<img src="/images/stock-1.JPG" alt="" style="width:40%">

```java
/*
there are three states, s0, s1 and s2.
we have three arrays which denote the maximum profit that can make at time i
s0[] s1[] and s2[]

the relationship among them are:
s0[i] = Math.max(s0[i-1], s2[i-1])
s1[i] = Math.max(s0[i-1] - prices[i], s1[i-1])
s2[i] = s1[i-1] + prices[i]

base case
s0[0] = 0
s1[0] = -prices[0]
s2[0] = Integer.MIN_VALUE

*/
public static int calMaxWithCoolDown(int[] prices) {
    if (prices.length == 0) {
        return 0;
    }

    int[] s0 = new int[prices.length];
    int[] s1 = new int[prices.length];
    int[] s2 = new int[prices.length];

    s0[0] = 0;
    s1[0] = -prices[0];
    s2[0] = Integer.MIN_VALUE;

    int maxP = 0;

    for (int i = 1; i < prices.length; i++) {
        s0[i] = Math.max(s0[i-1], s2[i-1]);
        s1[i] = Math.max(s0[i-1] - prices[i], s1[i-1]);
        s2[i] = s1[i-1] + prices[i];
        maxP = Math.max(Math.max(s0[i],s1[i]), Math.max(s2[i],maxP));
    }

    return maxP;
}
```

### Improve Space
```java
public static int calMaxWithCoolDown(int[] prices) {
    if (prices.length == 0) {
        return 0;
    }

    int s0 = 0;
    int s1 = -prices[0];
    int s2 = Integer.MIN_VALUE;
    int maxP = 0;

    for (int i = 1; i < prices.length; i++) {
        int st0 = Math.max(s0, s2);
        int st1 = Math.max(s0 - prices[i], s1);
        int st2 = s1 + prices[i];
        maxP = Math.max(Math.max(st0, st1), Math.max(st2, maxP));
        s0 = st0;
        s1 = st1;
        s2 = st2;
    }

    return maxP;
}
```

### Follow up
在Stock Problem III的基础上，cool down为变量，即输入一个数组和一个整数代表冷却的天数（k >= 0)，求最大的利润。

Example
input: prices[] = [1, 2, 3, 0, 2], k = 1
output: 3


<img src="/images/stock-2.JPG" alt="" style="width:40%">

```java
/*
now there will be 2+k states
say s0, s1, sd0, sd1 ... sdk-1

the relationship among them are:
s0[i] = Math.max(s0[i-1], sdk-1[i-1])
s1[i] = Math.max(s0[i-1] - prices[i], s1[i-1])
sd0[i] = s1[i-1] + prices[i]
sd1[i] = sd0[i-1]
sd2[i] = sd1[i-1]
...
sdk-1[i] = sdk-1[i-1]

base case
s0[0] = 0;
s1[0] = -prices[0];
sd0[0] = sd1[0] = ... = sdk-1[0] = Integer.MIN_VALUE

*/
public static int calMaxWithCoolDown(int[] prices, int k) {
    if (prices.length == 0) {
        return 0;
    }

    if (k <= 0) {
        int sum = 0;
        for (int i = 1; i < nums.length; i++) {
            int diff = nums[i] - nums[i-1];
            if (diff > 0) {
               sum += diff;
            }
        }
        return sum;
    }

    // k > 0
    int[] states = new int[k+2];
    int[] curr = new int[k+2];
    int maxP = 0;

    Arrays.fill(states, Integer.MIN_VALUE);
    states[0] = 0;
    states[1] = -prices[0];

    for (int i = 1; i < prices.length; i++) {
         curr[0] = Math.max(states[0], states[k+1]);
         curr[1] = Math.max(states[0] - prices[i], states[1]);
         curr[2] = states[1] + prices[i];
         maxP = Math.max(Math.max(curr[0], curr[1]), Math.max(curr[2], maxP));
         for (int j = 3; j < curr.length; j++) {
             curr[j] = states[j-1];
             maxP = Math.max(maxP, curr[j]);
         }
         int[] temp = states;
         states = curr;
         curr = temp;
    }

    return maxP;
}
```

## Stock Problem IV - with Transaction Fee
在Stock Problem I的基础下新增transaction fee，即每笔买卖都需要一定的手续费用，求最大的利润。

Example 1:
Input: prices = [1, 3, 2, 8, 4, 9], fee = 2
Output: 8

Explanation: The maximum profit can be achieved by:
Buying at prices[0] = 1
Selling at prices[3] = 8
Buying at prices[4] = 4
Selling at prices[5] = 9
The total profit is ((8 - 1) - 2) + ((9 - 4) - 2) = 8.

<img src="/images/stock-3.JPG" alt="" style="width:40%">

```java
public static int maxValWithFee(int[] prices, int fee) {
    if (prices.length == 0) {
        return 0;
    }

    int s0 = 0;
    int s1 = -prices[0];
    int maxP = 0;

    for (int i = 1; i < prices.length; i++) {
        int st0 = Math.max(s0, s1+prices[i]-fee);
        int st1 = Math.max(s0-prices[i], s1);
        maxP = Math.max(maxP, Math.max(st0, st1));
        s0 = st0;
        s1 = st1;
    }

    return maxP;
}
```
