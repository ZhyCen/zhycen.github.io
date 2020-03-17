---
title: LeetCode Array Duplication
date: 2018-02-27 11:54:31
tags: LeetCode
categories: LeetCode
---

# Array Duplication

在线性结构中, 如果要检测duplication, 最基本的方法是检测两个数字是否相等, 这里可以用到很多的技巧来判断例如hash, two pointer, bit manipulation等等. 下面针对不同的Duplication使用不同的方法进行讨论.

> 注意点: 相等的概念, == 和 equals 以及如何判断两个object是否相等.

<!-- more -->


## 题型一: 检测数组中是否有重复

### Contains Duplicate
Given an array of integers, find if the array contains any duplicates. Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.

思路一: brute force 两两比较
思路二: 用hashset的特性
思路三: sort + 检测相邻两个元素

```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int num : nums) {
            if (!set.add(num)) {
                return true;
            }
        }
        return false;
    }
}
```

### Contains Duplicate II
Given an array of integers and an integer k, find out whether there are two distinct indices i and j in the array such that nums[i] = nums[j] and the absolute difference between i and j is at most k.

和I相比, 多出限制条件, 即控制重复在一定的index范围, 对于此类题目不能sort, 因为会打乱index的顺序. 因此考虑pointer和hashmap (hashmap可以存index的值)

思路一: brute force双指针, 找相等并比较index差值
思路二: hashmap + index

```java
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Map<Integer, Integer> map = new HashMap<>();
        
        for (int i = 0; i < nums.length; i++) {
            if (map.containsKey(nums[i]) && i - map.get(nums[i]) <= k) {
                return true;
            } else {
                map.put(nums[i], i);
            }
        }
        
        return false;    
    }
}
```

## 题型二: 找出不重复的数字

### Single Number
Given an array of integers, every element appears twice except for one. Find that single one.

思路一: hashmap, 记录重复次数
思路二: bitwise xor

这里xor是一个很经典的解法, 利用的是xor的以下定律
- 交换律: A xor B = B xor A
- 结合律: A xor B xor C = A xor (B xor C)
- 0 xor A = A, A xor A = 0
- **自反性**: A xor B xor B = A

> x ^ 0 = x
> x ^ 1s = ~x // 1s = ~0
> x ^ (~x) = 1s
> x ^ x = 0 // interesting and important!
> a ^ b = c => a ^ c = b, b ^ c = a // swap
> a ^ b ^ c = a ^ (b ^ c) = (a ^ b) ^ c // associative

利用异或运算的自反性来求duplication的问题.

```java
class Solution {
    public int singleNumber(int[] nums) {
        int res = 0;
        for (int num : nums) {
            res ^= num;
        }
        return res;
    }
}
```

### Single Number II
Given an array of integers, every element appears three times except for one, which appears exactly once. Find that single one.

思路一: hashmap + freq
思路二: A xor B xor B xor B = A xor B

```java
// 用hashmap
class Solution {
    public int singleNumber(int[] nums) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int num : nums) {
            map.put(num, map.getOrDefault(num, 0) + 1);
        }
        
        int res = -1;
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) {
                res = entry.getKey();
            }
        }
        
        return res;
    }
}
```

思路二解释: 
一个数字出现一次, 其余出现三次. 核心的思想是模拟电路的设计. [参考这里s](https://leetcode.com/problems/single-number-ii/discuss/43296/An-General-Way-to-Handle-All-this-sort-of-questions.)

A:  
ones: A & 1 = A 
twos: A & ~A = 0 

AA: 
ones: A xor A & 1 = 0 
twos: A & 1 = A 

AAA:  
ones: A & ~A = 0 
twos: 0 & 1 = 0 


```java
// bitwise operation
class solution {
    public int singleNumber(int[] A) {
        int ones = 0
        int twos = 0;
        for(int i = 0; i < A.length; i++){
            ones = (ones ^ A[i]) & ~twos;
            twos = (twos ^ A[i]) & ~ones;
        }
        return ones;
    }
}
```

### Single Number III
Given an array of numbers nums, in which exactly two elements appear only once and all the other elements appear exactly twice. Find the two elements that appear only once. 

```java

```