//
//  ErrorAlert.swift
//  Clement
//
//  Created by Alex Catchpole on 01/10/2024.
//

import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

struct ToastView: View {
    
    var style: ToastStyle
    var title: String
    var message: String
    var width = CGFloat.infinity
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: style.iconFileName)
                    .foregroundColor(style.themeColor)
                Text(title)
                    .font(.system(.headline, weight: .bold)).foregroundColor(.green5)
                Spacer()
            }
            Text(message).font(.system(.subheadline)).foregroundColor(.green5)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .cornerRadius(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.chalk)
        )
    }
}

#Preview {
    ToastView(style: .error, title: "Rule limit reached",message: "There are 196,000 rules enabled, this is over the 150,000 limit enforced by Apple.")
}
