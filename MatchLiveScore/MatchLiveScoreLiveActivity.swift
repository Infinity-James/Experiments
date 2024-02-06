//
//  MatchLiveScoreLiveActivity.swift
//  MatchLiveScore
//
//  Created by James Valaitis on 18/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MatchLiveScoreLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchLiveScoreAttributes.self) { context in
            lockScreenBanner(context)
        } dynamicIsland: { context in
            dynamicIsland(context)
        }
    }
    
    @ViewBuilder
    private func lockScreenBanner(_ context: ActivityViewContext<MatchLiveScoreAttributes>) -> some View {
        VStack {
            context.attributes.formattedDate
                .font(.caption2)
                .padding(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { Color.yellow }
            
            HStack {
                Spacer()
                HStack {
                    Text(context.attributes.homeTeam)
                        .font(.body)
                    Text("\(context.state.homeTeamScore)")
                        .font(.headline)
                }
                Text(" – ")
                HStack {
                    Text(context.attributes.awayTeam)
                        .font(.body)
                    Text("\(context.state.awayTeamScore)")
                        .font(.headline)
                }
                Spacer()
            }
            
            Text(context.state.lastEvent)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { Color.mint }
        }
        .foregroundStyle(.primary)
        .activityBackgroundTint(.secondary)
        .activitySystemActionForegroundColor(.primary)
    }
    
    private func dynamicIsland(_ context: ActivityViewContext<MatchLiveScoreAttributes>) -> DynamicIsland {
        DynamicIsland {
            expandedDynamicIsland(context)
        } compactLeading: {
            Text("\(context.attributes.homeTeam) \(context.state.homeTeamScore)")
                .foregroundStyle(.primary)
        } compactTrailing: {
            Text("\(context.attributes.awayTeam) \(context.state.awayTeamScore)")
                .foregroundStyle(.primary)
        } minimal: {
            Text("⚽️")
                .foregroundStyle(.primary)
        }
        .widgetURL(URL(string: "http://marginalrevolution.com"))
        .keylineTint(Color.red)
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedDynamicIsland(_ context: ActivityViewContext<MatchLiveScoreAttributes>) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            Text("\(context.attributes.homeTeam) \(context.state.homeTeamScore)")
                .foregroundStyle(.primary)
        }
        DynamicIslandExpandedRegion(.trailing) {
            Text("\(context.attributes.awayTeam) \(context.state.awayTeamScore)")
                .foregroundStyle(.primary)
        }
        DynamicIslandExpandedRegion(.bottom) {
            Text(context.state.lastEvent)
                .foregroundStyle(.primary)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { RoundedRectangle(cornerRadius: 4).fill(Color.mint) }
            context.attributes.formattedDate
                .foregroundStyle(.primary)
        }
    }
}

extension MatchLiveScoreAttributes {
    fileprivate var formattedDate: Text {
        Text("\(date, format: .dateTime)")
    }
}

extension MatchLiveScoreAttributes {
    fileprivate static var preview: MatchLiveScoreAttributes {
        MatchLiveScoreAttributes(homeTeam: "Tottenham Hotspur", awayTeam: "Arsenal", date: .now)
    }
}

extension MatchLiveScoreAttributes.ContentState {
    fileprivate static var destroyingThem: MatchLiveScoreAttributes.ContentState {
        MatchLiveScoreAttributes.ContentState(homeTeamScore: 5, awayTeamScore: 0, lastEvent: "Bentacur Goal 67'")
     }
     
     fileprivate static var tense: MatchLiveScoreAttributes.ContentState {
         MatchLiveScoreAttributes.ContentState(homeTeamScore: 3, awayTeamScore: 2, lastEvent: "Saka Goal 41'")
     }
}

#Preview("Lock Screen", as: .content, using: MatchLiveScoreAttributes.preview) {
   MatchLiveScoreLiveActivity()
} contentStates: {
    MatchLiveScoreAttributes.ContentState.destroyingThem
    MatchLiveScoreAttributes.ContentState.tense
}

#Preview("Island Compact", as: .dynamicIsland(.compact), using: MatchLiveScoreAttributes.preview) {
   MatchLiveScoreLiveActivity()
} contentStates: {
    MatchLiveScoreAttributes.ContentState.destroyingThem
    MatchLiveScoreAttributes.ContentState.tense
}

#Preview("Island Expanded", as: .dynamicIsland(.expanded), using: MatchLiveScoreAttributes.preview) {
   MatchLiveScoreLiveActivity()
} contentStates: {
    MatchLiveScoreAttributes.ContentState.destroyingThem
    MatchLiveScoreAttributes.ContentState.tense
}

#Preview("Island Minimal", as: .dynamicIsland(.minimal), using: MatchLiveScoreAttributes.preview) {
   MatchLiveScoreLiveActivity()
} contentStates: {
    MatchLiveScoreAttributes.ContentState.destroyingThem
    MatchLiveScoreAttributes.ContentState.tense
}
