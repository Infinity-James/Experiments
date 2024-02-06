import ActivityKit
import Foundation

struct MatchLiveScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var lastEvent: String
    }
    
    let homeTeam: String
    let awayTeam: String
    let date: Date
}
