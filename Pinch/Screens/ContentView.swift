//
//  ContentView.swift
//  Pinch
//
//  Created by Rehnuma Reza Deepty on 9/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: - Page Image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2),
                            radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                //MARK: - Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        // count = 2 means Double Tap gesture
                        if imageScale == 1 {
                            // if the image is in its initial scale
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            //if it's already zoomed in
                            withAnimation(.spring()) {
                                imageScale = 1
                            }
                        }
                    })
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
