//
//  ContentView.swift
//  AdivinheABandeira
//
//  Created by Rodrigo Cavalcanti on 05/10/20.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correcftAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var scoreCorretas = 0
    @State private var scoreTotal = 1
    
    @State private var wrongMessage = ""
    @State private var okMessage = ""
    
    @State private var botãoEscolhido = [false, false, false]
    @State private var respostaCorreta = false
    @State private var opacidade = [1.0, 1.0, 1.0]
    
    func FlagView(iterator: Int) -> some View {
        Image(self.countries[iterator])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 2))
            .shadow(color: .black, radius: 5)
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 30) {
                VStack {
                    Text("Select the flag of")
                        .foregroundColor(.black)
                    Text(countries[correcftAnswer])
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                        opacidade = [0.25,0.25,0.25]
                        self.flagtapped(number)
                        }
                    }) {
                        FlagView(iterator: number)
                            .rotation3DEffect(.degrees(botãoEscolhido[number] && respostaCorreta ? 360: 0), axis: (x: 0, y: 1, z: 0))
                            
                            .rotation3DEffect(.degrees(botãoEscolhido[number] && !respostaCorreta ? 360: 0), axis: (x: 1, y: 0, z: 0))
                            
                            .opacity(opacidade[number])
                    }
                }
                VStack {
                    Text("Your score is:")
                    Text("\(scoreCorretas)/\(scoreTotal)")
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(Color.black)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("\(wrongMessage)Your score is \(scoreCorretas)/\(scoreTotal)"), dismissButton: .default(Text(okMessage)) {
                    self.askQuestion()
                })
        }
    }
    func flagtapped(_ number: Int) {
        if number == correcftAnswer {
            scoreTitle = "Correct"
            scoreCorretas += 1
            okMessage = "Continue"
            respostaCorreta = true
            opacidade[number] = 1
        } else {
            scoreTitle = "Wrong"
            wrongMessage = "That's the flag of \(countries[number]) \n"
            okMessage = "Try again"
            respostaCorreta = false
        }
        showingScore = true
        botãoEscolhido[number] = true
    }
    func askQuestion() {
        wrongMessage = ""
        scoreTotal += 1
        countries.shuffle()
        correcftAnswer = Int.random(in: 0...2)
        botãoEscolhido = [false, false, false]
        respostaCorreta = false
        withAnimation(.default) {
            opacidade = [1,1,1]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
