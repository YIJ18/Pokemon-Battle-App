import SwiftUI

struct BattleArenaView: View {
    var selectedPokemon: [PokemonEntry]
    var enemyPokemon: [PokemonEntry]
    
    @State private var rotation: Double = 0
    @State private var isSelecting = false
    @State private var scale: CGFloat = 1.0
    @State private var navigateToCombat = false
    
    var body: some View {
        VStack {
            Text("⚔️ Tu equipo:")
                .font(.title2)
                .padding(.top)
                .foregroundColor(.white)
            
            ZStack {
                Rectangle()
                    .fill(Color.pokeBlue.opacity(0.3))
                    .frame(width: 260, height: 260)
                    .overlay(
                        Rectangle()
                            .stroke(Color.pokeBlue, lineWidth: 10)
                            .frame(width: 240, height: 240)
                    )
                    .scaleEffect(isSelecting ? 1.1 : 1.0)
                    .animation(
                        isSelecting
                            ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
                            : .default, value: isSelecting
                    )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(selectedPokemon) { pokemon in
                            VStack {
                                PokemonImage(imageLink: pokemon.url)
                                    .frame(width: 80, height: 80)
                                    .padding(.bottom, 5)
                                    .rotationEffect(.degrees(rotation))
                                    .scaleEffect(isSelecting ? 1.1 : 1.0)
                                    .animation(
                                        isSelecting
                                            ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
                                            : .default, value: isSelecting
                                    )
                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()

            Divider()
                .background(Color.white)

            Text("👹 Equipo enemigo:")
                .font(.title2)
                .padding(.top)
                .foregroundColor(.white)
            
            ZStack {
                Rectangle()
                    .fill(Color.pokeRed.opacity(0.3))
                    .frame(width: 260, height: 260)
                    .overlay(
                        Rectangle()
                            .stroke(Color.pokeRed, lineWidth: 10)
                            .frame(width: 240, height: 240)
                    )
                    .scaleEffect(isSelecting ? 1.1 : 1.0)
                    .animation(
                        isSelecting
                            ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
                            : .default, value: isSelecting
                    )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(enemyPokemon) { pokemon in
                            VStack {
                                PokemonImage(imageLink: pokemon.url)
                                    .frame(width: 80, height: 80)
                                    .padding(.bottom, 5)
                                    .rotationEffect(.degrees(rotation))
                                    .scaleEffect(isSelecting ? 1.1 : 1.0)
                                    .animation(
                                        isSelecting
                                            ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
                                            : .default, value: isSelecting
                                    )
                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()

            Spacer()

            // NavigationLink oculto para redirigir a la batalla
            NavigationLink(
                destination: CombatView(playerTeam: selectedPokemon, enemyTeam: enemyPokemon),
                isActive: $navigateToCombat
            ) {
                EmptyView()
            }

            // Botón de inicio de batalla
            Button(action: {
                self.isSelecting = true
                withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotation += 360
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.isSelecting = false
                    self.navigateToCombat = true // Navega a la batalla
                }
            }) {
                Text("¡Iniciar Batalla!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .navigationTitle("Batalla Pokémon")
        .navigationBarHidden(true)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
