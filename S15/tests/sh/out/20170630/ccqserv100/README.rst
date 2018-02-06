Platform
========

ccqserv100-124

Operating system
================

CentOS 7.3

Node
====

16 cores, 16 GB  per node
25 worker nodes enabled

Storage
=======

Local storage for each node

Misc
====

- Statictics updated, and taken in account in my.cnf
- Bugfixes added (DM-10525)
- 2nd join query is slow

Orchestrator
============

Kubernetes 1.5.2
Docker 1.12.3 (using LimitMEMLOCK ~10GB)
