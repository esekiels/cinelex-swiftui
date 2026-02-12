//
//  SafariView.swift
//  Design
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import SafariServices

public struct SafariView: UIViewControllerRepresentable {
    
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed as URL is immutable
    }
}
