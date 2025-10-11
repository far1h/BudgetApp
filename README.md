#  Trying Core Data in MV Pattern with SwiftUI

## Description
This project demonstrates how to integrate Core Data into a SwiftUI application using the Model-View (MV) architectural pattern. The application allows users to create, read, update, and delete (CRUD) items stored in a Core Data persistent store.

Steps taken to implement:
1. Add Core Data model named `BudgetModel` and create an entity named `BudgetCategory` with attributes `title` (Non-optional String), `total` (Non-optional Double), `dateCreated` (Non-optional Date). 
2. Set Class Codegen to `Category/Extension`. By default it is set to `Class Definition` where Xcode generates the class automatically. But in this case, we want to create our own class file for better control and customization over the entity's behavior and properties.
3. Create a BudgetCategory class conformed to `NSManagedObject` with @objc(BudgetCategory) to ensure compatibility with Objective-C runtime. `dateCreated` is initialized with the current date in the awakeFromInsert method so when a new instance is created, it automatically gets the current date.
4. Create a CoreDataManager class to handle Core Data stack setup and provide methods for saving the context.
5. Inject the managed object context into the SwiftUI environment using @Environment(\.managedObjectContext). 
6. When creating a new BudgetCategory instance, we use the context to insert it into the Core Data stack and save the changes using save() method of CoreDataManager.
7. Fetch BudgetCategory entities using @FetchRequest property wrapper to display them in a list.
8. Implement delete functionality to remove BudgetCategory entities from Core Data. This involves deleting the object from the context and saving the changes.
9. Add `Transaction` entity with attributes `title` (Non-optional String), `total` (Non-optional Double), `dateCreated` (Non-optional Date), and a one to many relationship to `BudgetCategory`. For each BudgetCategory, there can be multiple Transactions, but each Transaction belongs to one BudgetCategory. 
