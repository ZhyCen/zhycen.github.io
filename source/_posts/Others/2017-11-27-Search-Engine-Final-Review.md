---
title: Search Engine Final Review
date: 2017-11-27 09:09:31
tags:
    - Search Engine
    - Information Retrieval
categories: Lecture
---

今天刚考完CSCI 571的Final，把这几天整理的资料传上来。

# Map Reduce

1. MapReduce was developed at Google
2. Hadoop is an open source implementation of MapReduce
3. Assumptions
    - Files are distributed
    - Files are rarely updated, often read and sometimes appended to
    - Files are divided into chunks and chunks are replicated
4. What Map reduce provide
	- Automatic parallelization of code & distribution across - multiple processors
    - Fault tolerance in the event of failure of one or more nodes
	- I/O scheduling
	- Monitoring & Status updates
5. The Map/Reduce Paradigm
	- Records are broken into segments
	- Map: extract something of interest from each segment
	- Group and sort intermediate results from each segment
	- Reduce: aggregate intermediate results
	- Generate final output
6. Map
	- The master controller process knows how many Reduce tasks there will be, say r.
	- Map tasks turn the chunk into a sequence of k-v pairs by applying Map function.
	- Each k-v pair will be put into r files. (depends on hash of their keys)
6. Reduce
	- keys are divided among all the Reduce tasks, so all key-value pairs with the same key wind up at the same Reduce task
	- output from all reduce tasks are merged into a single file.
	- *The Reduce function is generally associative and commutative implying values can be combined in any order yielding the same result
7. Coping with Node Failure
	- Master is executing fail
    	- Restart map-reduce job
	- Map worker fails
    	- The Master detect and sets the status of each Map task to idle and re-schedules them when a worker becomes available
	- Reduce worker fails
    	- The Master detect and sets the status of its currently executing Reduce tasks to idle and they will be re-scheduled on another reduce worker later

<!-- more -->

# The Search Engine Business Model Advertising

1. Type of On-line advertising
    - Banner Advertising
    - Pay-per-click advertising
    - Website advertising
    - Affiliate Marketing
    - Social Media Marketing
2. Search Engine Optimization (SEO)
    - Making pages show up higher in search engine’s organic results
    - Optimizing content to target certain keyword phrases
    - Developing web page content that responds to each seeker’s interests
3. Four types of keyword matching
    - Broad match
    - Exact match
    - Phrase match
    - Negative keywords
4. Broad Match
    - Kw: tennis shoes, ad will appears when searching tennis and shoes
    - Extended matches, synonyms, plurals
5. Exact Match
    - "Tennis shoes" would only match a user request for "tennis shoes" and not for "red tennis shoes", exact word match
    - Exact match will now ignore function words (in, to), conjunctions (for, but), articles (a, the) and other words that don’t impact the intent of the query
6. Phrase Match
    - Your AD appears when users search on the exact phrase and when their search contains additional terms
    - Tennis shoes will match red tennis shoes but not shoes for tennis
7. Negative Keyword
    - Allow you to eliminate searches that you know are not related to your message
    - If “-table” add to “tennis” then table will not appear when searching tennis.
8. Google AdWords
    - Each bidder specifies
        - Search terms that trigger its bid
        - The amount to bid for each search term
    - Bit Rank = click through rate * bid amount.
    - Google get paid when ad clicked
    - Ad Rank determines ad position
        - Ad Rank= Bid * Click Probability
    - Actual cost-per-click determined by next ad with highest ad-rank below
9. Some of payment approaches
    - Cost-per-click
    - Cost per Thousand displays
    - Cost per Engagement, (pay when users actively engaged with ads)
10. AdSense
    - service for placing Google ads on web pages
    - written in JavaScript, and use JSON to display content fetched by Google’s servers
    - Content match based on WordNet
11. Some components in today’s advertisement system
    - Client
    - Publisher
    - Tracker
    - Advertisers
    - Broker (Ad exchanger): understand this, this is important
12. Web Beacons
    - Small strings of HTML code that are placed in a Web page.
    - Often used in conjunction with cookies
    - 1 pixel high by 1 pixel wide, invisible but send some useful information to server.

 
# Search Engines and the Growth of Knowledge-Based Systems

1. Knowledge Bases: store complex structured and unstructured information used by a computer system, which contains two elements
    - a knowledge-base that represents facts about the world
    - an inference engine that can reason about those facts
2. Difference between taxonomy and ontology
    - A taxonomy (分类学) is usually only a hierarchy of concepts (i.e. parent/child, subclass/superclass, etc); tree structure
    - In an ontology (本体论), arbitrary complex relations between concepts can be expressed as well, e.g. (X marriedTo Y; or A worksFor B, etc ); directed, labeled, cyclic graph.
    - Taxonomies are narrower than ontologies
3. Some Types of knowledges in KBs
    - Taxonomic knowledge
    - Factual knowledge
    - Temporal knowledge
    - Emerging knowledge
    - Terminological knowledge
4. List some digital KBs
    - WordNet: Lexical (词汇的) Knowledge base for English
        - Synset: groups English words into sets of synonyms called synsets
        - Hyponym: More specific
        - Meronym: Denoting the whole
        - Holonym: A broad or superordinate
    - Wikipedia
    - Wolfram Alpha
    - Freebase
5. Notations for KB
    - Triple notation: Subject: Predicate: Object
    - Logical Notation: e.g. bornIn(Elvis, Tupelo)
6. Inference on KB
    - Apply logical rules to deduce new information
    - Has two models
        - Forward chaining starts with the known facts and asserts new facts.
        - Back ward chaining starts with goals, and works backward to determine what facts must be asserted so that the goals can be achieved
        - Three sequential steps: match rules, select rules, execute rules
7. Forward chaining
    - Is repeated application of modules ponens, understand the examples
    - Module ponens: ((P→Q)∧P)→ Q
8. Google Knowledge Graph Enhance Google search in 3 ways
    - To improve the variety of search results
    - To provide deeper and broader results
    - To provide the best summary
9. Wikipedia
    - Related projects to Wikipedia
        - Commons for multimedia
        - Wiktionary as free dictionary
        - Wikidata for structured data
        - WikiData is an effort to convert the Wikipedia data into a - knowledge base

 
# Query Processing

1. Cosine similarity is a proxy for satisfying user’s query
    - Challenges
        - find the K docs in the collection “nearest” to the query
        - find the K docs efficiently
2. Understand the process of calculate cosine similarity and get top K
3. Five Refinements for Choosing Documents Matching the Query
    - Only consider high-idf query terms
    - Only consider docs containing many (or all) of the query terms
    - Introduce Champion Lists Heuristic
    - Introduce an Authority Measure
    - Reorganize the Inverted List
4. Only consider high-idf query terms
    - Idf: inverse document frequency
    - E.g. searching ‘catcher in the rye’, calculate ‘catcher’ and ‘rye’
5. Only consider docs containing many (or all) of the query terms
    - e.g. For multi-term queries, only compute cosine scores for docs containing several of the query terms (like 2 or 3)
6. Introduce Champion Lists Heuristic
    - Pre-compute for each dictionary term t, the r docs of highest weight (tf-idf) in t’s postings
    - At query time, only compute scores for docs in the champion list of some query term
7. Introduce an Authority Measure
    - Relevant and authoritative
        - Relevance is being modeled by cosine scores
        - Authority is typically a query-independent property of a document, e.g. Wikipedia among websites, A paper with high citations, High PageRank etc.
    - Assign to each document a query-independent quality score in [0,1] to each document d, g(d) evaluate the authoritative of that document.
    - Net-score(q,d) = g(d) + cosine(q,d)
8. Reorganize the Inverted List**
    - Champion lists in g(d)-ordering
        - Champion list of the r docs with highest g(d) + tf-idftd
    - High and Low Lists Heuristic
        - High as the champion list
        - When traversing postings on a query, only traverse high lists first
    - Impact-Ordered Postings Heuristic
        - Sort each postings list by wft,d, in decreasing order
    - Early Termination


 
# Spell Checking and Correction

1. The Two Main Spelling Tasks
    - Spelling Error Detection
    - Spelling Error Correction
2. Three Types of Spelling Errors
    - Non-word errors
    - Typographical errors
    - Cognitive errors (homophones, sounds alike)
3. Non-Word Spelling Errors
- Detection: not in dict -> error
- Correction:
    - Shortest weighted Edit Distance. Why weighted? some letters are more likely to be mistyped than others
    - Highest noisy channel probability
- Understand some challenges and cases
    - Context is needed for spell checking
    - Insertion or deletion of hyphen of spaces
4. Bayes Rules
    - Bayes Rules: P(a│b)=(P(b|a)P(a))/(P(b))
    - w^'=argmax (P(x|w)P(w))/(P(x))=argmaxP(x│w)P(w)
    - Understand how this algorithm work based on (b) [16]
5. Dictionary and Autocomplete
    - From left to right
    - Using data structure for prefix matching: prefix tree: O(m)
    - N-gram model: probabilistic language model for predicting next item.
6. Peter Norvig’s Spelling Corrector
    - Both edit distance 1 and distance 2
    - big.txt contains a million words (dict)
7. Edit Distance and Levenshtein Algorithm
    - In Levenshtein algorithm, substitutions cost 2 while deletions and insertions still cost 1

 
# Snippets (Normal and Rich)

1. Snippets are created automatically based on the site’s content and the query terms.
2. two general approaches to automatic summarization
    - Extraction: selecting a subset of existing words
    - Abstraction: build an internal semantic representation and create a summary
3. Google Snippets
    - Begins with ellipses (…) => extract from body, end with (…) => truncated
    - Maximum length of a snippet is 156
    - Google uses the meta description as the default
    - Open Directory Project meta data
4. Snippet Algorithm
    - Identify the paragraphs that include the query terms
    - Score the paragraphs and determining the paragraph with the highest score
    - Return the phrase in that paragraph that includes the query terms
5. Rich Snippets
    - a mechanism for website developers to include information that Google's results algorithm will display as a snippet
    - Advantages
        - Additional Traffic to a webpage
        - Higher click through rate
6. Schema of Rich Snippets
- Specification for rich snippets
    - Microdata formalism
    - RDFa
    - Microformat Encoding
6. Schema.org defines an object hierarchy
- Thing (the most general item)
    - Name (Properties)
    - Description (Properties)
    - URL (Properties)
    - Image (Properties)
- Understand the hierarchy
    - Person, place, Organization, etc. are hierarchy of things
7. Some Examples
    - Google: know some entities [18]
    - Microsoft: use class attributes in HTML tags

 
# Clustering

1. What is clustering
    - process of grouping a set of objects into classes of similar objects
    - most common form of unsupervised learning
    - hypothesis: Documents with similar text are related
2. Some Examples
    - Cluster images based on visual content
    - Cluster webpages based on content, related search
    - Cluster similar proteins together in bioinformatics, etc.
3. Yippy: emphasizes clusters of results
4. Why for search engines
    - Improve recall in search applications
    - Speed up vector space retrieval
    - Cleaner user interface
5. criterion for a good clustering
    - the intra-class (that is, intra-cluster) similarity is high
    - the inter-class similarity is low
    - the measured quality of a clustering depends on document representation and the similarity measure used
6. Criteria of Adequacy for Clustering Methods
    - The method produces a clustering which is unlikely to be altered drastically when further objects are incorporated
    - The method is stable in the sense that small errors in the description of objects lead to small changes in the clustering
    - The method is independent of the initial ordering of the objects
7. Difference between clustering and classification
    - In classification, there is a set of predefined classes and want to know which class a new object belongs to; while clustering tries to group objects and find some relationships between objects
    - Classification is supervised learning and clustering is unsupervised learning
8. Supervised learning
    - Definition: inferring a function from labeled training data
    - Documents in each cluster define the training docs for each category
    - Documents are in a cluster based on the similarity measure used.
    - A classifier is an algorithm that will classify new docs
    - Given a new doc, figure out which partition it falls into
9. Clustering
    - Vector space represent for documents
    - Use cosine similarity to calculate similarity, while Euclidean distance is a close alternative.
    - Hard vs. soft clustering
        - Hard clustering: each document belongs to exactly one cluster
        - Soft clustering: A document can belong to more than one cluster
10. K-Means Clustering Algorithm
    - Step1: Select K points as initial centroids
        - Randomly or by methods such as most distant points from each other’s (k-means++ algorithm)
    - Step2: form K clusters by assigning each point to its closest centroid and recalculate the centroids of each clusters
    - Step3: until centroids do not change
        - fixed number of iterations
        - document partition does not change
        - centroid does not change, etc.
    - Complexity of K-means
        - Calculate distance: O(M) (M=dimension)
        - Re-assign clusters O(kN) * O(M) = O(kMN)
        - Compute new centroid: O(MN)
        - Total: O(IKMN) (I=number of iterations)
    - Optimal K-Means Clustering: NP-hard problem
11. Agglomerative Clustering Algorithm: Bottom-up
    - Step1: all document is one cluster
    - Step2: Repeat
        - Calculate distance matrix, distance between each clusters
        - Merge two closet matrix
        - Update matrix
    - Step3: Until meet the condition
    - Time Complexity
        - Calculate matrix: O(N^2)
        - Find closet pair: O(N) (Heap)
        - Update O(Nlog(N)) (Heap)
        - Total: O(N^2)
12. Divisive Clustering: Top-down
13. Dendrogram
    - A dendrogram is a tree diagram frequently used to illustrate the arrangement of the clusters produced by hierarchical clustering
14. Labeling – two approaches
    - Show titles of typical documents
    - Show words/phrases prominent in cluster
15. Evaluation clustering algorithm
    - Anecdotal
    - User inspection
    - Ground “truth” comparison
    - Purely quantitative measures
    - Purity Measure - accuracy is measured by the number of correctly assigned documents divided by the total number of documents
        - Rand index (RI) measures the percentage of decisions that are correct.
        - RI=(TP+TN)/(TP+TN+FN+FP)
 
# Search Engine Question Answering

1. Difference between information retrieval and question answering
2. Some Popular Approaches
    - Siri: map to known entities and use existing databases (Knowledge-Based)
    - ask.com: detect question type and use a search engine's results
        - Question processing, detect question type
        - Passage Retrieval
        - Answer Processing
    - IBM’s Watson: combine (a) and (b)
    - Google's Knowledge Graph: entity-relationship graph
3. Typical QA pipeline
4. AskMSR Details
    - Step 1: Rewrite Queries
        - Transform
        - Datatype
    - Step 2: Query Search Engine
        - Retrieve top N answers
        - Snippets
    - Step 3: Mining N-Grams
        - Occurrence count
    - Step 4: Filtering N-Grams: filter data type
    - Step 5: Tiling the Answers

 
# Classification

1. What is classification: assign labels to each documents or web-pages
2. Understand the difference between clustering and classification (discussed in clustering)
3. Classification Using Vector Spaces
    - Premise 1: Contiguity Hypothesis: Documents in the same class form a contiguous region of space
    - Premise 2: Documents from different classes don’t overlap (much)
4. Classification methods
    - Manual classification
    - Rocchio Classification
    - kNN – k Nearest Neighbor Method
5. Rocchio Classification Algoithm
    - For relevance feedback, determine two classes: relevant and non-relevant
    - Rocchio Algorithm
        - Train
            - Input: initial class ids in C and set of documents in D
            - Output: centroid for each Dj
        - Apply
            - Input: centroid of each Dj and a document d
            - Output: the target centroid that d belongs to that cluster
    - Classes in Rocchio classification for relevance will have the approximate shape of spheres with similar radii.
    - Another decision rule is used
        - Assign d to class c iff |μ ⃗(c)-v ⃗(d)|<|μ ⃗(c)-v ⃗(d)|-b
6. kNN - k Nearest Neighbor Method
    - basic idea: pick the k nearest document given a document and account for the occurrence and choose the largest one as the cluster.
    - KNN algorithm
        - Training phase: storing features and labels of the training samples
        - Classification phase: an unlabeled vector is classified by assigning the label which is most frequent among the k training samples nearest to the query
    - Chose of K depends upon data:
    - Larger K: reduce the effect of noise but make boundaries less distinct
        - Non-linear classifier (compared with Rocchio, which is linear)
7. Features of KNN
    - No feature selection necessary
    - No training necessary
    - Scales well with large number of classes
    - Classes can influence each other
    - In most cases it’s more accurate than Rocchi
8. Voroni Diagram
    - partitioning of a plane into regions based on distance to points in a specific subset of the plane
    - 1NN  

# Click Fraud

1. Some terms
    - Click thru: when a viewer clicks on an ad
    - CTR: click through rate
    - CPM: click per thousand
2. Two basic problems
    - good click-through rates (CTRs) are still not indicative of good conversion rates
    - It does not offer any “built-in” fundamental protection mechanisms against click fraud
3. Invalid clicks (click fraud)
    - Def: a person, automated script or computer program imitates a legitimate user of a web browser clicking on an ad
    - Click id valid if it leads to a purchase or subscription
    - Not possible to distinguish all the invalid click
4. 7 ways that click fraud may be done
    - Automated clicking programs or software applications
    - Employing low-cost workers to click on the ads
    - Website publishers manually clicking on the ads
    - Website manipulating web pages in such a way that interaction with ad clicking
    - Website publishers subscribing to paid traffic websites that artificially bring extra traffic to the site
    - Advertisers manually clicking on the ads of their competitors
    - Website publishers being sabotaged by their competitors or other ill-wishers
5. Google’s View of Click Fraud (4 layers)
    - 1st layer for both search and AdSense partner
    - 2nd layer remove invalid clicks from the AdSense system.
    - 3rd layer: manually review
    - 4th layer: detailed investigation
6. What to look for anomalous behaviors
    - Keyword performance
    - number of clicks from the same IP address
    - Decline in the number of conversions (click -> purchase)
    - Large numbers of visitors who leave your site quickly
    - Large number of impressions, without clicks on ad
    - high clicks and impressions on affiliate websites
    - clicks coming from countries outside of your normal market area
    - Accidental click fraud
7. Botnet attack
    - Bots, Botmaster, command and control server
    - DDos, Information leakage, click fraud, phishing mail, etc.
8. Google reports
    - Clicking and billing activities
    - Smallest unit is one day
    - Advertisers don’t know a click is valid or not
9. Recall the calculation of precision and recall.

 
# Legal Issues for search Engines

1. Intellectual property protections Categories:
    - Copyright
        - Automatically when work is created
        - No need for © or All Rights Reserved
        - term of copyright protection is the length of the author’s life plus fifty years.
    - Patents
        - Must be registered
        - Owner has rights to exclude all others from making, using, selling, or importing the invention.
        - 20 years for most patents.
    - Trademarks
        - Legally registered as representing a company or product
        - USPTO
    - Trade secrets
        - confidential information
2. Not allowed to provide links to
    - Pornographic/child pornographic/ Revenge porn
    - Nazi, white supremacist, racist
    - damaging or libelous individuals
3. A Search Engine Can Sell Ads on Trademarked Terms
