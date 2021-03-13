//
//  TimerButton.swift
//  SenchaApp
//
//  Created by Akira Matsuda on 2021/03/14.
//

import AVFoundation
import SwiftUI
import UICircularProgressRing

enum BrewIndex: String {
    case first = "一煎目"
    case second = "二煎目"
    case third = "三煎目"

    var temperature: Int {
        switch self {
        case .first:
            return 70
        case .second:
            return 80
        case .third:
            return 85
        }
    }

    var color: Color {
        switch self {
        case .first:
            return .init(red: 211 / 256, green: 196 / 256, blue: 120 / 256)
        case .second:
            return .init(red: 87 / 256, green: 87 / 256, blue: 67 / 256)
        case .third:
            return .init(red: 142 / 256, green: 142 / 256, blue: 75 / 256)
        }
    }
}

var audioPlayer: AVAudioPlayer?

struct TimerButton: View {
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()

    @State private var isTimerPaused: Bool = false
    @State private var opacity: Double = 0

    let seconds: TimeInterval
    let index: BrewIndex
    @ObservedObject var state: TimerState
    @State private var skipped = false

    private func playSound() {
        if skipped == false {
            if let url = Bundle.main.url(forResource: "Clock-Alarm01-1(Loop)", withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        audioPlayer?.stop()
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }

    var body: some View {
        if state.isTimerDone {
            ZStack {
                Circle()
                    .foregroundColor(index.color)
                    .opacity(0.8)
                Text("終了")
                    .foregroundColor(.white)
            }
            .opacity(opacity)
            .onAppear(perform: {
                withAnimation(.linear(duration: 0.3)) {
                    self.opacity = 1.0
                }
                playSound()
            })
        }
        else {
            ZStack {
                if state.isFlipped {
                    TimerRing(
                        time: .seconds(seconds),
                        outerRingStyle: .init(
                            color: .color(Color(white: 0.8)),
                            strokeStyle: .init(lineWidth: 30)
                        ),
                        innerRingStyle: .init(
                            color: .color(index.color),
                            strokeStyle: .init(lineWidth: 30)
                        ),
                        isPaused: $isTimerPaused,
                        isDone: $state.isTimerDone
                    ) { currentTime in
                        Text(TimerButton.timeFormatter.string(from: seconds - currentTime + 1) ?? "NaN")
                            .font(.body)
                            .bold()
                    }.rotation3DEffect(
                        Angle(degrees: 180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
                else {
                    ZStack {
                        Circle()
                            .foregroundColor(index.color)
                        VStack(alignment: .center, spacing: 8, content: {
                            Text(index.rawValue)
                                .font(.body)
                                .bold()
                                .foregroundColor(.white)
                            Text("\(index.temperature)℃")
                                .font(.caption)
                                .foregroundColor(.white)
                        })
                    }
                }
            }.rotation3DEffect(
                state.isFlipped ? Angle(degrees: 180) : Angle(degrees: 0),
                axis: (x: 0, y: 1, z: 0)
            ).animation(.default)
                .onTapGesture {
                    if state.isFlipped {
                        state.isTimerDone = true
                        skipped = true
                    }
                    else {
                        state.isFlipped.toggle()
                        opacity = 0
                        skipped = false
                    }
                }
        }
    }
}
