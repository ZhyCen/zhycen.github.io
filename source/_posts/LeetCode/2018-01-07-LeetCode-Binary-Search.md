---
title: LeetCode Binary Search
tags:
  - Binary Search
  - Algorithm
  - LeetCode
categories: LeetCode
date: 2018-01-07 14:22:19
---

# 二分法
二分法的两个前提条件
- 数组有序
- 以数组的形式储存

满足二分法的条件并使用二分法会使搜索变得很快(O(log(N)), 但是同时也有不少的问题
- 无序数组无法使用
- 由于是数组, 插入删除变得很低效

# 二分法刷题的时候注意点
1. `while (lo ? hi)`这里?号的使用, 根据不同的情况进行调整
2. `mid = lo + (hi - lo) / 2` or `mid = hi - (hi - lo) / 2`. 一方面这种形式可以防止溢出, 另一方面不同的写法决定了corner case的时候lo和hi的指向.
3. 更新lo和hi的值, 要知道更新的意义是什么.
4. 判断循环什么什么时候停止, 已经停止后lo和hi指针指向的数字.

下面是对二分法出现的场景的总结.

<!-- more -->


# 第一类: 在sorted array中搜索值/插入点/边界

## Find existed target
given an array of integers and a target number, return the index of target. If target does not exist, return -1 instead.

```java
public static int binarySearch(int[] nums, int target) {
    int lo = 0;
    int hi = nums.length - 1;

    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (nums[mid] > target) {
            hi = mid - 1;
        } else if (nums[mid] < target) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}
```

## Find insert position
Given an array of integers and a target number, return the index of target. If target does not exist, return the index that target should be inserted. e.g. given `[1,3,4,5,6]` and target `2`, the answer should be `1`.

```java
public static int findIndex(int[] nums, int target) {
    int lo = 0;
    int hi = nums.length - 1;

    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (nums[mid] > target) {
            hi = mid - 1;
        } else if (nums[mid] < target) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    return lo;
}
```
### Java: binarySearch()函数
java中有binarySearch()函数, 如果找到就返回index的值, 如果找不到返回-(insert position + 1)
```java
private static int binarySearch0(int[] a, int fromIndex, int toIndex, int key) {
    int low = fromIndex;
    int high = toIndex - 1;

    while (low <= high) {
        int mid = (low + high) >>> 1;
        int midVal = a[mid];

        if (midVal < key)
            low = mid + 1;
        else if (midVal > key)
            high = mid - 1;
        else
            return mid; // key found
    }
    return -(low + 1);  // key not found.
}
```
## Find Boundary
### Find Upper-bound
for example, given an array `[1,3,5,7,9]` and a target number `7` (or `8`), the upper bound value of given number should be 9. If upper bound index does not exist, retun -1 instead.

```java
public static int binarySearchUpper(int[] nums, int target) {
    if (nums.length == 0 || target >= nums[nums.length-1]) {
        return -1;
    }

    int lo = 0;
    int hi = nums.length - 1;
    int mid = lo +( hi - lo) / 2;

    while (lo < hi) {
        if (nums[mid] > target) {
            hi = mid;
        } else {
            lo = mid + 1;
        }
        mid = lo + (hi - lo) / 2;
    }

    return mid;
}
```
Different from finding the target value, which use < = > for determination.
When searching for boundary, only need two criteria. (smaller and no smaller, or larger and no larger)

### Find Lower-bound
for example, given an array `[1,3,5,7,9]` and a target number `7` (or `6`), the upper bound value of given number should be 5. If upper bound index does not exist, retun -1 instead.

```java
public static int binarySearchUpper(int[] nums, int target) {
    if (nums.length == 0 || target <= nums[0]) {
        return -1;
    }

    int lo = 0;
    int hi = nums.length - 1;
    int mid = hi - (hi - lo) / 2;

    while (lo < hi) {
        if (nums[mid] < target) {
            lo = mid;
        } else {
            hi = mid - 1;
        }
        mid = hi - (hi - lo) / 2;
    }

    return mid;
}
```

### Search for Region
The follow up question for binary search. There might be duplicates in the array.
For example, the array is `[1, 2, 3, 5, 5, 5, 5, 7, 7, 9]`, given the target value `5`, calculate the region of given target. If array does not contain target, return [-1, -1] instead.

分别用search upper bound和lower bound即可.

# 第二类: 在数学上的运用

显然数字是有序的, 如果要从1-N找到一个数满足一定的条件, 则可以考虑使用二分法. 

## Sqrt(x)

Implement int sqrt(int x).

```java
class Solution {
    public int sqrt(int x) {
        int lo = 0;
        int hi = x;
        while (lo < hi) {
            int mid = hi - (hi - lo) / 2;
            if ((long) mid * mid > (long) x) {
                hi = mid - 1;
            } else if ((long) mid * mid < (long) x) {
                lo = mid;
            } else {
                return mid;
            }
        }
        return lo;
    }
}
```

# 第三类: 多维度的二分法

## Search a 2D Matrix

Write an efficient algorithm that searches for a value in an m x n matrix. This matrix has the following properties:
- Integers in each row are sorted from left to right.
- The first integer of each row is greater than the last integer of the previous row.

For example, Consider the following matrix:
```
[
  [1,   3,  5,  7],
  [10, 11, 16, 20],
  [23, 30, 34, 50]
]
```
Given target = 3, return true.

首先参考一下[search a 2D matrix II](https://leetcode.com/problems/search-a-2d-matrix-ii/description/), 这题非常经典, O(M+N)的时间复杂度, 从matrix的右上角开始搜索.  
而这题可以用II的做法做, 但是有更快的方法即用二分法, 因为从头到尾都是有序排列的.

```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0) {
            return false;
        }
        
        int row = matrix.length;
        int col = matrix[0].length;
        int lo = 0;
        int hi = row * col - 1;
        
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;
            int x = mid / col;
            int y = mid % col;
            if (matrix[x][y] > target) {
                hi = mid - 1;
            } else if (matrix[x][y] < target) {
                lo = mid + 1;
            } else {
                return true;
            }
        }
        
        return false;
    }
}
```

# 第四类: 局部sorted二分法的运用

和sorted不同, 此类问题可以归结为局部sorted, 关键点在于找到局部sort的边界.  
除了rotated sorted, 其余的变种也是同样的思路. 例如用二分法找极值.

## Find Peak Element

A peak element is an element that is greater than its neighbors.

Given an input array where num[i] ≠ num[i+1], find a peak element and return its index. The array may contain multiple peaks, in that case return the index to any one of the peaks is fine.  
You may imagine that num[-1] = num[n] = -∞.

For example, in array [1, 2, 3, 1], 3 is a peak element and your function should return the index number 2.

这题比较tricky的地方在于, 虽然数组不是sorted的, 但是可以利用局部最优的特点使用binary search.    
如果mid大于lo和hi, 则在lo和hi之间必定存在一个local peak.

```java
class Solution {
    public int findPeakElement(int[] nums) {
        int candidate = 0;
        while (candidate < nums.length-1) {
            if (nums[candidate] > nums[candidate + 1]) {
                return candidate;
            } else {
                candidate++;
            }
        }
        return nums.length - 1;
    }
}
```

## Rotated Sorted Array系列

### Search in Rotated Sorted Array

Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand.  
(i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).  
You are given a target value to search. If found in the array return its index, otherwise return -1.  
You may assume no duplicate exists in the array.  





# How to prevent from looping forever
there are two approaches for looping
- `while (lo <= hi)`
- `while (lo < hi)`

It is obvious that when we search for the specific target or insert position, we use first approach and the final `lo` value is target index or insert index.


note that there are three ways to calculate mid value
- `mid = (lo+hi)/2`, this might cause overflow
- `mid = lo+(hi-lo)/2`
- `mid = hi-(hi-lo)/2`

both approach 2 and 3 are okay, but can be used in different cases.
The spacial case is when `lo+1 = hi`
- `mid = lo+(hi-lo)/2 = lo`
- `mid = hi-(hi-lo)/2 = hi`

Make sure that code jump out of the while loop.

