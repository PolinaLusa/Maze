//
//  ContentView.swift
//  Maze
//
//  Created by Полина Лущевская on 27.06.24.
//

import SwiftUI

struct ContentView: View {
    @State private var isGameStarted = false
    
    var body: some View {
        VStack {
            if !isGameStarted {
                Text("Welcome to the Maze Game")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    isGameStarted = true
                }) {
                    Text("Start")
                        .padding()
                        .background(Color("Purply"))
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                MazeView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
