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
    @State private var isDrawerOpen: Bool = false
    @State private var isFrontPageOpen: Bool = true
    
    let pages = pageData
    @State private var pageIndex: Int = 0
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func addThumbnailImage(with imageName: String) -> some View {
        return Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 80)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // adds an extra space on the top of the zstack
                //MARK: - Page Image
                Image(pages[pageIndex].imageName )
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
            // MARK: - Control Interface
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
            .overlay(
                HStack{
                    //MARK: - Drawer Handle
                    Image(systemName:  isDrawerOpen
                          ? "chevron.right"
                          : "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    //MARK: - Thumbnails
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(2)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                withAnimation(.easeOut) {
                                    pageIndex = page.id - 1
                                }
                            }
                    }
                    
                    Spacer()

                }
                    .padding(EdgeInsets(top: 16,
                                        leading: 8,
                                        bottom: 16,
                                        trailing: 8))
                    .frame(width: 260)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                    .opacity(isAnimating ? 1 : 0)
                
                , alignment: .topTrailing
            )
            
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
