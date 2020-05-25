//
//  HomeViewController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    
    fileprivate lazy var podcastsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: podcastTableViewCellID)
        tableView.tableHeaderView = homeTableHeaderView
        tableView.rowHeight = 140.0
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = view.backgroundColor
        tableView.indicatorStyle = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    fileprivate lazy var homeTableHeaderView: HomeTableHeaderView = {
        let homeTableHeaderView = HomeTableHeaderView()
        homeTableHeaderView.titleLabel.text = "Your Auby for the day"
        
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let result = dateformatter.string(from: date)
        homeTableHeaderView.subtitleLabel.text = result
        
        let shareIcon = UIImage(systemName: "square.and.arrow.up", withConfiguration: iconConfig)
        homeTableHeaderView.iconButton.setImage(shareIcon, for: .normal)
        homeTableHeaderView.iconButton.tintColor = .appRed
        
        homeTableHeaderView.textButton.setTitle("Play All", for: .normal)
        homeTableHeaderView.textButton.backgroundColor = UIColor.appRed
        
        homeTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return homeTableHeaderView
    }()

    fileprivate let podcastTableViewCellID = "PodcastTableViewCellReuseIdentifier"
    fileprivate var homeTableHeaderViewLastY: CGFloat = 0
    fileprivate let iconConfig = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .bold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(podcastsTableView)
        
        /*
        let api = iTunesAPIEndpointRequest()
        api.getTopPodcastsIDs { (ids: [String]?) in
            guard let ids = ids?.prefix(10) else { return }
            
            for id in ids {
                api.getRSSFeed(forArtistID: id) { (feedURL: String?) in
                    print(feedURL)
                }
            }
        }
        */
        
        RSSFeedEndpointRequest(url: "http://joeroganexp.joerogan.libsynpro.com/rss").fetchPodcast { (_) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.barTintColor = .white
        //navigationController?.navigationBar.shadowImage = UIColor.appPink.as1ptImage()
        //navigationController?.preferredStatusBarStyle = .darkContent
        
        navigationItem.title = "Auby"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let shareBarButtonItem = UIBarButtonItem(image: .shareIcon, style: .plain, target: self, action: nil)
        shareBarButtonItem.tintColor = .appRed
        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
    
    fileprivate func layoutViews() {
        
        homeTableHeaderView.layoutMargins = UIEdgeInsets(top: view.layoutMargins.left * 2.0, left: view.layoutMargins.left, bottom: view.layoutMargins.right * 2.0, right: view.layoutMargins.right)
        
        NSLayoutConstraint.activate([
            podcastsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            podcastsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            podcastsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            podcastsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            homeTableHeaderView.topAnchor.constraint(equalTo: podcastsTableView.topAnchor),
            homeTableHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        homeTableHeaderView.layoutIfNeeded()
        podcastsTableView.tableHeaderView = homeTableHeaderView
        
        podcastsTableView.verticalScrollIndicatorInsets.top = homeTableHeaderView.frame.size.height
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentY = scrollView.contentOffset.y
        let headerHeight = homeTableHeaderView.frame.size.height
        
        // Hidden
        if ((homeTableHeaderViewLastY <= headerHeight) && (currentY > headerHeight)) {
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            //podcastsTableView.verticalScrollIndicatorInsets.top = homeTableHeaderView.frame.size.height
        }
        
        // Shown
        if ((homeTableHeaderViewLastY > headerHeight) && (currentY <= headerHeight)) {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            //podcastsTableView.verticalScrollIndicatorInsets.top = (navigationController?.navigationBar.frame.size.height ?? 0)
        }
        
        homeTableHeaderViewLastY = currentY
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: podcastTableViewCellID, for: indexPath) as? PodcastTableViewCell else { return UITableViewCell() }
        
        cell.containerView.backgroundColor = .white
        
        let moreIcon = UIImage(systemName: "ellipsis", withConfiguration: iconConfig)
        cell.topIconButton.setImage(moreIcon, for: .normal)
        cell.topIconButton.tintColor = .appRed
        let playIcon = UIImage(systemName: "play.circle", withConfiguration: iconConfig)
        cell.bottomIconButton.setImage(playIcon, for: .normal)
        cell.bottomIconButton.tintColor = .appRed
        
        cell.titleLabel.text = "Brenda Gilbert on How to Align Yourself With Great people in Work & Life"
        cell.subtitleLabel.text = "Woman of Impact"
        cell.captionLabel.text = "1 hr 6 min"
        
        return cell
    }
}
