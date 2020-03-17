---
title: Sort
date: 2017-11-22 16:57:01
tags:
    - Sort
categories: Algorithm
---

# Sort总结

在计算机科学与数学中, 一个排序算法是一种能将一串数据依照特定排序方式进行排列的一种算法. 下面针对常见的排序进行一个总结. 

## Bubble Sort 冒泡排序
冒泡排序是最基础的排序方法, 其过程可分为以下步骤
- 比较相邻的元素. 如果第一个比第二个大, 就交换他们两个. 
- 对每一对相邻元素作同样的工作, 从开始第一对到结尾的最后一对. 这步做完后, 最后的元素会是最大的数. 
- 针对所有的元素重复以上的步骤, 除了最后一个. 
- 持续每次对越来越少的元素重复上面的步骤, 直到没有任何一对数字需要比较. 

<!-- more -->

代码实现
```java
public static void sort(int[] array) {
    for (int i = 0; i < array.length - 1; i++) {
        for (int j = array.length - 1; j > i; j--) {
            if (array[j] < array[j - 1]) {
                int temp = array[j];
                array[j] = array[j - 1];
                array[j - 1] = temp;
            }
        }
    }
}
```
复杂度：O(N^2)

## Selection Sort 选择排序
选择排序的工作原理如下. 
- 在未排序序列中找到最小(大)元素, 存放到排序序列的起始位置. 
- 再从剩余未排序元素中继续寻找最小(大)元素, 然后放到已排序序列的末尾. 
- 以此类推, 直到所有元素均排序完毕. 

代码实现
```java
public static void sort(int[] array) {
    for (int i = 0; i < array.length - 1; i++) {
        int minIndex = i;
        for (int j = i; j < array.length; j++) {
            if (array[j] < array[minIndex]) {
                minIndex = j;
            }
        }
        int temp = array[i];
        array[i] = array[minIndex];
        array[minIndex] = temp;
    }
}
```
复杂度：O(N^2)

## Insertion Sort/Shell Sort 插入排序/希尔排序
插入排序的原理和玩扑克牌的时候抽牌整理比较比较相似. 插入排序一般采用in-place在数组上实现, 其原理如下
1. 从第一个元素开始, 该元素可以认为已经被排序
2. 取出下一个元素, 在已经排序的元素序列中从后向前扫描
3. 如果该元素(已排序)大于新元素, 将该元素移到下一位置
4. 重复步骤3, 直到找到已排序的元素小于或者等于新元素的位置
5. 将新元素插入到该位置后
6. 重复步骤2~5

代码实现:
```
5 4 3 2 1
| |

4 5 3 2 1

4 5 3 2 1
|   |

3 5 4 2 1
  | |

3 4 5 2 1
|     |

2 4 5 3 1
  |   |

2 3 5 4 1
    | |

2 3 4 5 1
|       |

...
```

```java
public static void sort(int[] array) {
    for (int i = 1; i < array.length; i++) {
        for (int j = 0; j < i; j++) {
            if (array[i] < array[j]) {
                int temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
    }
}
```

## Merge Sort 归并排序

采用分治法, 先排序后合并. 

假设a1和a2是两格有序的数组, 比较两个数组的最前面的数, 谁小就先取谁, 取了后相应的指针就往后移一位. 直至一个数组为空, 最后把另一个数组的剩余部分复制过来即可. 

分解的方法是, 将一个无序数组均分left和right, 分别sort两格数组并merge. 

下面是代码实现

```java
public static void mergeSort(int[] array) {
    int len = array.length;
    if (len <= 1) {
        return;
    }

    int[] left = copyArray(array, 0, len/2-1);
    int[] right = copyArray(array, len/2, len-1);

    mergeSort(left);
    mergeSort(right);

    int lindex = 0;
    int rindex = 0;
    int index = 0;

    while (lindex <= len/2-1 && rindex <= len-len/2-1) {
        if (left[lindex] < right[rindex]) {
            array[index++] = left[lindex];
            lindex++;
        } else {
            array[index++] = right[rindex];
            rindex++;
        }
    }

    while (lindex <= len/2-1) {
        array[index++] = left[lindex++];
    }

    while (rindex <= len-len/2-1) {
        array[index++] = right[rindex++];
    }
}

public static int[] copyArray(int[] array, int lo, int hi) {
    int[] res = new int[Math.max(hi - lo + 1, 0)];

    for (int i = lo; i <= hi; i++) {
        res[i - lo] = array[i];
    }

    return res;
}
```

复杂度O(N*log(N))

## Quick Sort 快速排序
快速排序使用分治法策略来把一个序列分为两个子序列, 步骤为：
- 从数列中挑出一个元素, 称为"基准"(pivot), 
- 重新排序数列, 所有比基准值小的元素摆放在基准前面, 所有比基准值大的元素摆在基准后面(相同的数可以到任何一边). 在这个分区结束之后, 该基准就处于数列的中间位置. 这个称为分区(partition)操作. 
- 递归地(recursively)把小于基准值元素的子数列和大于基准值元素的子数列排序. 
- 递归到最底部时, 数列的大小是零或一, 也就是已经排序好了. 这个算法一定会结束, 因为在每次的迭代(iteration)中, 它至少会把一个元素摆到它最后的位置去. 

代码实现, 这里pivot的选取使用最后一个元素

```java
public static void quickSort(int[] array) {
    if (array.length <= 1) {
        return;
    }

    quickSort(array, 0, array.length - 1);
}

public static void quickSort(int[] array, int lo, int hi) {
    if (lo >= hi) {
        return;
    }

    int pivot = array[(lo+hzi)/2];
    int index = partition(array, lo, hi, pivot);

    quickSort(array, lo, index-1);
    quickSort(array, index, hi);
}

public static int partition(int[] array, int lo, int hi, int pivot) {
    while (lo <= hi) {
        while (array[lo] < pivot) {
            lo++;
        }

        while (array[hi] > pivot) {
            hi--;
        }

        if (lo <= hi) {
            swap(array, lo, hi);
            lo++;
            hi--;
        }
    }

    return lo;
}

public static void swap(int[] arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

```
平均复杂度O(Nlog(N)), 最坏情况O(N^2)

### Quick Selection

## Bucket Sort 桶排序
桶排序的原理是将数组分到有限数量的桶里, 每个桶再个别排序.

- 桶排序是稳定的
- 桶排序是常见排序里最快的一种, 大多数情况下比快排还要快
- 桶排序非常快,但是同时也非常耗空间, 基本上是最耗空间的一种排序算法

在日常生活中, 桶排序通常会和Map相结合.  
举个例子, 将25,16,8,11,4,29,21,17进行排序. 

```
[0-9]  
[10-19]  
[20-29]  

[0-9] -> [8,4]
[10-19] -> [16,11,17]
[20-29] -> [25,29,21]

[0-9] -> [4,8]
[10-19] -> [11,16,17]
[20-29] -> [21,25,29]

[4,8 | 11,16,17 | 21,25,29]
```
经典的题目是[top K frequent number](https://leetcode.com/problems/top-k-frequent-elements/description/), 这里用bucket sort来实现time和space都是**O(n)**的复杂度.

Given a non-empty array of integers, return the k most frequent elements.  
For example, Given `[1,1,1,2,2,3]` and k = `2`, return `[1,2]`.  
Assuming that k is always smaller than the unique numbers in this array.

```java
class Solution {
    public List<Integer> topK(int[] nums, int k) {
        List<Integer>[] bucket = new List[nums.length + 1];
        Map<Integer, Integer> map = new HashMap<>();
        
        for (int num : nums) {
            map.put(num, map.getOrDefault(num, 0) + 1);
        }

        for (int key : map.keySet()) {
            int freq = map.get(key);
            if (bucket[freq] == null) {
                bucket[freq] = new ArrayList<>();
            }
            bucket[freq].add(key);
        }

        List<Integer> res = new ArrayList<>();
        int blen = bucket.length;
        for (int i = blen - 1; i >= 0 && res.size() < k; i--) {
            if (bucket[i] != null) {
                int isize = bucket[i].size();
                for(int j = 0; j < isize && res.size() < k; j++) {
                    res.add(bucket[i].get(j));
                }
            }
        }
        
        return res;
    }
}
```
