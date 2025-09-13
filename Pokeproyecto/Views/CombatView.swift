import SwiftUI
import AVFoundation

struct CombatView: View {
    @State private var backgroundMusicPlayer: AVAudioPlayer?

    var playerTeam: [PokemonEntry]
    var enemyTeam: [PokemonEntry]

    @State private var playerIndex = 0
    @State private var enemyIndex = 0

    @State private var playerHearts = 3
    @State private var enemyHearts = 3

    @State private var playerHP = 1000
    @State private var enemyHP = 1000

    @State private var battleLog = "¡Comienza la batalla!"
    @State private var showFireEffect = false

    @State private var enemyAttackTimer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(0..<playerHearts, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                Spacer()
                ForEach(0..<enemyHearts, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            HStack {
                VStack {
                    PokemonImage(imageLink: playerTeam[playerIndex].url)
                        .id(playerIndex)
                        .frame(width: 120, height: 120)
                    Text(playerTeam[playerIndex].name.capitalized)
                        .foregroundColor(.white)
                    Text("HP: \(playerHP)")
                        .foregroundColor(.green)
                }

                Spacer()

                VStack {
                    PokemonImage(imageLink: enemyTeam[enemyIndex].url)
                        .id(enemyIndex)
                        .frame(width: 120, height: 120)
                    Text(enemyTeam[enemyIndex].name.capitalized)
                        .foregroundColor(.white)
                    Text("HP: \(enemyHP)")
                        .foregroundColor(.green)
                }
            }
            .padding()

            if showFireEffect {
                Text("🔥🔥🔥")
                    .font(.largeTitle)
                    .transition(.opacity)
            }

            Text(battleLog)
                .foregroundColor(.white)
                .padding()

            Spacer()

            Button("¡Atacar!") {
                attack()
            }
            .disabled(playerHearts == 0 || enemyHearts == 0)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            playerHP = (playerTeam[playerIndex].health ?? 100) * 10
            enemyHP = (enemyTeam[enemyIndex].health ?? 100) * 10
            startEnemyAttackTimer()
            playBackgroundMusic(named: "combatMusic")
        }
        .onDisappear {
            stopBackgroundMusic()
            stopEnemyAttackTimer()
        }
    }

    func attack() {
        showFireEffect = true
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                showFireEffect = false
            }
        }

        let playerAttack = playerTeam[playerIndex].attack ?? 10
        enemyHP -= playerAttack
        battleLog = "Tu Pokémon atacó con \(playerAttack) de daño."

        if enemyHP <= 0 {
            enemyHearts -= 1
            if enemyHearts > 0 {
                enemyIndex += 1
                enemyHP = (enemyTeam[enemyIndex].health ?? 100) * 100
                battleLog = "El Pokémon enemigo fue derrotado. ¡Viene el siguiente!"
            } else {
                battleLog = "¡Ganaste la batalla!"
                stopBackgroundMusic()
                stopEnemyAttackTimer()
            }
        }
    }

    func startEnemyAttackTimer() {
        enemyAttackTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            enemyAttack()
        }
    }

    func stopEnemyAttackTimer() {
        enemyAttackTimer?.invalidate()
        enemyAttackTimer = nil
    }

    func playBackgroundMusic(named soundName: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: soundURL)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.play()
            } catch {
                print("Error al reproducir la música de fondo: \(error)")
            }
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    func enemyAttack() {
        guard playerHearts > 0 && enemyHearts > 0 else {
            stopEnemyAttackTimer()
            return
        }

        let enemyAttack = enemyTeam[enemyIndex].attack ?? 10
        playerHP -= enemyAttack
        battleLog += "\nEl enemigo atacó con \(enemyAttack) de daño."

        if playerHP <= 0 {
            playerHearts -= 1
            if playerHearts > 0 {
                playerIndex += 1
                playerHP = (playerTeam[playerIndex].health ?? 100) * 10
                battleLog += "\nTu Pokémon fue derrotado. ¡Sale el siguiente!"
            } else {
                battleLog = "Perdiste la batalla..."
                stopBackgroundMusic()
                stopEnemyAttackTimer()
            }
        }
    }
}
