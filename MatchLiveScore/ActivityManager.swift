//
//  ActivityManager.swift
//  Experimentation
//
//  Created by James Valaitis on 05/02/2024.
//

import ActivityKit
import Combine
import Foundation

public final class ActivityManager: ObservableObject {
    @MainActor
    @Published public private(set) var activityID: String?
    @MainActor
    @Published public private(set) var activityToken: String?
    
    public init() { }
    
    public func start() async {
        await endLiveActivity()
        await startNewLiveActivity()
    }
    
    public func end() async {
        await endLiveActivity()
    }
    
    public func cancel() async {
        for activity in Activity<MatchLiveScoreAttributes>.activities {
            await activity.end(.init(state: initialState, staleDate: .now), dismissalPolicy: .immediate)
        }
        
        await MainActor.run {
            activityID = nil
            activityToken = nil
        }
    }
    
    public func testActivityUpdate() async {
        guard let currentActivity = await currentActivity() else {
            return
        }
        let newState = MatchLiveScoreAttributes.ContentState(homeTeamScore: Int.random(in: 1...9), awayTeamScore: Int.random(in: 1...9), lastEvent: "No way!")
        await currentActivity.update(.init(state: newState, staleDate: nil))
    }
}

private extension ActivityManager {
    var initialState: MatchLiveScoreAttributes.ContentState { MatchLiveScoreAttributes.ContentState(homeTeamScore: 0, awayTeamScore: 0, lastEvent: "Kick off") }
    func currentActivity() async -> Activity<MatchLiveScoreAttributes>? {
        guard let activityID = await activityID,
              let runningActivity = Activity<MatchLiveScoreAttributes>.activities.first(where: { $0.id == activityID }) else {
            return nil
        }
        return runningActivity
    }
    
    func startNewLiveActivity() async {
        let attributes = MatchLiveScoreAttributes(homeTeam: "Tottenham Hotspur", awayTeam: "Brighton and Hove Albion", date: .now.addingTimeInterval(60*60*24*7))
        let initialState = ActivityContent(state: initialState, staleDate: nil)
        do {
            let activity = try Activity.request(attributes: attributes, content: initialState, pushType: .token)
            await MainActor.run { activityID = activity.id }
            for await data in activity.pushTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                print("⚪️ ⚪️ ⚪️ ⚪️ ⚪️")
                print("Activity token: \(token)")
                await MainActor.run { activityToken = token }
                //  TODO: send token to the server
            }
        } catch {
            print("Error occurred: \(error)")
        }
    }
    
    func endLiveActivity() async {
        guard let currentActivity = await currentActivity() else {
            return
        }
        await currentActivity.end(.init(state: initialState, staleDate: .distantFuture), dismissalPolicy: .immediate)
        await MainActor.run {
            activityID = nil
            activityToken = nil
        }
    }
}
