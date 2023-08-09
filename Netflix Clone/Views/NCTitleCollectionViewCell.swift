//
//  NCTitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 17/07/23.
//

import UIKit

final class NCTitleCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "NCTitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray
        contentView.addSubview(posterImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    
    public func configure(with viewModel: NCTitleCollectionViewCellViewModel) {
        posterImageView.setImage(with: viewModel.posterUrl)
    }
    
}
