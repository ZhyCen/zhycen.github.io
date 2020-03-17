---
title: RESTful API
tags: RESTful
categories: Full-Stack
date: 2018-02-27 21:20:55
---



REST = REpresentational State Transfer.
REST API is resource based rather than action based.

# Constrains for REST Architecture

## Client-Server
RESTful architecture is a client-server architecture. A client won't always have direct connections with the server, assets or resources.

## Uniform Interface
using noun as the resources and using http verbs as the actions on the resources.

Here are frequently used **HTTP Requests**:

**GET**
    Read a specific resource (by an identifier) or a collection of resources.

**POST**
    Create a new resource. Also a catch-all verb for operations that don't fit into the other categories.

**PUT**
    Update a specific resource (by an identifier) or a collection of resources. Can also be used to create a specific resource if the resource identifier is known before-hand.

**DELETE**
    Remove/delete a specific resource by an identifier.

## Stateless
the server contains no client states, which means, each request has enough

## Cacheable
Server responses or representations are cacheable. So the response must implicitly or explicitly define themselves as cacheable.

## Layered System
