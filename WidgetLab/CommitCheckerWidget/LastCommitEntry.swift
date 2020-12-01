//
//  LastCommitEntry.swift
//  WidgetLab
//
//  Created by Егор on 15.10.2020.
//

import Foundation
import WidgetKit

struct LastCommitEntry : TimelineEntry{
    public let commit: Commit
    public let date: Date
    
    var relevance: TimelineEntryRelevance?{
        return TimelineEntryRelevance(score: 10)
    }
}
