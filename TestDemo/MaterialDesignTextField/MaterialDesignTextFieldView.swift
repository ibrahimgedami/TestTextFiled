//
//  MaterialDesignTextFieldView.swift
//  TestDemo
//
//  Created by Ibrahim Abdelgani on 18/01/2025.
//

import SwiftUI

struct MaterialDesignTextFieldView: View {
    
    @ObservedObject var manager = TextFieldManager()
    @State var isTapped = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 15) {
                    TextField("", text: $manager.text) { status in
                        // it will fire when textfiled clicked...
                        if status {
                            withAnimation(.easeIn ) {
                                // Allow hint to top....
                                isTapped = true
                            }
                        }
                    } onCommit: {
                        // it will fire when return key is pressed...
                        if manager.text == "" {
                            withAnimation(.easeOut ) {
                                // Allow hint to t op....
                                isTapped = false
                            }
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "suit.heart")
                    }

                } // HStack
                // if tapped
                .padding(.top, isTapped ? 15 : 0)
                .background(
                    Text("Username")
                        .scaleEffect(isTapped ? 0.8 : 1)
                        .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                        .foregroundStyle(isTapped ? .blue : .gray)
                    ,alignment: .leading
                )
                .padding(.horizontal)

                // Divider
                Rectangle()
                    .fill(isTapped ? .blue : .gray)
                    .opacity(isTapped ? 1 : 0.5)
                    .frame(height: 1)
                    .padding(.top, 10)
            }
            .padding(.top, 12)
            .background(.gray.opacity(0.09))
            .cornerRadius(12)
            
            // Displaying count
            HStack {
                Text("\(manager.text.count) / 15")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.leading)
                    .padding(.top, 4)
                
                Spacer()
            }
    }
    
}

#Preview {
    MaterialDesignTextFieldView()
}

class TextFieldManager: ObservableObject {
    
    @Published var text = "" {
        didSet {
            if text.count >= 15 && oldValue.count <= 15 {
                text = oldValue
            }
        }
    }
     
}
