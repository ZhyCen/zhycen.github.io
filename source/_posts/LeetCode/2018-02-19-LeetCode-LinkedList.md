---
title: LeetCode LinkedList
date: 2018-02-19 16:33:35
tags: [LinkedList, LeetCode]
categories: LeetCode
---
# Reverse a LinkedList

## Iterative

```java
public static ListNode reverse(ListNode head) {
   if (head == null) {
       return head;
   }
   ListNode prev = null;
   ListNode curr = head;
   ListNode next = head.next;
   while (next != null) {
       ListNode nextNext = next.next;
       curr.next = prev;
       next.next = curr;
       prev = curr;
       curr = next;
       next = nextNext;
   }
   return curr;
}
```

## Recursive

```java
public static ListNode reverseList(ListNode head) {
    if (head == null || head.next == null) {
        return head;
    }

    ListNode lastEnd = head.next;
    ListNode lastStart = reverseList(head.next);
    lastEnd.next = head;
    head.next = null;

    return lastStart;
}
```
