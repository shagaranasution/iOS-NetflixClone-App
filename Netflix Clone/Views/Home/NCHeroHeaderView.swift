//
//  NCHeroHeaderView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 12/07/23.
//

import UIKit

protocol NCHeroHeaderViewDelegate: AnyObject {
    func ncHeroHeaderView(_ view: NCHeroHeaderView, didTapPlay: NCTitle)
    
    func ncHeroHeaderView(_ view: NCHeroHeaderView, didTapDownloadTitle result: Result<Void, Error>)
}

final class NCHeroHeaderView: UIView {
    
    public weak var delegate: NCHeroHeaderViewDelegate?
    
    private var viewModel: NCHeroHeaderViewViewModel? {
        didSet {
            guard let viewModel else {
                return
            }
            
            viewModel.delegate = self
            setupPosterPath(with: viewModel)
        }
    }
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let headerGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        return gradientLayer
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 36
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Play", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        var configuration = button.configuration
        button.configuration = configuration
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        var configuration = button.configuration
        configuration?.title = "Download"
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        button.configuration = configuration
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        layer.addSublayer(headerGradientLayer)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(downloadButton)
        addSubview(stackView)
        addConstraints()
        playButton.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerImageView.frame = bounds
        headerGradientLayer.frame = bounds
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    @objc
    private func playButtonTap() {
        guard let viewModel else {
            return
        }
        delegate?.ncHeroHeaderView(self, didTapPlay: viewModel.title)
    }
    
    @objc
    private func downloadButtonTap() {
        viewModel?.downloadTitle()
    }
    
    private func setupPosterPath(with viewModel: NCHeroHeaderViewViewModel) {
        guard let url = viewModel.posterUrl else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.headerImageView.sd_setImage(with: url)
        }
    }
    
    public func configure(with viewModel: NCHeroHeaderViewViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Extension View Model Delegate

extension NCHeroHeaderView: NCHeroHeaderViewViewModelDelegate {
    
    func didDownloadTitle(result: Result<Void, Error>) {
        delegate?.ncHeroHeaderView(self, didTapDownloadTitle: result)
    }
    
}
