//
//  PokeArena.swift
//  Pokeproyecto
//
//  Created by Iris Jasso on 20/04/25.
//

import SwiftUI

struct PokeArena: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()

                Text("PokeArena")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                VStack(spacing: 20) {
                    NavigationLink(destination: ContentView()) {
                        Text("Entrar a Pokédex")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }

                    NavigationLink(destination: BattleView()) {
                        Text("Iniciar Batalla")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}



#Preview {
    PokeArena()
}

