//
//  ShareButton.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

import UIKit

struct ShareButtonView: View {
    @State private var isSharing = false

    var body: some View {
        Button(action: {
            isSharing = true
        }) {
            Text("Share")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .sheet(isPresented: $isSharing) {
            ShareSheet(activityItems: [captureImageFromView()])
        }
    }

    func captureImageFromView() -> UIImage {
        let view = UIApplication.shared.windows.first?.rootViewController?.view
        let renderer = UIGraphicsImageRenderer(bounds: view?.bounds ?? .zero)
        let image = renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
        return image
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}

    typealias UIViewControllerType = UIActivityViewController
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView()
    }
}
