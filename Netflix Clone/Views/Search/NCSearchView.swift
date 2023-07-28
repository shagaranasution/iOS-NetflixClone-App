//
//  NCSearchView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 19/07/23.
//

import UIKit

protocol NCSearchViewDelegate: AnyObject {
    func ncSearchView(_ view: NCSearchView, didSelect title: NCTitle)
}

final class NCSearchView: UIView {
    
    weak var delegate: NCSearchViewDelegate?

    private var viewModel: NCSearchViewViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(NCTitleTableViewCell.self, forCellReuseIdentifier: NCTitleTableViewCell.identifier)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(tableView)
        configureTableViewDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func configureTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    public func configure(with viewModel: NCSearchViewViewModel) {
        self.viewModel = viewModel
    }

}

extension NCSearchView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NCTitleTableViewCell.identifier,
            for: indexPath
        ) as? NCTitleTableViewCell else {
            return UITableViewCell()
        }
        guard let cellViewModel = viewModel?.cellViewModels[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = viewModel?.getTitle(at: indexPath.row) else {
            return
        }
        delegate?.ncSearchView(self, didSelect: title)
    }
    
}
