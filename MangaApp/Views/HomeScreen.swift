//
//  HomeScreen.swift
//  MangaApp
//
//  Created by Leo Mogiano on 1/11/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var currentIndex = 1
    @GestureState private var dragOffset: CGFloat = .zero
    @State private var offSetLimit: CGFloat = 50
    
    private var images: [String] = ["manga1", "manga4", "manga6", "manga2", "manga5", "manga3", "manga7", "manga8", "manga9", "manga10"]
    
    
    var body: some View {
        ZStack(alignment: .top) {
            CustomGradientBackground()
            DotsBackground()
            
            VStack {
                ZStack {
                    ForEach(0..<images.count, id: \.self) { index in
                        if abs(index - currentIndex) <= 1 {
                            Image(images[index])
                                .resizable()
                                .frame(width: 150, height: 235)
                                .opacity(currentIndex == index ? 1 : 0.5)
                                .scaleEffect(currentIndex == index ? 1.1 - abs(dragOffset / 100) * 0.1 : 1)
                                .zIndex(currentIndex == index ? 1: 0)
                                .offset(x: offsetForIndex(index), y: 0)
                                .rotationEffect(rotationForIndex(index))
                                .gesture(dragGesture)
                                .onTapGesture {handleTap(for: index)}
                        }
                        
                    }
                }
            }.padding(.top, 60)
            
            
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = min(max(value.translation.width, -offSetLimit), offSetLimit)
            }
            .onEnded { value in
                let offset = value.translation.width
                if currentIndex != 1 || offset <= 0, abs(offset) > 10 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        changeIndex(by: offset > 0 ? -1 : 1)
                    }
                }
            }
    }
    
    private func offsetForIndex(_ index: Int) -> CGFloat {
        return CGFloat(index - currentIndex) * 100 + (index == currentIndex ? dragOffset : 0)
    }
    
    private func rotationForIndex(_ index: Int) -> Angle {
        return .degrees(index == currentIndex ? dragOffset * 0.05 : (index < currentIndex ? -5 : 5))
    }
    private func handleTap(for index: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            changeIndex(by: index < currentIndex ? -1 : 1)
        }
    }
    
    private func changeIndex(by value: Int) {
        currentIndex = min(max(currentIndex + value, 0), 10 - 1)
    }
}

#Preview {
    HomeScreen()
}

struct CustomGradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .black, location: 0.1),
                .init(color: Color("BgColor"), location: 0.5)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct DotsBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let dotSize: CGFloat = 2
                let spacing: CGFloat = 10
                
                for x in stride(from: 0, to: size.width, by: spacing) {
                    for y in stride(from: 100, to: size.height, by: spacing) {
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: dotSize, height: dotSize)),
                            with: .color(Color("DotsColor"))
                        )
                    }
                }
            }
        }.ignoresSafeArea()
    }
}


