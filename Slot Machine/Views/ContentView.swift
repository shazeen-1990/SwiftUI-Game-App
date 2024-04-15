//
//  ContentView.swift
//  Slot Machine
//
//  Created by Shazeen Thowfeek on 08/04/2024.
//

import SwiftUI

//MARK: properties

struct ContentView: View {
    
    let symbols = ["gfx-bell","gfx-cherry","gfx-coin","gfx-grape","gfx-seven","gfx-strawberry"]
    
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highscore:Int = UserDefaults.standard.integer(forKey: "HighScore")
    
    @State private var coins: Int = 100
    @State private var betAmount:Int = 10
    
    @State private var reels: Array = [0,1,2]
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false
    
    //MARK: functiomns
    
    func spinReels(){
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    //spin the reels
    //check the winning
    
    func checkWinning(){
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2]{
            //player wins
            playerWins()
            //new highscore
            
            if coins > highscore {
                newHighScore()
            }else{
                playSound(sound: "win", type: "mp3")
            }
        }else{
            //player loses
            playerLoses()
        }
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore(){
        highscore = coins
        UserDefaults.standard.set(highscore,forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activatebet20(){
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10(){
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    //game is over
    func isGameOver(){
        if coins <= 0 {
            //show model window
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    //MARK: body
    
    var body: some View {
       
        ZStack {
            //MARK: background
            LinearGradient(gradient: Gradient(colors: [.colorPink,.colorPurple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: interface
            VStack(alignment:.center,spacing: 5){
                
                
                //MARK: header
                LogoView()
                
                Spacer()
                
                //MARK: Score
                HStack {
                    HStack{
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack{
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                
                //MARK: slot machine
                VStack(alignment:.center, spacing: 0){
                    //MARK: Real #1
                    ZStack {
                        RealView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1:0)
                            .offset(y: animatingSymbol ? 0:-50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack(alignment:.center,spacing: 0){
                        //MARK: Real #2
                        ZStack {
                            RealView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1:0)
                                .offset(y: animatingSymbol ? 0:-50)
                                .animation(.easeOut(duration: Double.random(in: 0.5...0.9)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                        
                        Spacer()
                        //MARK: Real #3
                        ZStack {
                            RealView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1:0)
                                .offset(y: animatingSymbol ? 0:-50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    //MARK: spin button
                    Button(action: {
                        //1.set default state no animation
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        //2.spin the reels with changing the symbols
                        
                        self.spinReels()
                        
                        //3.trigger the animation after changing the symbols
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        //4.check winning
                        self.checkWinning()
                        //5.game is over
                        self.isGameOver()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                }// slot machine
                .layoutPriority(2)
                
                //MARK: foooter
                
                Spacer()
                
                HStack{
                    //MARK: bet 20
                    
                    HStack(alignment:.center,spacing: 10){
                        Button(action: {
                            self.activatebet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ?  Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0:20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    //MARK: bet 10
                    
                    HStack(alignment:.center,spacing: 10){
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet10 ? 0:-20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        Button(action: {
                            self.activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                    }
                }
            }
            //MARK: buttons
            .overlay(
                //RESET
                Button(action: {
                    self.resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()),
                alignment:.topLeading
            )
            .overlay(
                //INFO
                Button(action: {
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()),
                alignment:.topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: popup
            if $showingModal.wrappedValue{
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    //modal
                    VStack(spacing:0){
                        //title
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .background(Color.colorPink)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                            //message
                        VStack(alignment: .center, spacing: 16){
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck!. you lost all of the coins.\nLets play again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.animatingModel = false
                                self.activateBet10()
                                self.coins = 100
                            }, label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(.colorPink)
                                    .padding(.horizontal,12)
                                    .padding(.vertical,8)
                                    .frame(minWidth: 128)
                                    .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(.colorPink)
                                    )
                            })
                        }
                    }
                    .frame(minWidth: 280,idealWidth: 280,maxWidth: 320,minHeight: 260,idealHeight: 280,maxHeight: 320,alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .colorTransparentBlack, radius: 6,x: 0,y: 8)
                    .opacity($animatingModel.wrappedValue ? 1:0)
                    .offset(y: $animatingModel.wrappedValue ? 0:-100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0,blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModel = true
                    })
                }
            }
        }//zstack
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
       
    }
}

//MARK: preview
#Preview {
    ContentView()
}
