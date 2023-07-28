//
//  NCHeroHeaderView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 12/07/23.
//

import UIKit

final class NCHeroHeaderView: UIView {
    
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
    
    public func configure(posterPath: String) {
        guard let url = URL(string: posterPath) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.headerImageView.sd_setImage(with: url)
        }
    }
    
}
