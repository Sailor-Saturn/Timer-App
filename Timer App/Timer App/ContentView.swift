//
//  ContentView.swift
//  Timer App
//
//  Created by Vera Dias on 08/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State var timeLabel: String = "00:00:00"
    @State var timerCounting: Bool = false
    @State var startTime: Date?
    @State var stopTime: Date?
    
    @State var scheduledTimer: Timer?
    
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        ZStack (alignment: .top){
            VStack() {
                Text(timeLabel).font(.largeTitle)
                HStack(spacing: 16) {
                    Button(action: startStopAction, label: {
                        Text(timerCounting ? "Stop" : "Start")
                            .font(.title)
                            .tint(timerCounting ? .red : .green)
                    })
                    Button(action: resetAction, label: {
                        Text("Reset")
                            .font(.title)
                    })
                }
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .onAppear {
            self.timerCounting = userDefaults.bool(forKey: .COUNTING_KEY)
            self.startTime = userDefaults.object(forKey: .START_TIME_KEY) as? Date
            self.stopTime = userDefaults.object(forKey: .STOP_TIME_KEY) as? Date
            
            if timerCounting {
                setStopTime(date: Date())
                stopTimer()
            } else {
                stopTimer()
                if let startTime = startTime {
                    if let stopTime = stopTime {
                        let diff = startTime.timeIntervalSince(stopTime)
                        let restartTime = Date().addingTimeInterval(diff)
                        let final = Date().timeIntervalSince(restartTime)
                        let time = Int(final)
                        let hour = time/3600
                        let min = (time % 3600) / 60
                        let sec = (time % 3600) % 60
                        
                        
                        timeLabel = String(format: "%02d: %02d: %02d", hour, min, sec)
                    }
                }
            }
        }
    }
    
    func startStopAction() {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        } else {
            if let stop = stopTime, let start = startTime {
                let diff = start.timeIntervalSince(stop)
                let restartTime = Date().addingTimeInterval(diff)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else {
                setStartTime(date: Date())
            }
            
            startTimer()
        }
    }
    
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            refreshValue()
        })
        setTimerCounting(true)
        
    }
    
    func refreshValue() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            
            let time = Int(diff)
            let hour = time/3600
            let min = (time % 3600) / 60
            let sec = (time % 3600) % 60
            
            
            timeLabel = String(format: "%02d:%02d:%02d", hour, min, sec)
        } else {
            stopTimer()
            timeLabel = "00:00:00"
        }
    }
    
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer?.invalidate()
        }
        setTimerCounting(false)
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(date, forKey: .START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(date, forKey: .STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ isCounting: Bool) {
        timerCounting = isCounting
        userDefaults.set(isCounting, forKey: .COUNTING_KEY)
    }
        
    func resetAction() {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timeLabel = "00:00:00"
    }
}

extension String {
    static let START_TIME_KEY = "startTime"
    static let STOP_TIME_KEY = "stopTime"
    static let COUNTING_KEY = "countingKey"
}

#Preview {
    ContentView()
}
