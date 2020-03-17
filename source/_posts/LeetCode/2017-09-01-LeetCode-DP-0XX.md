---
title: "LeetCode DP (0-100)"
date: 2017-09-01
tags: DP
categories: LeetCode
---

# 10.Regular Expression Matching
`hard`

Implement regular expression matching with support for '.' and '*'.

```
'.' Matches any single character.
'*' Matches zero or more of the preceding element.

The matching should cover the entire input string (not partial).

The function prototype should be:
bool isMatch(const char *s, const char *p)

Some examples:
isMatch("aa","a") → false
isMatch("aa","aa") → true
isMatch("aaa","aa") → false
isMatch("aa", "a*") → true
isMatch("aa", ".*") → true
isMatch("ab", ".*") → true
isMatch("aab", "c*a*b") → true
```

<!-- more -->

```java
class Solution {
    public boolean isMatch(String s, String p) {

        if (s == null || p == null) {
            return false;
        }

        int sLen = s.length();
        int pLen = p.length();

        boolean[][] dp = new boolean[sLen+1][pLen+1];

        for (int i=0; i<sLen+1; i++){
            for(int j=0; j<pLen+1; j++){
                if(i==0 && j==0) dp[i][j] = true;
                else if(j==0) dp[i][j] = false;
                else if(i==0) {
                    if(p.charAt(j-1)=='*' && dp[i][j-2]) dp[i][j] = true;
                }else if(p.charAt(j-1) == '.'){
                    dp[i][j] = dp[i-1][j-1];
                }else if(p.charAt(j-1) == '*'){
                    if(p.charAt(j-2) == s.charAt(i-1) || p.charAt(j-2)=='.'){
                        dp[i][j] = dp[i][j-2] || dp[i-1][j-1] || dp[i-1][j];
                    }
                    else dp[i][j] = dp[i][j-2];
                }else{
                    dp[i][j] = p.charAt(j-1)==s.charAt(i-1) ? dp[i-1][j-1] : false;
                }
            }
        }

        return dp[sLen][pLen];

    }
}
```

# 53.Maximum Subarray
`easy`

Find the contiguous subarray within an array (containing at least one number) which has the largest sum.

For example, given the array `[-2,1,-3,4,-1,2,1,-5,4]`,

the contiguous subarray `[4,-1,2,1]` has the largest sum = 6.

```java
class Solution {
    public int maxSubArray(int[] nums) {
        // dp[i] denote as the largest subsequence contains ith value

        if(nums.length == 0) return 0;

        int[] dp = new int[nums.length];
        dp[0] = nums[0];

        for(int i=1; i<nums.length; i++){
            dp[i] = dp[i-1] + nums[i] > nums[i] ? dp[i-1] + nums[i] : nums[i];
        }

        int max = dp[0];
        for(int i=1; i<dp.length; i++){
            if(dp[i] > max) max = dp[i];
        }

        return max;

    }
}
```
# 62.Unique Paths
`medium`

A robot is located at the top-left corner of a m x n grid (marked 'Start' in the diagram below).

The robot can only move either down or right at any point in time. The robot is trying to reach the bottom-right corner of the grid (marked 'Finish' in the diagram below).

How many possible unique paths are there?

```java
class Solution {
    public int uniquePaths(int m, int n) {
        if(m==0 || n==0) return 0;

        int[][] path = new int[m][n];

        for(int i=0; i<m; i++){
            for(int j=0; j<n; j++){
                if (i==0 || j==0) path[i][j] = 1;
                else path[i][j] = path[i][j-1] + path[i-1][j];
            }
        }

        return path[m-1][n-1];

    }
}
```
# 63.Unique Paths II
`medium`

Now consider if some obstacles are added to the grids. How many unique paths would there be?

An obstacle and empty space is marked as 1 and 0 respectively in the grid.

For example,

there is one obstacle in the middle of a 3x3 grid as illustrated below.

```
[
  [0,0,0],
  [0,1,0],
  [0,0,0]
]
```
The total number of unique paths is `2`.

```java
class Solution {
    public int uniquePathsWithObstacles(int[][] obstacleGrid) {
        if(obstacleGrid.length == 0 || obstacleGrid[0][0] == 1) return 0;
        int[][] path = new int[obstacleGrid.length][obstacleGrid[0].length];

        for(int i=0; i<obstacleGrid.length; i++){
            for(int j=0; j<obstacleGrid[0].length; j++){
                if(i==0 && j==0) path[i][j] = 1;
                else if(i==0) path[i][j] = obstacleGrid[i][j] == 1 ? 0 : path[i][j-1];
                else if(j==0) path[i][j] = obstacleGrid[i][j] == 1 ? 0 : path[i-1][j];
                else path[i][j] = obstacleGrid[i][j] == 1 ? 0: path[i-1][j] + path[i][j-1];
            }
        }

        return path[obstacleGrid.length-1][obstacleGrid[0].length-1];
    }
}
```
# 64.Minimum Path Sum
`medium`

Given a m x n grid filled with non-negative numbers

find a path from top left to bottom right which minimizes the sum of all numbers along its path.

```java
class Solution {
    public int minPathSum(int[][] grid) {

        if(grid.length == 0) return 0;
        int[][] pathsum = new int[grid.length][grid[0].length];

        for(int i=0; i<grid.length; i++){
            for(int j=0; j<grid[0].length; j++){
                if(i==0 && j==0) pathsum[i][j] = grid[i][j];
                else if(i==0) pathsum[i][j] = pathsum[i][j-1] + grid[i][j];
                else if(j==0) pathsum[i][j] = pathsum[i-1][j] + grid[i][j];
                else pathsum[i][j] = Math.min(pathsum[i][j-1], pathsum[i-1][j]) + grid[i][j];
            }
        }

        return pathsum[grid.length-1][grid[0].length-1];
    }
}
```
# 70.Climbing Stairs
`easy`

You are climbing a stair case. It takes n steps to reach to the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

```java
class Solution {

    // Fibonacci
    public int climbStairs(int n) {

        int[] step = new int[n+1];

        for(int i=0; i<=n; i++){
            if(i==0) step[i] = 1;
            else if(i==1) step[i] = step[i-1];
            else step[i] = step[i-1] + step[i-2];
        }

        return step[n];
    }
}
```
# 72.Edit Distance
`hard`

Given two words word1 and word2, find the minimum number of steps required to convert word1 to word2. (each operation is counted as 1 step.)

You have the following 3 operations permitted on a word:

+ Insert a character
+ Delete a character
+ Replace a character

```java
class Solution {
    public int minDistance(String word1, String word2) {
        /*
        dp(i, j) denote as edit distance from word1(0,i) to word2(0,j)
        if(word1[i-1] == word2[j-1]) dp(i,j) = dp(i-1, j-1);
        if(word1[i-1] != word2[j-1]) then we have three case
            case 1, we replave word1[i-1] with word2[j-1] dp(i,j) = dp(i-1, j-1) + 1;
            case 2, we add word2[j-1] to the end of word1(0,i) or delete word2[j-1] dp(i,j) = dp(i, j-1) + 1
            case 3, similar with case 2, dp(i,j) = dp(i-1, j) + 1;
        corner case dp(0,?) dp(?,0) dp(0,0)
        */

        int len1 = word1.length();
        int len2 = word2.length();

        int[][] dp = new int[len1+1][len2+1];

        for(int i=0; i<=len1; i++){
            for(int j=0; j<=len2; j++){
                if(i==0 || j==0) dp[i][j] = i+j;
                else if(word1.charAt(i-1) == word2.charAt(j-1)) dp[i][j] = dp[i-1][j-1];
                else dp[i][j] = Math.min(dp[i-1][j-1] + 1, Math.min(dp[i][j-1] + 1, dp[i-1][j] + 1));
            }
        }

        return dp[len1][len2];

    }
}
```
# 85. Maximal Rectangle

Given a 2D binary matrix filled with 0's and 1's, find the largest rectangle containing only 1's and return its area.

For example, given the following matrix:

```
1 0 1 0 0
1 0 1 1 1
1 1 1 1 1
1 0 0 1 0
```
Return 6.

```java
class Solution {
    public int maximalRectangle(char[][] matrix) {

    }
}
```
# 91. Decode Ways
`medium`

A message containing letters from `A-Z` is being encoded to numbers using the following mapping:

```
'A' -> 1
'B' -> 2
...
'Z' -> 26
```
Given an encoded message containing digits, determine the total number of ways to decode it.

For example,
Given encoded message `"12"`, it could be decoded as `"AB"` (1 2) or `"L"` (12).

The number of ways decoding `"12"` is 2.

```java
class Solution {
    public int numDecodings(String s) {

        // one(i)
        // two(i)

        if(s.length()==0) return 0;
        if(s.length()==1) return s.compareTo("0")==0 ? 0 : 1;

        int[] one = new int[s.length()];
        int[] two = new int[s.length()];

        for (int i=0; i<s.length(); i++){
            if(i==0){
                one[i] = s.charAt(i)!='0' ? 1:0;
                two[i] = 0;
            }else if(i==1){
                one[i] = s.charAt(i)!='0' ? two[i-1]+one[i-1] : 0;
                two[i] = s.charAt(i-1)=='1' || (s.charAt(i-1)=='2' && s.charAt(i) < '7') ? 1 : 0;
            }else{
                one[i] = s.charAt(i)!='0' ? two[i-1]+one[i-1] : 0;
                two[i] = s.charAt(i-1)=='1' || (s.charAt(i-1)=='2' && s.charAt(i) < '7') ? two[i-2]+one[i-2]: 0;
            }
        }

        return one[s.length()-1]+two[s.length()-1];
    }
}
```
# 96. Unique Binary Search Trees
`medium`
Given n, how many structurally unique BST's (binary search trees) that store values 1...n?

For example,
Given n = 3, there are a total of 5 unique BST's.
```
   1         3     3      2      1
    \       /     /      / \      \
     3     2     1      1   3      2
    /     /       \                 \
   2     1         2                 3
```

```java
class Solution {
    public int numTrees(int n) {
        /*
        dp(i,j) is the num of the tree that can be generated from i to j
        dp(i,j) = dp(i,k-1) * dp(k+1,j) for k = i to j
        dp(i,i) = 1
        */
        if(n==0) return 0;
        int[][] dp = new int[n][n];

        for(int i=0; i<dp.length; i++){
            for(int j=0; i+j<dp.length; j++){
                if(i==0) dp[j][i+j] = 1;
                else{
                    for(int k=j+1; k<i+j; k++){
                        dp[j][i+j] += dp[j][k-1]*dp[k+1][i+j];
                    }
                    dp[j][i+j] += dp[j+1][i+j] + dp[j][i+j-1];
                }
            }
        }

        return dp[0][n-1];

    }
}
```
# 97. Interleaving String
`hard`

Given s1, s2, s3, find whether s3 is formed by the interleaving of s1 and s2.
For example,

Given:
s1 = `"aabcc"`,
s2 = `"dbbca"`,

When s3 = `"aadbbcbcac"`, return `true`.
When s3 = `"aadbbbaccc"`, return `false`.

```java
class Solution {
    public boolean isInterleave(String s1, String s2, String s3) {
        /*
        have three pointers that point to strings p1 p2 p3=p1+p2
        define f(s,n) = s.charAt(n)
        defing dp[p1][p2] returns t/f if match

        case1: f(s1,p1)==f(s3,p3) && f(s2,p2)==f(s3,p3) dp[p1][p2] = dp[p1][p2+1]|| dp[p1+1][p2]
        case2: f(s1,p1)!=f(s3,p3) && f(s2,p2)==f(s3,p3) dp[p1][p2] = dp[p1][p2+1]
        case3: f(s1,p1)==f(s3,p3) && f(s2,p2)!=f(s3,p3) dp[p1][p2] = dp[p1+1][p2]
        case4: f(s1,p1)!=f(s3,p3) && f(s2,p2)!=f(s3,p3) dp[p1][p2] = false

        corner case:
        1. s1.length() + s2.length() != s3.length() false
        2. get the end of the string || attention here!!
        */

        if(s1.length() + s2.length() != s3.length()) return false;
        boolean[][] dp = new boolean[s1.length()+1][s2.length()+1];

        for(int i=0; i<=s1.length(); i++){
            for (int j=0; j<=s2.length(); j++){
                if(i==0 && j==0) dp[i][j] = true;
                else if(i==0) dp[i][j] = dp[i][j-1] && s2.charAt(j-1) == s3.charAt(j-1);
                else if(j==0) dp[i][j] = dp[i-1][j] && s1.charAt(i-1) == s3.charAt(i-1);
                else dp[i][j] = (dp[i][j-1]&&s2.charAt(j-1)==s3.charAt(i+j-1)) || (dp[i-1][j]&&s1.charAt(i-1)==s3.charAt(i+j-1));
            }
        }

        return dp[s1.length()][s2.length()];
    }
}
```
