//
//  LapTime.swift
//  KartingCoach
//
//  Created by Jakub Olejník on 01/09/2017.
//

import Foundation

struct LapTime: Codable {
    static var zero: LapTime { return LapTime(duration: 0) }
    
    var minutes: Int { return duration / 1000 / 60 }
    var seconds: Int { return duration / 1000 % 60 }
    var miliseconds: Int { return duration % 1000 }
    
    let duration: Int
}

extension LapTime {
    init(minutes: Int, seconds: Int, miliseconds: Int) {
        self.init(duration: minutes * 60 * 1000 + seconds * 1000 + miliseconds)
    }
    
    init?(string: String) {
        if let int = Int(string) {
            self.init(duration: int)
        } else {
            var components = string.trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: CharacterSet(charactersIn: ".:"))
                .compactMap { Int($0) }
            
            if components.isEmpty { return nil }
            
            var duration = components.last ?? 0
            components.removeLast()
            
            if components.isEmpty {
                self.init(duration: duration)
                return
            }
            
            duration += components.last.flatMap { $0 * 1000 } ?? 0
            components.removeLast()
            
            if components.isEmpty {
                self.init(duration: duration)
                return
            }
            
            duration += components.last.flatMap { $0 * 1000 * 60 } ?? 0
            
            if duration > 0 {
                self.init(duration: duration)
            } else {
                return nil
            }
        }
    }
}

extension LapTime: CustomStringConvertible {
    var description: String {
        let secondsAndMiliseconds = String(format: "%02d", seconds) + "." + String(format: "%03d", miliseconds)
        return minutes > 0 ? String(minutes) + ":" + secondsAndMiliseconds : secondsAndMiliseconds
    }
}

extension LapTime: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self)"
    }
}

extension LapTime: Comparable {
    static func < (lhs: LapTime, rhs: LapTime) -> Bool {
        return lhs.duration < rhs.duration
    }
    
    static func == (lhs: LapTime, rhs: LapTime) -> Bool {
        return lhs.duration == rhs.duration
    }
}

func + (lhs: LapTime, rhs: LapTime) -> LapTime {
    return LapTime(duration: lhs.duration + rhs.duration)
}

func / (lhs: LapTime, rhs: Int) -> LapTime {
    return LapTime(duration: lhs.duration / rhs)
}

extension Collection where Iterator.Element == LapTime {
    func average() -> Iterator.Element? {
        if isEmpty { return nil }
        return reduce(.zero, +) / Int(count)
    }
}

