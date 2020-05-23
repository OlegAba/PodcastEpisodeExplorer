//
//  HomeViewController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    
//    fileprivate lazy var podcastsTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .insetGrouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: podcastTableViewCellID)
//        tableView.tableHeaderView = containerView
//        //tableView.separatorStyle = .none
//        tableView.backgroundColor = view.backgroundColor
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//
//    fileprivate lazy var containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(homeTableHeaderView)
//        return view
//    }()
//
    fileprivate lazy var homeTableHeaderView: HomeTableHeaderView = {
        let homeTableHeaderView = HomeTableHeaderView()
        homeTableHeaderView.titleLabel.text = "Your Auby for the day"
        
        let date = Date()
        let dataformatter = DateFormatter()
        dataformatter.dateFormat = "dd/MM/yyyy"
        let result = dataformatter.string(from: date)
        homeTableHeaderView.subtitleLabel.text = result
        
        let fontConfig = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .bold)
        let shareImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: fontConfig)
        homeTableHeaderView.iconButton.setImage(shareImage, for: .normal)
        homeTableHeaderView.iconButton.tintColor = UIColor.appRed
        
        homeTableHeaderView.textButton.setTitle("Play All", for: .normal)
        homeTableHeaderView.textButton.backgroundColor = UIColor.appRed
        
        //homeTableHeaderView.subtitleLabel.text = result
        //let size = homeTableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        //homeTableHeaderView.frame = CGRect(origin: .zero, size: size)
        homeTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return homeTableHeaderView
    }()
//
//    fileprivate let podcastTableViewCellID = "PodcastTableViewCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableHeaderView)
        //view.addSubview(podcastsTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        
        homeTableHeaderView.layoutMargins = UIEdgeInsets(top: view.layoutMargins.left * 2.0,
                                                         left: view.layoutMargins.left,
                                                         bottom: view.layoutMargins.right * 2.0,
                                                         right: view.layoutMargins.right)
        
        NSLayoutConstraint.activate([
//            podcastsTableView.topAnchor.constraint(equalTo: view.topAnchor),
//            podcastsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            podcastsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            podcastsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            homeTableHeaderView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            homeTableHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

//extension HomeViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
//    }
//}
//
//extension HomeViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: podcastTableViewCellID, for: indexPath) as? PodcastTableViewCell else { return UITableViewCell() }
//        return cell
//    }
//}
