//
//  PlanAndBookActivityGridView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/12/25.
//

import SwiftUI
import VVUIKit

struct PlanAndBookActivityGridView: View {
    let activities: [VoyageActivitiesSection.VoyageActivityItem]
    let spacing: CGFloat = 8
    let didSelectGridItem: (VoyageActivitiesSection.VoyageActivityItem) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: spacing) {
            // Process rows of content
            ForEach(0..<getRowCount(), id: \.self) { rowIndex in
                createRow(for: rowIndex)
            }
        }
        
    }
    
    // Calculate how many rows we need
    private func getRowCount() -> Int {
        var rowCount = 0
        var index = 0
        
        while index < activities.count {
            if activities[index].layoutType == .full {
                // Full items take a whole row
                rowCount += 1
                index += 1
            } else if index + 1 < activities.count && activities[index + 1].layoutType == .square {
                // Two square items take a row
                rowCount += 1
                index += 2
            } else {
                // Single square item takes a row
                rowCount += 1
                index += 1
            }
        }
        
        return rowCount
    }
    
    // Create row content based on index
    @ViewBuilder
    private func createRow(for rowIndex: Int) -> some View {
        let indices = getItemIndices(for: rowIndex)
        let constantHeightForFullItem: CGFloat = 140
        let constantHaightForSquareItem: CGFloat = 160
        
        if indices.count == 1 {
            // Either a full item or a single square item
            let item = activities[indices[0]]
            
            if item.layoutType == .full {
                // Full width item
                Button {
                    didSelectGridItem(item)
                } label: {
                    PlanAndBookActivityView(item: item)
                        .frame(height: constantHeightForFullItem)
                }
            } else {
                // Single square item
                Button {
                    didSelectGridItem(item)
                } label: {
                    PlanAndBookActivityView(item: item)
                        .frame(width: UIScreen.main.bounds.width / 2 - 16,
                               height: constantHaightForSquareItem)
                }
            }
        } else if indices.count == 2 {
            // Two square items
            HStack(spacing: spacing) {
                let item = activities[indices[0]]
                Button {
                    didSelectGridItem(item)
                } label: {
                    PlanAndBookActivityView(item: item)
                        .frame(height: constantHaightForSquareItem)
                }

                let item2 = activities[indices[1]]
                Button {
                    didSelectGridItem(item2)
                } label: {
                    PlanAndBookActivityView(item: item2)
                        .frame(height: constantHaightForSquareItem)
                }
            }
        }
    }
    
    // Map row index to item indices
    private func getItemIndices(for rowIndex: Int) -> [Int] {
        var currentRow = 0
        var index = 0
        
        while currentRow < rowIndex && index < activities.count {
            if activities[index].layoutType == .full {
                currentRow += 1
                index += 1
            } else if index + 1 < activities.count && activities[index + 1].layoutType == .square {
                currentRow += 1
                index += 2
            } else {
                currentRow += 1
                index += 1
            }
        }
        
        // Now we're at the start of the target row
        if index >= activities.count {
            return []
        }
        
        if activities[index].layoutType == .full {
            return [index]
        } else if index + 1 < activities.count && activities[index + 1].layoutType == .square {
            return [index, index + 1]
        } else {
            return [index]
        }
    }
}

#Preview {
    
    let dummyActivities = [
        VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                name: "Book a Restaurant",
                                code: "",
                                bookableType: .eatery,
                                layoutType: .square),
        VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                name: "Book an Event",
                                code: "",
                                bookableType: .eatery,
                                layoutType: .square),
        VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                name: "Purchase Add-ons",
                                code: "",
                                bookableType: .eatery,
                                layoutType: .full),
        VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                name: "Book an Event",
                                code: "",
                                bookableType: .eatery,
                                layoutType: .square),
        VoyageActivitiesSection.VoyageActivityItem(imageUrl: "",
                                name: "Purchase Add-ons",
                                code: "",
                                bookableType: .eatery,
                                layoutType: .full)
    ]
    
    ScrollView {
        PlanAndBookActivityGridView(activities: dummyActivities, didSelectGridItem: { _ in })
            .padding(.horizontal, Spacing.space16)
    }
}
