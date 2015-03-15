# Introduction #

This page is the beginning of the Core Data code snippets.  The first one is a section of code that will facilitate migrating from one repository to another.

There are two classes contained in the snippet.

**ZDSMigrationHandler**

This class can actually be rolled into another object as the code contained in the files is self contained and does not require instantiation.

**ZDSManagedObject**

This object should be the parent of any objects that will be migrated.  If there is no concrete class then the ZDSManagedObject should be set as the object class in the object model.
