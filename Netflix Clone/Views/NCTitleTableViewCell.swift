//
//  NCTitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 18/07/23.
//

import UIKit

final class NCTitleTableViewCell: UITableViewCell {
    
    public static let identifier = "NCTitleTableViewCell"
    
    private var titleLabelConstraintWidth: NSLayoutConstraint!
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(posterImageView, titleLabel, playButton)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateConstraints()
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        titleLabel.text = nil
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        titleLabelConstraintWidth.constant = contentView.frame.width * 0.5
        contentView.layoutIfNeeded()
    }
    
    private func addConstraints() {
        titleLabelConstraintWidth =  titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.5)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabelConstraintWidth,
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    public func configure(with viewModel: NCTitleTableViewCellViewModel) {
        posterImageView.sd_setImage(with: URL(string: viewModel.posterPath))
        titleLabel.text = viewModel.titleString
    }

}
