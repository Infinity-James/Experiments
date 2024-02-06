//
//  TestingLiveActivity.swift
//  Experimentation
//
//  Created by James Valaitis on 05/02/2024.
//

import SwiftUI

struct TestingLiveActivity: View {
    @StateObject private var activityManager = ActivityManager()
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Activity ID:")
                    .font(.title3)
                Text("\(activityManager.activityID ?? "-")")
                    .font(.caption2)
                Text("Activity Token:")
                    .font(.title3)
                Text("\(activityManager.activityToken ?? "-")")
                    .font(.caption2)
            }
            Spacer()
            
            if (activityManager.activityID?.isEmpty == false) {
                VStack {
                    Button("UPDATE RANDOM SCORE FOR LIVE ACTIVITY") {
                        Task {
                            await activityManager.testActivityUpdate()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 70)
                }
                .background(Color.orange)
                .frame(maxWidth: .infinity)
                VStack {
                    Button("STOP LIVE ACTIVITY") {
                        Task {
                            await activityManager.cancel()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 70)
                }
                .background(Color.red)
                .frame(maxWidth: .infinity)
            }
            else {
                VStack {
                    Button("START LIVE ACTIVITY") {
                        Task {
                            await activityManager.start()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 70)
                }
                .background(Color.blue)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    TestingLiveActivity()
}
