//
//  NCDownloadsView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 26/07/23.
//

import UIKit

protocol NCDownloadsViewDelegate: AnyObject {
    func ncDownloadsView(_ view: NCDownloadsView, didSelect title: NCTitle)
}

final class NCDownloadsView: UIView {
    
    public weak var delegate: NCDownloadsViewDelegate?
    
    private var viewModel: NCDownloadsViewViewModel? {
        didSet {
            guard viewModel != nil else {
                return
            }
            
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NCTitleTableViewCell.self, forCellReuseIdentifier: NCTitleTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableViewDelegate()
        backgroundColor = .systemBackground
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    private func configureTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func configure(with viewModel: NCDownloadsViewViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - Extension TableView Delegate

extension NCDownloadsView: UITableViewDelegate, UITableViewDataSource {
        
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
        delegate?.ncDownloadsView(self, didSelect: title)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel?.removeDownloadedTitle(at: indexPath.row, completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        default:
            break
        }
    }
    
}
