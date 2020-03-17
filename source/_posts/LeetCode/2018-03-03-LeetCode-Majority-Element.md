---
title: LeetCode Majority Element
date: 2018-03-03 12:03:20
tags: LeetCode
categories: LeetCode
---


# Moore's Voting Algorithm
此类问题可以归结为 在一个数组中找次数超过N/K的所有数字, 最简单的方法就是用hashmap记录每个数字出现的次数, 遍历两遍求出符合的值. 

更快更省空间的方法是volting algorithm, 相关资料: [Boyer–Moore majority vote algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_majority_vote_algorithm) 

<!-- more -->

## Majority Element I

Given an array of size n, find the majority element. The majority element is the element that appears more than `n/2` times. 
You may assume that the array is non-empty and the majority element always exist in the array.

思路: 
用两个int来记录潜在的数字和个数,candidate和count, 并且遍历数组
如果number等于candidate则count+1
如果不等于candidate则count-1
如果不等于candidate且count的值为0的时候, 把candidate换成number, count = 1
遍历结束之后剩下的数字是**潜在**的结果
最后需要再遍历一边确保数字是validate的 (重要)


```java
class Solution {
    public int majorityElement(int[] nums) {
        int n = nums[0];
        int c = 1;
        
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] == n) {
                c++;
            } else if (c == 0) {
                n = nums[i];
                c = 1;
            } else {
                c--;
            }
        }

        int v = 0;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] == n) {
                v++;
            }
        }

        if (v > nums.length / 2) {
            return n;
        }
        
        return -1;
    }
}
```

## Majority Element II
Given an integer array of size n, find all elements that appear more than `n/3` times. The algorithm should run in linear time and in O(1) space.

```java
class Solution {
    public List<Integer> majorityElement(int[] nums) {
        List<Integer> res = new ArrayList<>();
        
        if (nums == null || nums.length == 0) {
            return res;
        }
        
        int n1 = 0;
        int n2 = 1;
        int c1 = 0;
        int c2 = 0;
        // n1 shoud be different from n2
        
        for (int num : nums) {
            if (num == n1) {
                c1++;
            } else if (num == n2) {
                c2++;
            } else if (c1 == 0) {
                n1 = num;
                c1++;
            } else if (c2 == 0) {
                n2 = num;
                c2++;
            } else {
                c1--;
                c2--;
            }
        }
        
        int len = nums.length;
        int check1 = 0;
        int check2 = 0;
        
        for (int num : nums) {
            if (n1 == num) {
                check1++;
            } else if (n2 == num) {
                check2++;
            }
        }
        
        if (check1 > len / 3) {
            res.add(n1);
        }

        if (check2 > len / 3) {
            res.add(n2);
        }
        
        return res;
    }
}
```

## Majority Element III 

Given an array of size n, find the majority element. The majority element is the element that appears more than `n/K` times.

最后提炼到一个核心的模型, 即在N个数的数组中找到所有个数超过N/K的数字集. 
和I, II相似, 但是这里要存的数字是K-1个, 这里需要用到的是map.

```java
class Solution {
    public List<Integer> majorityElementByK(int[] nums, int K) {
        List<Integer> res = new ArrayList<>();
        
        if (nums == null || nums.length == 0) {
            return res;
        }

        Map<Integer, Integer> map = new LinkedHashMap<>();

        for (int num : nums) {
            if (map.containsKey(num)) {
                map.put(num, map.get(num) + 1);
                continue;
            } 

            if (map.size() < K-1) {
                map.put(num, 1);
                continue;
            }

            boolean find = false;
            for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                if (entry.getValue() == 0) {
                    map.remove(entry.getKey());
                    map.put(num, 1);
                    find = true;
                    break;
                }
            }

            if (!find) {
                for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                    map.put(entry.getKey(), entry.getValue() - 1);
                }
            }
        }

        Map<Integer, Integer> validateMap = new HashMap<>();
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            validateMap.put(entry.getKey(), 0);
        }

        for (int num : nums) {
            if (validateMap.containsKey(num)) {
                validateMap.put(num, validateMap.get(num) + 1);
            }
        }

        for (Map.Entry<Integer, Integer> entry : validateMap.entrySet()) {
            if (entry.getValue() > nums.length / K) {
                res.add(entry.getKey());
            }
        }

        return res;
    }
}
```