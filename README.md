#  Trying Core Data in MV Pattern with SwiftUI

## Description
This project demonstrates how to integrate Core Data into a SwiftUI application using the Model-View (MV) architectural pattern. The application allows users to create, read, update, and delete (CRUD) items stored in a Core Data persistent store. This example focuses also demonstrates how to use one-to-many relationships and many-to-one relationships in Core Data.

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

## Core Data Notes

1. Fetching Data with no Sort Descriptors:
```swift
@FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
```

2. Fetching Data with Sort Descriptors:
```swift
@FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated, order: .reverse)])
private var categories: FetchedResults<BudgetCategory>
```

3. Creating a new entity:
```swift
let newItem = CoreDataItem(context: viewContext)
newItem.attributes = value
do {
    try viewContext.save()
} catch {
    // Handle the error
}
```

4. Deleting an entity:
```swift
let itemToDelete = items[index]
viewContext.delete(itemToDelete)
do {
    try viewContext.save()
} catch {
    // Handle the error
}
```

5. Updating an entity:
```swift
let itemToUpdate = items[index]
itemToUpdate.attributes = newValue
do {
    try viewContext.save()
} catch {
    // Handle the error
}
```

6. Relationships:
```swift
// Assuming a one-to-many relationship between Category and Transaction
let category = BudgetCategory(context: viewContext)
category.title = "Sample Category"
category.total = 100.0
let transaction = Transaction(context: viewContext)
transaction.title = "Sample Transaction"
transaction.total = 50.0
category.addToTransactions(transaction) // Add transaction to category's transactions set
do {
    try viewContext.save()
} catch {
    // Handle the error
}
```

7. Fetching related entities:
```swift
// Typecast transactions from NSSet to [Transaction]
// Not the best approach because you're casting it every time you need to access transactions and changes to the transactions of a category won't be automatically reflected in the UI
 
let category = categories[index]
let transactions = category.transactions?.allObjects as? [Transaction] ?? []
// or let transactions = Array(category.transactions as? Set<Transaction> ?? [])

// Better approach is to use a separate FetchRequest for transactions filtered by the selected category

init(category: BudgetCategory) {
    self.category = category
    // Fetch transactions related to the selected category using a predicate and setting it to the FetchRequest using _transactions (_ is used to access the property wrapper directly and set its value, if we don't use _ we would be accessing the wrapped value)
    _transactions = FetchRequest(sortDescriptors: [],
        predicate: NSPredicate(format: "category == %@", category)
    )
}
```

8. Filling many-to-many relationships using NSSet:
```swift
let selectedTags: Set<Tag> = [...] // Your set of selected Tag objects 
let newTransaction = Transaction(context: viewContext)

newTransaction.title = "Sample Transaction"
newTransaction.tags = selectedTags as NSSet
do {
    try viewContext.save()
} catch {
    // Handle the error
}
```


9. Filtering with String predicates:
```swift
// Assuming you have a list of tags and you want to fetch transactions that have any of those tags
var filteredTransactions: [Transaction] = []
let tags: [Tag] = [...] // Your array of Tag objects

// Extract titles from tags
let tagTitles = tags.compactMap { $0.title }

// Create a fetch request with a predicate to filter transactions based on tag titles
let fetchRequest = Transaction.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "ANY tags.title IN %@", tagTitles)

do {
    // Execute the fetch request
    filteredTransactions = try viewContext.fetch(fetchRequest)
    print("Filtered Transactions: \(filteredTransactions)")
} catch {
    print("Error fetching filtered transactions: \(error)")
}
```

10. Filtering by number range:
```swift
let minAmount: Double = 50.0
let maxAmount: Double = 200.0

let fetchRequest = Transaction.fetchRequest()
// fetchRequest.predicate = NSPredicate(format: "total >= %@ AND total <= %@", NSNumber(value: minAmount), NSNumber(value: maxAmount))
fetchRequest.predicate = NSPredicate(format: "total >= %f AND total <= %f", minAmount, maxAmount)
do {
    let filteredTransactions = try viewContext.fetch(fetchRequest)
    print("Filtered Transactions: \(filteredTransactions)")
} catch {
    print("Error fetching filtered transactions: \(error)")
}
```

11. Filter by string containment:
```swift
let titleKeyword: String = "Sample"
let fetchRequest = Transaction.fetchRequest()

// CONTAINS[c] is case insensitive with [c] meaning case insensitive
// for case sensitive use CONTAINS without [c]
fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", titleKeyword)

do {
    let filteredTransactions = try viewContext.fetch(fetchRequest)
    print("Filtered Transactions: \(filteredTransactions)")
} catch {
    print("Error fetching filtered transactions: \(error)")
}
```

12. Compound predicates:
```swift
let minAmount: Double = 50.0
let maxAmount: Double = 200.0
let startDate: Date = ... // Your start date
let endDate: Date = ... // Your end date
let titleKeyword: String = "Sample"

let amountPredicate = NSPredicate(format: "total >= %f AND total <= %f", minAmount, maxAmount)
let datePredicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", titleKeyword)

let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [amountPredicate, datePredicate, titlePredicate])
let fetchRequest = Transaction.fetchRequest()
fetchRequest.predicate = compoundPredicate
do {
    let filteredTransactions = try viewContext.fetch(fetchRequest)
    print("Filtered Transactions: \(filteredTransactions)")
} catch {
    print("Error fetching filtered transactions: \(error)")
}
```
