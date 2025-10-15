//
//  TagsView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 15/10/2025.
//

import SwiftUI

struct TagsView: View {
    
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @Binding var selectedTags: Set<Tag>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags) { tag in
                    Text(tag.title ?? "No Title")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedTags.contains(tag) ? Color.blue.opacity(0.2)
                                    : Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                }
            }
        }
    }
}


struct TagsViewContainer: View {
    
    @State var selectedTags: Set<Tag> = []
    
     var body: some View {
        TagsView(selectedTags: $selectedTags)
            .environment(\.managedObjectContext, CoreDataManager.preview.context)

    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsViewContainer()
    }
}


