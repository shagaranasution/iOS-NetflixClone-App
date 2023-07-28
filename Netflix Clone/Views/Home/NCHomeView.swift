//
//  NCHomeView.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 17/07/23.
//

import UIKit

protocol NCHomeViewProtocol: AnyObject {
    func ncHomeView(_ view: NCHomeView, didTapTitle title: NCTitle)
}

final class NCHomeView: UIView {
    
    weak var delegate: NCHomeViewProtocol?
    
    private var viewModels = NCHomeViewViewModel()
    
    private let homeHeaderView: NCHeroHeaderView = {
        let view = NCHeroHeaderView()
        return view
    }()
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(NCCollectionViewTableViewCell.self,
                           forCellReuseIdentifier: NCCollectionViewTableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Initializatioin
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeFeedTable.frame = bounds
        homeHeaderView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: bounds.size.width,
                                      height: bounds.size.height * 0.45)

        homeFeedTable.tableHeaderView = homeHeaderView
    }
    
    public func configureHeaderView(withPosterPath posterPath: String) {
        homeHeaderView.configure(posterPath: posterPath)
    }
    
}

extension NCHomeView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NCCollectionViewTableViewCell.identifier,
            for: indexPath
        ) as? NCCollectionViewTableViewCell else {
            return UITableViewCell()
        }
        let section =  viewModels.sections[indexPath.section]
        let cellViewModel = NCCollectionViewTableViewCellViewModel(
            section: section
        )
    
        cell.configure(with: cellViewModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerView.frame = CGRect(x: headerView.bounds.origin.x + 12,
                                  y: headerView.bounds.origin.y,
                                  width: 100,
                                  height: headerView.bounds.size.height)
        headerView.textLabel?.textColor = .label
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModels.sections[section].sectionTitle
    }
    
}

extension NCHomeView: NCCollectionViewTableViewCellProtocol {
    
    func ncCollectionViewTableViewCell(_ cell: UITableViewCell, didTapTitle title: NCTitle) {
        delegate?.ncHomeView(self, didTapTitle: title)
    }
}

