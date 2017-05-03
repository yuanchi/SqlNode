# SqlNode

SqlNode ueses tree-structure to compose SQL syntax.

SqlNode focuses on query operation currently.

Its main feature is that it can configure and output results accordingly at different points.

My hope is to design a developer-friendly fluent API to represent and manipulate SQL.

Each componet(node) within SqlNode can be used individually, also copied or embeded into another SqlNode.

Many real world applications are composed of a lot of database access, so I want to propse a idea: the business logic is database operations to simplify the popular framework.

SQL has its rules and every database has different degree of support, but applications mostly need the flexibility and reusability. Reducing the gap is my goal here.


TODO...
