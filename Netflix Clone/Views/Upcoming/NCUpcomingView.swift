//
//  NCUpcomingView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 18/07/23.
//

import UIKit

protocol NCUpcomingViewDelegate: AnyObject {
    func ncUpcomingView(_ view: NCUpcomingView, didSelect title: NCTitle)
}

final class NCUpcomingView: UIView {
    
    weak var delegate: NCUpcomingViewDelegate?
    
    private var viewModel: NCUpcomingViewViewModel? {
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
    
    public func configure(with viewModel: NCUpcomingViewViewModel) {
        self.viewModel = viewModel
    }

}

extension NCUpcomingView: UITableViewDelegate, UITableViewDataSource {
    
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
        delegate?.ncUpcomingView(self, didSelect: title)
    }

}
