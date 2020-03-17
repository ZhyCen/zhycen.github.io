---
title: LeetCode Array Sum
date: 2018-03-01 11:51:04
tags: LeetCode
categories: LeetCode
---

# K Sum 系列

通用模型: 
给定一个数组长度为N, 找出其中K个数字使得和为S, 求出所有可能且不重复的组合. 
给定一个数组长度为N, 找出其中K个数字使得和尽可能接近S, 求出最接近的组合.

sum系列的实质是dfs + backtrack, 只是在特性的环境下面(K = 2,3,4)可以使用诸如hashmap和two pointer的技巧来解决.

<!-- more -->


## Two Sum

Given an array of integers, return indices of the two numbers such that they add up to a specific target. 
You may assume that each input would have exactly one solution, and you may not use the same element twice. 

思路一: brute force, dfs思想 
思路二: sort + two pointer (sort数组移动双指针的思考) 
思路三: hashmap (三个数及以上不适用)

```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        int[] res = new int[]{-1, -1};
        Map<Integer, Integer> map = new HashMap<>();

        if (nums == null) {
            return res;
        }

        for (int i = 0; i < nums.length; i++){
            if (map.containsKey(target - nums[i])) {
                res[0] = map.get(target - nums[i]);
                res[1] = i;
                break;
            }
            map.put(nums[i], i);
        }

        return res;
    }
}
```

## Two Sum II - Input array is sorted
Given an array of integers that is already sorted in ascending order, find two numbers such that they add up to a specific target number.

思路一: 同I中的sort法, 这里已经sort过. 同向two pointer的核心思想是类binary search, 即**排除搜索**.

```java
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int[] res = new int[]{-1, -1};
        int lo = 0;
        int hi = numbers.length - 1;

        if (numbers == null) {
            return res;
        }
        
        while (lo < hi) {
            if (numbers[lo] + numbers[hi] > target) {
                hi--;
            } else if (numbers[lo] + numbers[hi] < target) {
                lo++;
            } else {
                res[0] = lo + 1;
                res[1] = hi + 1;
                break;
            }
        }
        
        return res;
    }
}
```

## Two Sum III - Data structure design
Design and implement a TwoSum class. 
It should support the following operations: `add` and `find`.

`add` - Add the number to an internal data structure. 
`find` - Find if there exists any pair of numbers which sum is equal to the value. 

For example, 
add(1); add(3); add(5); 
find(4) -> true 
find(7) -> false 

OO设计往往考察的是对于模型和函数的理解. 这里要做一个trade off. 
思路一: 每次加一个数字更新所有可能和, quick find. 
思路二: reduce成II, qick add, 注意有重复的可能性.

```java
class TwoSum {

    private HashMap<Integer, Integer> map;
    /** Initialize your data structure here. */
    public TwoSum() {
        map = new HashMap<>();
    }
    
    /** Add the number to an internal data structure.. */
    public void add(int number) {
        map.put(number, map.getOrDefault(number, 0) + 1);
    }
    
    /** Find if there exists any pair of numbers which sum is equal to the value. */
    public boolean find(int value) {
        for (int num1 : map.keySet()) {
            int num2 = value - num1;
            if ((num1 == num2 && map.get(num1) > 1)
            || (num1 != num2 && map.containsKey(num2))){
                return true;
            }
        }
        return false;
    }
}

/**
 * Your TwoSum object will be instantiated and called as such:
 * TwoSum obj = new TwoSum();
 * obj.add(number);
 * boolean param_2 = obj.find(value);
 */
```

## Three Sum

Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.

思路一: brute force, dfs思想 
思路二: reduce到two sum, sort + two pointer
思路三[待解决]: reduce到two sum, hashmap

注意overflow!

```java
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        if (nums == null || nums.length < 3) { 
            return res; 
        }
        Arrays.sort(nums);
        
        for (int i = 0; i < nums.length; i++) {
            if (i > 0 && nums[i] == nums[i-1]) {
                continue;
            }
            int lo = i + 1;
            int hi = nums.length - 1;
            while (lo < hi) {
                if ((long)nums[lo] + nums[hi] + nums[i] > 0) {
                    hi--;
                } else if ((long)nums[lo] + nums[hi] + nums[i] < 0) {
                    lo++;
                } else {
                    List<Integer> list = new ArrayList<>();
                    list.add(nums[i]);
                    list.add(nums[lo]);
                    list.add(nums[hi]);
                    res.add(list);
                    while (lo < hi && nums[lo] == nums[lo+1]) {
                        lo++;
                    }
                    while (lo < hi && nums[hi] == nums[hi-1]) {
                        hi--;
                    }
                    lo++;
                    hi--;
                }
            }
        }
        
        return res;
    }
}
```

## Three Sum Closest

Given an array S of n integers, find three integers in S such that the sum is closest to a given number, target. Return the sum of the three integers. You may assume that each input would have exactly one solution.

思路一: brute force 
思路二: 类二分法 sort + two pointer, 目标靠近target 同时keep一个变量更新

```java
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        if (nums == null || nums.length < 3) {
            return Integer.MIN_VALUE;
        }
        
        Arrays.sort(nums);
        long res = nums[0] + nums[1] + nums[2];
        long close = Math.abs(res - target);
        
        for (int i = 0; i < nums.length; i++) {
            int lo = i + 1;
            int hi = nums.length - 1;
            while (lo < hi) {
                long sum = (long) nums[i] + nums[lo] + nums[hi];
                if (Math.abs(sum - target) < close) {
                    close = Math.abs(sum - target);
                    res = sum;
                }
                if (sum > target) {
                    hi--;
                } else if (sum < target) {
                    lo++;
                } else {
                    return (int)res;
                }
            } 
        }
        
        return (int)res;
    }
}
```

## Three Sum Smaller
Given an array of n integers nums and a target, find the number of index triplets i, j, k with 0 <= i < j < k < n that satisfy the condition nums[i] + nums[j] + nums[k] < target.

思路一: bf, dfs
思路二: sort + search boundary 

此题目和上题的区别在于求出所有小于target的组合, 核心在于**边界的寻找**, 类似二分法的寻找边界. 

```java
class Solution {
    public int threeSumSmaller(int[] nums, int target) {
        if (nums == null || nums.length < 3) {
            return 0;
        }
        int res = 0;
        
        Arrays.sort(nums);
        for (int i = 0; i < nums.length; i++) {
            int lo = i + 1;
            int hi = nums.length - 1;
            while (lo < hi) {
                if ((long) nums[i] + nums[lo] + nums[hi] >= target) {
                    hi--;
                } else {
                    res += hi - lo;
                    lo++;
                }
            }
        }
        
        return res;
    }
}
```

## Four Sum
Given an array S of n integers, are there elements a, b, c, and d in S such that a + b + c + d = target? Find all unique quadruplets in the array which gives the sum of target.

思路一: 对于K > 2以上的, 核心思想是dfs. 
思路二: reduce问题到3sum和2sum, 分治思想. 

reduce I: 
- sort O(Nlog(N)) 
- 4sum reduce 到 3sum问题
- 3sum问题的复杂度O(N^2)
- 总复杂度O(Nlog(N) + N^3)

reduce II: 
- sort O(Nlog(N))
- 4sum reduce到两个2sum O(N) + hashmap
- 第一个2sum O(N^2) 第二个O(N)
- 从复杂度O(Nlog(n) + N^3)

```java
// reduce 到three sum
class Solution {
    public List<List<Integer>> fourSum(int[] nums, int target) {
        List<List<Integer>> res = new ArrayList<>();
        if (nums == null || nums.length < 4) {
            return res;
        }
        
        Arrays.sort(nums);
        for (int i = 0; i < nums.length - 3; i++) {
            if (i > 0 && nums[i] == nums[i-1]) {
                continue;
            }
            List<List<Integer>> list = threeSum(nums, i+1, nums.length-1, (long) target - nums[i]);
            for (List<Integer> curr : list) {
                curr.add(nums[i]);
            }
            if (!list.isEmpty()) {
                res.addAll(list);
            }
        }
        
        return res;
    }
    
    private List<List<Integer>> threeSum(int[] nums, int start, int end, long target) {
        List<List<Integer>> res = new ArrayList<>();
        if (end - start < 2) {
            return res;
        }
        
        for (int i = start; i <= end; i++) {
            if (i > start && nums[i] == nums[i-1]) {
                continue;
            }
            int lo = i + 1;
            int hi = end;
            while (lo < hi) {
                if ((long)nums[lo] + nums[hi] + nums[i] > target) {
                    hi--;
                } else if ((long)nums[lo] + nums[hi] + nums[i] < target) {
                    lo++;
                } else {
                    List<Integer> list = new ArrayList<>();
                    list.add(nums[i]);
                    list.add(nums[lo]);
                    list.add(nums[hi]);
                    res.add(list);
                    while (lo < hi && nums[lo] == nums[lo+1]) {
                        lo++;
                    }
                    while (lo < hi && nums[hi] == nums[hi-1]) {
                        hi--;
                    }
                    lo++;
                    hi--;
                }
            }
        }
        
        return res;
    }
}
```

``` java
// reduce到另个two sum
class Solution {
    public List<List<Integer>> fourSum(int[] nums, int target) {
        List<List<Integer>> res = new ArrayList<>();
        if (nums == null || nums.length < 4) {
            return res;
        }
        
        Arrays.sort(nums);
        
        for (int i = 0; i < nums.length - 3; i++) {
            if (i > 0 && nums[i] == nums[i-1]) {
                continue;
            }
            for (int j = i + 1; j < nums.length - 2; j++) {
                if (j > i + 1 && nums[j] == nums[j-1]) {
                    continue;
                }
                long rest = (long)target - nums[i] - nums[j];
                List<List<Integer>> list = twoSum(nums, j+1, nums.length-1, rest);
                if (!list.isEmpty()) {
                    for (List<Integer> temp : list) {
                        temp.add(nums[i]);
                        temp.add(nums[j]);
                    }
                    res.addAll(list);
                }
            }
        }
        
        return res;
    }
    
    private List<List<Integer>> twoSum(int[] nums, int lo, int hi, long target) {
        List<List<Integer>> res = new ArrayList<>();
        if (hi - lo < 1) {
            return res;
        }
        
        while (lo < hi) {
            if ((long)nums[lo] + nums[hi] > target) {
                hi--;
            } else if ((long)nums[lo] + nums[hi] < target) {
                lo++;
            } else {
                List<Integer> list = new ArrayList<>();
                list.add(nums[lo]);
                list.add(nums[hi]);
                res.add(list);
                while (lo < hi && nums[lo] == nums[lo+1]) {
                    lo++;
                }
                while (lo < hi && nums[hi] == nums[hi-1]) {
                    hi--;
                }
                lo++;
                hi--;
            }
        }
        
        return res;
    }
}
```

## Four Sum II

Given four lists A, B, C, D of integer values, compute how many tuples (i, j, k, l) there are such that A[i] + B[j] + C[k] + D[l] is zero.

To make problem a bit easier, all A, B, C, D have same length of N where 0 ≤ N ≤ 500. All integers are in the range of -2^28 to 2^28 - 1 and the result is guaranteed to be at most 2^31 - 1.

思路一: bf
思路二: reduce 到两个hashmap O(N^2)

```java
class Solution {
    public int fourSumCount(int[] A, int[] B, int[] C, int[] D) {
        int count = 0;
        Map<Integer, Integer> map = new HashMap<>();
        
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < B.length; j++) {
                int sum = A[i] + B[j];
                if (!map.containsKey(sum)) {
                    map.put(sum, 0);
                }
                map.put(sum, map.get(sum)+1);
            }
        }
        
        for (int i = 0; i < C.length; i++) {
            for (int j = 0; j < D.length; j++) {
                int sum = -(C[i] + D[j]);
                if (map.containsKey(sum)) {
                    count += map.get(sum);
                }
            }
        }
        return count; 
    }
}
```
# Range Sum 系列

和Sum系列不同的是, subarray sum要求的是找到一个subarray满足sum到达一定条件.这里涉及到一个range, 即和index以及value相关. 联想到的方法有two pointers的sliding window, hashmap以及dynamic programming.

## Range Sum Immutable

Given an integer array nums, find the sum of the elements between indices i and j (i ≤ j), inclusive.

Example:  
Given nums = [-2, 0, 3, -5, 2, -1]  

sumRange(0, 2) -> 1  
sumRange(2, 5) -> -1  
sumRange(0, 5) -> -3  

思路: 这题是range sum系列的核心思想之一, 即如何用dp的思维去求任一一段subarray的和

```java
class NumArray {
    
    private int[] sum;

    public NumArray(int[] nums) {
        if (nums == null || nums.length == 0) {
            return;
        }
        sum = new int[nums.length];
        sum[0] = nums[0];
        for (int i = 1; i < nums.length; i++) {
            sum[i] = nums[i] + sum[i-1];
        }
    }
    
    public int sumRange(int i, int j) {
        if (sum == null || sum.length == 0) {
            return 0;
        }
        
        if (i == 0) {
            return sum[j];
        }
        return sum[j] - sum[i-1];
    }
}

/**
 * Your NumArray object will be instantiated and called as such:
 * NumArray obj = new NumArray(nums);
 * int param_1 = obj.sumRange(i,j);
 */
```

## Maximum Subarray

Find the contiguous subarray within an array (containing at least one number) which has the largest sum.  
For example, given the array [-2,1,-3,4,-1,2,1,-5,4],  
the contiguous subarray [4,-1,2,1] has the largest sum = 6.

思路一: bf, 用两个指针表示开始和结束
思路二: 
动态规划  
d[i]表示i结尾的最大的subarray sum
则有 d[i] = Math.max(nums[i], dp[i-1] + nums[i]);  
最后遍历一边求出最大的的值  
简化之后可以keep两个值来求maxSoFar和maxCurr

**思路三: divide and conquer?**


和此类问题相似的是stock problem I

```java
class Solution {
    public int maxSubArray(int[] nums) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        
        int maxTotal = nums[0];
        int maxCurr = nums[0];
        
        for (int i = 1; i < nums.length; i++) {
            int num = nums[i];
            maxCurr = Math.max(maxCurr + num, num);
            maxTotal = Math.max(maxCurr, maxTotal);
        }
        
        return maxTotal;
    }
}
```

## Continuous Subarray Sum

Given a list of non-negative numbers and a target integer k, write a function to check if the array has a continuous subarray of size at least 2 that sums up to the multiple of k, that is, sums up to n*k where n is also an integer.

Example 1:  
```
Input: [23, 2, 4, 6, 7],  k=6
Output: True
Explanation: Because [2, 4] is a continuous subarray of size 2 and sums up to 6.
```
Example 2: 
```
Input: [23, 2, 6, 4, 7],  k=6
Output: True
Explanation: Because [23, 2, 6, 4, 7] is an continuous subarray of size 5 and sums up to 42.
```

此题目的实质是duplication in array.  
subarray有一个很重要的求和性质就是**sum(i,j) = sum(0,j) - sum(0, i-1)**. 可以看做是dp的思想.

```java
class Solution {
    public boolean checkSubarraySum(int[] nums, int k) {
        if (nums == null || nums.length <= 1) {
            return false;
        }
        
        int[] mods = new int[nums.length + 1];
        mods[0] = 0;
        
        for (int i = 1; i < mods.length; i++) {
            mods[i] = k == 0 ? mods[i-1] + nums[i-1] : (nums[i-1] % k + mods[i-1]) % k;
        }
        
        // reduce to the problem  
        // given array mods[], wherer the value is 0 - k-1, length is n
        // find i and j that i + 1 < j and mods[j] == mods[i]
        // hashmap 
        
        Map<Integer, Integer> map = new HashMap<>();
        
        for (int i = 0; i < mods.length; i++) {
            if (!map.containsKey(mods[i])) {
                map.put(mods[i], i);
            } else if (i - map.get(mods[i]) > 1) {
                return true;
            }
        }
        
        return false;
    }
}
```
## Minimum Size Subarray Sum

Given an array of n positive integers and a positive integer s, find the minimal length of a contiguous subarray of which the sum ≥ s. If there isn't one, return 0 instead.

For example, given the array [2,3,1,2,4,3] and s = 7,  
the subarray [4,3] has the minimal length under the problem constraint.

思路: 典型的sliding window题目. two pointers

```java
class Solution {
    public int minSubArrayLen(int s, int[] nums) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        
        int lo = 0;
        int hi = 0;
        int sum = 0;
        int minLen = Integer.MAX_VALUE;
        
        while (hi < nums.length) {
            if (sum < s) {
                sum += nums[hi++];
            } 
            while (sum >= s) {
                minLen = Math.min(minLen, hi - lo);
                sum -= nums[lo++];
            }
        }
        
        return minLen == Integer.MAX_VALUE ? 0 : minLen;
    }
}
```

## Subarray Sum Equals K
Given an array of integers and an integer k, you need to find the total number of continuous subarrays whose sum equals to k.

Example 1:  
Input:nums = [1,1,1], k = 2  
Output: 2  

思路: range sum的核心之一是dp思想的sums数组, 利用sum[i] - sum[j]计算range sum

```java
class Solution {
    public int subarraySum(int[] nums, int k) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        
        int[] sums = new int[nums.length];
        sums[0] = nums[0];
        for (int i = 1; i < sums.length; i++) {
            sums[i] = sums[i - 1] + nums[i];
        }
        
        // reduce to the problem, that find i, j, that 
        // 1. i < j
        // 2. sum[i] = sums[j] - k
        // 因此使用hashmap, two sum变种
        
        int res = 0;
        Map<Integer, Integer> map = new HashMap<>();
        map.put(0, 1);
        for (int i = 0; i < sums.length; i++) {
            res += map.getOrDefault(sums[i] - k, 0);
            map.put(sums[i], map.getOrDefault(sums[i], 0) + 1);
        }
        
        return res;
    }
}
```

## Maximum Size Subarray Sum Equals k
Given an array nums and a target value k, find the maximum length of a subarray that sums to k. If there isn't one, return 0 instead.

```java
class Solution {
    public int maxSubArrayLen(int[] nums, int k) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        
        int sum = 0;
        int res = 0;
        
        Map<Integer, Integer> map = new HashMap<>();
        map.put(0, -1);
        
        // sums(i,j) = sums(0, j) - sums(0, i-1);
        
        for (int i = 0; i < nums.length; i++) {
            sum += nums[i];
            if (!map.containsKey(sum)) {
                map.put(sum, i);
            }
            if (map.containsKey(sum - k)) {
                res = Math.max(res, i - map.get(sum - k));
            }
        }
        
        return res;
    }
}
```

# 总结

## K Sum 总结

1. 对于无序数组, 考虑用hashmap
2. 对于有序的数组, 求和可以考虑对冲two pointer
3. 对于高阶sum, reduce到2或者3 sum
4. 注意重复数组可能带来的问题

## Range Sum 总结

range sum和k sum的区别在于它是一个range.  

1. 对于给定一个数组和一个值k, 求满足和的(最长/最短)range: 可以用sums数组+hashmap
2. 对于给定一个数组和一个值k, 求大于k的最短/小于k的最长的subarray, 用two pointers + sliding window
3. 对于给英一个数组, 求满足某些条件的subarray 可以考虑用dp



