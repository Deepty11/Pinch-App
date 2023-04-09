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
    @State private var imageOffset: CGSize = .zero // height and width are both zero
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // adds an extra space on the top of the zstack
                //MARK: - Page Image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2),
                            radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width,
                            y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: - 1. Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        // count = 2 means Double Tap gesture
                        if imageScale == 1 {
                            // if the image is in its initial scale
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            //if it's already zoomed in
                            resetImageState()
                        }
                    })
                //MARK: - 2. Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged({ geture in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = geture.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
                // MARK : - 3. Magnification
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        resetImageState()
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            //MARK: - Info Panel View
            .overlay(InfoPanelView(scale: imageScale, offset: imageOffset)
                .padding(.horizontal)
                .padding(.top, 30)
                     , alignment: .top)
            // MARK : - Control Interface
            .overlay(
                Group(content: {
                    HStack{
                        // ZOOM OUT
                        Button(action: {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale < 1 {
                                        resetImageState()
                                    }
                                }
                            }
                            
                        }, label: {
                            ControlImageView(iconName: "minus.magnifyingglass")
                        })
                        // RESET
                        
                        Button(action: {
                            resetImageState()
                        }, label: {
                            ControlImageView(iconName: "arrow.up.left.and.down.right.magnifyingglass")
                        })
                        
                        
                        // ZOOM IN
                        Button(action: {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            
                        }, label: {
                            ControlImageView(iconName: "plus.magnifyingglass")
                        })
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                })
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            
            
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
