---
title: LeetCode Permutation
date: 2017-11-23 15:23:40
tags:
    - String
    - Permutation
categories: LeetCode
---

# Permutation 类题目的解法

在面试和刷题中，有遇到很多permutation，其大致的就是数列的全排列。下面针对全排列对LeetCode上面此类题型进行一下总结。

## 解题基本思路

<!-- more -->

## 变种以及应对方法

## 需要避免踩的坑

## LeetCode题目详解

### 31.Next Permutation

Implement next permutation, which rearranges numbers into the lexicographically next greater permutation of numbers.

If such arrangement is not possible, it must rearrange it as the lowest possible order (ie, sorted in ascending order).

The replacement must be in-place, do not allocate extra memory.

Here are some examples. Inputs are in the left-hand column and its corresponding outputs are in the right-hand column.

`1,2,3 → 1,3,2`
`3,2,1 → 1,2,3`
`1,1,5 → 1,5,1`

```java

```

### 46.Permutations

Given a collection of **distinct** numbers, return all possible permutations.

For example,
`[1,2,3]` have the following permutations:

```
[
  [1,2,3],
  [1,3,2],
  [2,1,3],
  [2,3,1],
  [3,1,2],
  [3,2,1]
]
```


```java
class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        boolean[] visited = new boolean[nums.length];
        helper(nums, visited, new ArrayList<>(), res);
        return res;
    }

    public void helper(int[] nums, boolean[] visited, List<Integer> list, List<List<Integer>> res) {
        if (list.size() == nums.length) {
            res.add(new ArrayList(list));
            return;
        }

        for (int i = 0; i < nums.length; i++) {
            if (!visited[i]) {
                list.add(nums[i]);
                visited[i] = true;
                helper(nums, visited, list, res);
                visited[i] = false;
                list.remove(list.size() - 1);
            }
        }
    }
}
```

### 47.Permutations II
Given a collection of numbers that might contain duplicates, return all possible unique permutations.

For example,
`[1,1,2]` have the following unique permutations:
```
[
  [1,1,2],
  [1,2,1],
  [2,1,1]
]
```
和46相比，no duplicate第一反应是用set，但是对于非string和integer的object在使用hashset的时候要注意set的原理，有可能会涉及到hash函数和equals函数的override。

思路是排序，然后对于重复出现的数字，如果前面一个重复的数字未被使用，则肯定存在一个较早重复排列组合。

```java
class Solution {
    public List<List<Integer>> permuteUnique(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> res = new ArrayList<>();
        boolean[] visited = new boolean[nums.length];
        helper(nums, visited, new ArrayList<>(), res);
        return res;
    }

    public void helper(int[] nums, boolean[] visited, List<Integer> list, List<List<Integer>> res) {
        if (list.size() == nums.length) {
            res.add(new ArrayList(list));
            return;
        }

        for (int i = 0; i < nums.length; i++) {
            if (i > 0 && nums[i] == nums[i-1] && !visited[i-1]) {
                continue;
            }
            if (!visited[i]) {
                list.add(nums[i]);
                visited[i] = true;
                helper(nums, visited, list, res);
                visited[i] = false;
                list.remove(list.size() - 1);
            }
        }
    }
}
```

### 60.Permutation Sequence

The set [1,2,3,…,n] contains a total of n! unique permutations.

By listing and labeling all of the permutations in order,
We get the following sequence (ie, for n = 3):

`"123"`
`"132"`
`"213"`
`"231"`
`"312"`
`"321"`

Given n and k, return the kth permutation sequence.

```java
class Solution {
    public String getPermutation(int n, int k) {
        List<String> list = new ArrayList<>();
        int[] factorial = new int[n+1];
        factorial[0] = 1;

        for (int i = 1; i <= n; i++) {
            list.add(String.valueOf(i));
            factorial[i] = factorial[i-1] * i;
        }

        k--;
        // understand why minus 1?

        StringBuilder sb = new StringBuilder();
        for (int i = n; i >= 1; i--) {
            int index = (k / factorial[i-1]);
            sb.append(list.remove(index));
            k -= index * factorial[i-1];
        }

        return sb.toString();

    }
}
```

### 266.Palindrome Permutation

Given a string, determine if a permutation of the string could form a palindrome.

For example,
`"code" -> False, "aab" -> True, "carerac" -> True.`

```java
public static void main(String[] args) {
    String s = "carerac";
    System.out.println(canPermutePalindrome(s));
}

public static boolean canPermutePalindrome (String s) {
    Set<Character> set = new HashSet<>();
    for (char chr : s.toCharArray()) {
        if (set.contains(chr)) {
            set.remove(chr);
        } else {
            set.add(chr);
        }
    }

    return set.size() <= 1;
}
```

### 267.Palindrome Permutation II

Given a string s, return all the palindromic permutations (without duplicates) of it. Return an empty list if no palindromic permutation could be form.

For example:

Given s = `"aabb"`, return `["abba", "baab"]`.

Given s = `"abc"`, return `[]`.

#### 第一反应
按照正常思路第一反应迅速把问题拆解成两个部分
- 得到permutations
- check是否是回文的形式

往往在面试高度紧张的时候会紧张从而导致想不出其他办法，因此把最简单的先想出来，确定可行然后慢慢再进一步深入思考。

```java
class Solution {
    public List<String> generatePalindromes(String s) {
        List<String> res = new ArrayList<>();

        List<String> permutations = getPermutations(s);

        for (String permutation : permutations) {
            if (checkPalindrome(permutation)) {
                res.add(permutation);
            }
        }
        return res;
    }

    // getPermutations可以参考sumologic的代码

    public boolean checkPalindrome(String s) {
        if (s.length() == 0) {
            return true;
        }

        int lo = 0;
        int hi = s.length() - 1;

        while (lo < hi) {
            if (s.charAt(lo) == s.charAt(hi)){
                lo++;
                hi--;
            } else {
                return false;
            }
        }
        return true;
    }
}
```

#### 进一步思考
如果string中出现了两个及以上的单独的字符，那么一定无法行成回文
```java
Set<Character> set = new HashSet<>();
for (Character chr : s.toCharArray()) {
    if (set.add(chr)) {
        set.remove(chr);
    }
}
```
当String很长的时候，permutation就会很多，在回溯的时候就会很久。

#### 深入思考：构造permutation

回溯找permutation的复杂度为O(N^2)，如果N减少一半则时间变成原来1/4。

如果要构造palindrome permutation则只需要考虑一半的排列。

例如考虑`aabbcc`的回文排列组合，只需要考虑`abc`

例如考虑`aabbccd`的回文只需要考虑`abc`然后把`d`放在中间。
```
the permutations of `abc` are
[
    [abc],
    [acb],
    [bca],
    [bac],
    [cab],
    [cba]
]

thus the corresponded string would be
[
    [abccba],
    [acbbca],
    [bcaabb],
    [baccab],
    [cabbac],
    [cbaabc]
]
```

```java
class Solution {
    public List<String> generatePalindromes(String s) {
        List<String> res = new ArrayList<>();
        StringBuilder sb = new StringBuilder();

        Set<Character> set = new HashSet<>();
        for (Character chr : s.toCharArray()) {
            if (set.contains(chr)) {
                set.remove(chr);
                sb.append(chr);
            } else {
                set.add(chr);
            }
        }

        if (set.size() > 1) {
            return res;
        }

        String one = "";
        if (set.size() == 1) {
            List<Character> list = new ArrayList<>();
            list.addAll(set);
            one = String.valueOf(list.get(0));
        }

        List<String> permutations = getPermutations(sb.toString());

        for(String permutation : permutations) {
            StringBuilder psb = new StringBuilder();
            psb.append(permutation);
            psb.reverse();
            psb.append(one);
            psb.append(permutation);
            res.add(psb.toString());
        }

        return res;
    }

    public List<String> getPermutations(String s) {
        List<String> permutations = new ArrayList<>();
        boolean[] visited = new boolean[s.length()];

        char[] arr = s.toCharArray();
        Arrays.sort(arr);
        helper(arr, permutations, visited, "");

        return permutations;
    }

    public void helper(char[] arr, List<String> permutations, boolean[] visited, String curr) {
        if (curr.length() == arr.length) {
            permutations.add(curr);
            return;
        }

        for (int i = 0; i < arr.length; i++) {
            if (i > 0 && arr[i] == arr[i-1] && !visited[i-1]) {
                continue;
            }

            if (!visited[i]) {
                visited[i] = true;
                String temp = curr + String.valueOf(arr[i]);
                helper(arr, permutations, visited, temp);
                visited[i] = false;
            }
        }
    }
}
```

### 384.Shuffle an Array

### 444.Sequence Reconstruction

### 484.Find Permutation

### 567.Permutation in String

### 634.Find the Derangement of An Array

### Interview Question from **Sumo Logic**

Given a haystack `h` and a needle `n`, check if haystack contains any permutations of needle

Example
```
haystack: "life appears to me too short to be spent"
needle: ""
return true

haystack: "life appears to me too short to be spent"
needle: "apple"
return false

haystack: "life appears to me too short to be spent"
needle: "file"
return true
```

you should know and be able to calculate the comlexity of this problem.

```java
public class SumoLogicInterview {
    public static void main(String[] args) {
        String haystack = "life appears to me too short to be spent";
        String needle1 = "";
        String needle2 = "apple";
        String needle3 = "file";
        System.out.println(contains(haystack, needle3));
    }

    public static boolean contains(String h, String n) {
        if (h.length() < n.length()) {
            return false;
        }

        if (n.length() == 0) {
            return true;
        }

        char[] charArr = n.trim().toCharArray();
        boolean[] visited = new boolean[charArr.length];
        List<String> permutations = new ArrayList<>();

        Arrays.sort(charArr);
        helper(charArr, permutations, visited, "");

        for (String permutation : permutations) {
            if (check(h, permutation)) {
                return true;
            }
        }

        return false;
    }

    // note that strings are immutable
    // which means that when you pass a string into a function
    // it copy the string and create new variable, rather than the reference!!!

    public static void helper (char[] arr, List<String> permutations, boolean[] visited, String curr) {
        if (curr.length() == arr.length) {
            permutations.add(curr);
            return;
        }

        for (int i = 0; i < arr.length; i++) {
            if (i > 0 && arr[i] == arr[i-1] && !visited[i-1]) {
                continue;
            }

            if (!visited[i]) {
                visited[i] = true;
                String temp = curr + String.valueOf(arr[i]);
                helper (arr, permutations, visited, temp);
                visited[i] = false;
            }
        }
    }

    public static boolean check(String h, String n) {
        for (int i = 0; i < h.length() - n.length(); i++) {
            int hi = i;
            int ni = 0;
            while (hi < h.length() && ni < n.length() && h.charAt(hi) == n.charAt(ni)) {
                hi++;
                ni++;
            }
            if (ni == n.length()) {
                return true;
            }
        }
        return false;
    }
}
```
