---
title: Trie
date: 2018-02-03 15:44:39
tags:
    - Trie
    - Tree
categories: Algorithm
---

字典树, 又称单词查找树, Trie树, 是一种树形结构, 是一种哈希树的变种. 典型应用是用于统计, 排序和保存大量的字符串(但不仅限于字符串), 所以经常被搜索引擎系统用于文本词频统计.  
它的**优点**是: 利用字符串的公共前缀来节约存储空间, 最大限度地减少无谓的字符串比较, 查询效率比哈希表高.  
字典树与字典很相似, 当你要查一个单词是不是在字典树中, 首先看单词的第一个字母是不是在字典的第一层, 如果不在, 说明字典树里没有该单词, 如果在就在该字母的孩子节点里找是不是有单词的第二个字母, 没有说明没有该单词, 有的话用同样的方法继续查找.  
字典树不仅可以用来储存字母, 也可以储存数字等其它数据. 

<!-- more -->


# Build a Trie Node
```java
class Trie {

    Trie[] trieNodes;
    boolean isWord;

    /** Initialize your data structure here. */
    public Trie() {
        trieNodes = new Trie[26];
        isWord = false;
    }

    /** Inserts a word into the trie. */
    public void insert(String word) {
        Trie curr = this;
        for (char chr : word.toCharArray()) {
            int index = chr - 'a';
            if (curr.trieNodes[index] == null) {
                curr.trieNodes[index] = new Trie();
            }
            curr = curr.trieNodes[index];
        }
        curr.isWord = true;
    }

    /** Returns if the word is in the trie. */
    public boolean search(String word) {
        Trie curr = traverse(this, word);
        return curr != null && curr.isWord;
    }

    /** Returns if there is any word in the trie that starts with the given prefix. */
    public boolean startsWith(String prefix) {
        Trie curr = traverse(this, prefix);
        return curr != null;
    }

    private Trie traverse(Trie curr, String str) {
        for (char chr : str.toCharArray()) {
            int index = chr - 'a';
            if (curr.trieNodes[index] == null) {
                return null;
            }
            curr = curr.trieNodes[index];
        }
        return curr;
    }
}
```
> Ref: [ACMBook](https://hrbust-acm-team.gitbooks.io/acm-book/content/data_structure/ds_part4.html)