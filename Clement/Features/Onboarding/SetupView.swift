//
//  SetupView.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI

struct SetupView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(.logo).resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(.accentColor)
                    Text("Clement").font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.accentColor)
                }
                Text("Follow the steps below to enable the Clement content blocker extension.")
            }.padding(.bottom, 20)
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ZStack {
                      Circle()
                            .fill(.accent)
                      
                        Text("1").fontWeight(.heavy).foregroundStyle(.green5)
                    }
                    .frame(width: 25, height: 25)
                    Text("Open the Settings app")
                }
                HStack {
                    ZStack {
                      Circle()
                            .fill(.accent)
                      
                        Text("2").fontWeight(.heavy).foregroundStyle(.green5)
                    }
                    .frame(width: 25, height: 25)
                    Text("Tap Safari")
                }
                HStack {
                    ZStack {
                      Circle()
                            .fill(.accent)
                      
                        Text("3").fontWeight(.heavy).foregroundStyle(.green5)
                    }
                    .frame(width: 25, height: 25)
                    Text("Tap Extensions")
                }
                HStack {
                    ZStack {
                      Circle()
                            .fill(.accent)
                      
                        Text("4").fontWeight(.heavy).foregroundStyle(.green5)
                    }
                    .frame(width: 25, height: 25)
                    Text("Enable all the Clement extensions")
                }
                HStack {
                    ZStack {
                      Circle()
                            .fill(.accent)
                      
                        Text("4").fontWeight(.heavy).foregroundStyle(.green5)
                    }
                    .frame(width: 25, height: 25)
                    Text("Return to the Clement app")
                }
            }
        }.padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        SetupView()
    }
}
