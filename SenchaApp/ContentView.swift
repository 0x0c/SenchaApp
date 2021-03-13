//
//  ContentView.swift
//  SenchaApp
//
//  Created by Akira Matsuda on 2021/03/13.
//

import Combine
import SFSafeSymbols
import SwiftUI

class TimerState: ObservableObject {
    @Published var isTimerDone: Bool = false
    @Published var isFlipped: Bool = false

    func reset() {
        isTimerDone = false
        isFlipped = false
    }
}

class BrewState: ObservableObject {
    @Published var firstBrew = TimerState()
    @Published var secondBrew = TimerState()
    @Published var thirdBrew = TimerState()
    private var cancellable = [AnyCancellable]()

    init() {
        cancellable.append(firstBrew.objectWillChange.sink(receiveValue: { [weak self] in
            self?.objectWillChange.send()
        }))
        cancellable.append(secondBrew.objectWillChange.sink(receiveValue: { [weak self] in
            self?.objectWillChange.send()
        }))
        cancellable.append(thirdBrew.objectWillChange.sink(receiveValue: { [weak self] in
            self?.objectWillChange.send()
        }))
    }

    func reset() {
        firstBrew.reset()
        secondBrew.reset()
        thirdBrew.reset()
    }
}

struct ContentView: View {
    @ObservedObject var state = BrewState()
    @State private var opacity: Double = 0
    @State private var amountOfTeaLeaf: Int = 4

    var body: some View {
        VStack(alignment: .center, spacing: 8, content: {
            VStack {
                HStack {
                    Text("茶葉").bold().font(.title3)
                    Text("\(Int(amountOfTeaLeaf))g")
                    Stepper(value: $amountOfTeaLeaf, in: 0 ... 40, label: {}).labelsHidden()
                }
                HStack {
                    Text("湯の量").bold().font(.title3)
                    Text("\(Int(120 * amountOfTeaLeaf / 4))ml")
                }
            }.padding()

            Divider()

            TimerButton(
                seconds: 80,
                index: .first,
                state: state.firstBrew
            )
            .frame(width: 100, height: 100, alignment: .center)
            .padding()
            .opacity(opacity)

            TimerButton(
                seconds: 10,
                index: .second,
                state: state.secondBrew
            )
            .disabled(!state.firstBrew.isTimerDone)
            .opacity(state.firstBrew.isTimerDone ? 1 : 0.5)
            .frame(width: 100, height: 100, alignment: .center)
            .padding()
            .opacity(opacity)

            TimerButton(
                seconds: 15,
                index: .third,
                state: state.thirdBrew
            ).disabled(!state.secondBrew.isTimerDone)
                .opacity(state.secondBrew.isTimerDone ? 1 : 0.5)
                .frame(width: 100, height: 100, alignment: .center)
                .padding()
                .opacity(opacity)

            Button(action: {
                state.reset()
                opacity = 0
                withAnimation(.linear(duration: 0.3)) {
                    self.opacity = 1.0
                }
            }, label: {
                HStack {
                    Image(systemSymbol: .arrowCounterclockwise)
                    Text("リセット")
                        .font(.caption)
                }.frame(
                    maxWidth: .infinity,
                    maxHeight: 20,
                    alignment: .center
                ).padding([.top, .bottom])
            })
                .frame(width: 200)
                .foregroundColor(.blue)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding()
        })
            .padding()
            .onAppear(perform: {
                withAnimation(.linear(duration: 0.3)) {
                    self.opacity = 1.0
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
