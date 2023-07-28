//
//  NCTitlePreviewView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 24/07/23.
//

import UIKit
import WebKit

protocol NCTitlePreviewViewDelegate: AnyObject {
    func ncTitlePreviewView(_ view: NCTitlePreviewView, didDownloadTitleResult result: (Result<Void, Error>))
}

final class NCTitlePreviewView: UIView {
    
    public weak var delegate: NCTitlePreviewViewDelegate?
    
    private var viewModel: NCTitlePreviewViewViewModel?
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .darkGray
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(frame: CGRect, viewModel: NCTitlePreviewViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(webView)
        addSubviews(titleLabel, overviewLabel, downloadButton)
        addConstraints()
        downloadButton.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 24),
            downloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc
    private func didTapDownloadButton() {
        viewModel?.downloadTitle(completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.ncTitlePreviewView(strongSelf, didDownloadTitleResult: result)
        })
    }
    
    public func configure(titleText: String, overviewText: String, videoPreviewURL: URL?) {
        guard let url = videoPreviewURL else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(URLRequest(url: url))
            self?.titleLabel.text = titleText
            self?.overviewLabel.text = overviewText
        }
    }

}
