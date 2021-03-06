//
//  HomeViewController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    
    // MARK: - Private Properties
    
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
        homeTableHeaderView.titleLabel.text = "Your Podcasts for the day"
        
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let result = dateformatter.string(from: date)
        homeTableHeaderView.subtitleLabel.text = result
        
        homeTableHeaderView.shareButton.addTarget(self, action: #selector(shareButtonWasTapped), for: .touchUpInside)
        homeTableHeaderView.playAllButton.addTarget(self, action: #selector(playAllButtonWasTapped), for: .touchUpInside)
        
        homeTableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return homeTableHeaderView
    }()
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    fileprivate lazy var podcastPlayerViewController: PodcastPlayerViewController = {
        let podcastPlayerViewController = PodcastPlayerViewController()
        return podcastPlayerViewController
    }()

    fileprivate let podcastTableViewCellID = "PodcastTableViewCellReuseIdentifier"
    fileprivate var homeTableHeaderViewLastY: CGFloat = 0
    fileprivate var podcasts = [Podcast]()
    fileprivate var podcastStreamDelegate: PodcastStreamDelegate!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(podcastsTableView)
        view.addSubview(activityIndicatorView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        podcastStreamDelegate = podcastPlayerViewController
        fetchPodcasts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Auby"
        let shareIcon = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let shareBarButtonItem = UIBarButtonItem(image: shareIcon, style: .plain, target: self, action: #selector(shareButtonWasTapped))
        shareBarButtonItem.tintColor = .appRed
        navigationItem.rightBarButtonItem = shareBarButtonItem
    }
    
    // MARK: - Layout
    
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
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
        ])
        
        homeTableHeaderView.layoutIfNeeded()
        podcastsTableView.tableHeaderView = homeTableHeaderView
        
        podcastsTableView.verticalScrollIndicatorInsets.top = homeTableHeaderView.frame.size.height
    }
    
    // MARK: - Private Methods
    
    fileprivate func fetchPodcasts() {
        
        let podcastManager = PodcastManager()
        podcastManager.fetchPodcast(amount: 5) { (podcasts: [Podcast]?) in
            DispatchQueue.main.async {
                guard let podcasts = podcasts else { return }
                self.podcasts.append(contentsOf: podcasts)
                self.activityIndicatorView.isHidden = true
                self.podcastsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func shareButtonWasTapped() {
        print("Share button was tapped")
    }
    
    @objc fileprivate func playAllButtonWasTapped() {
        print("Play All button was tapped")
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentY = scrollView.contentOffset.y
        let headerHeight = homeTableHeaderView.frame.size.height
        
        // Hidden
        if ((homeTableHeaderViewLastY <= headerHeight) && (currentY > headerHeight)) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        // Shown
        if ((homeTableHeaderViewLastY > headerHeight) && (currentY <= headerHeight)) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        homeTableHeaderViewLastY = currentY
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return podcasts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: podcastTableViewCellID, for: indexPath) as? PodcastTableViewCell else { return UITableViewCell() }
        
        let podcast = podcasts[indexPath.section]
        setup(cell: cell, for: podcast)
        cell.fetchImage(forUrl: podcast.imageUrl)
        
        return cell
    }
    
    fileprivate func setup(cell: PodcastTableViewCell, for podcast: Podcast) {
        cell.titleLabel.text = podcast.episodeTitle
        cell.subtitleLabel.text = podcast.title
        
        let duration: NSInteger = NSInteger(podcast.length)
        let minutes = (duration / 60) % 60
        let minutesText = (minutes == 0 ? "" : "\(minutes) min")
        let hours = (duration / 3600)
        let hoursText = (hours == 0 ? "" : "\(hours) hr ")
        
        cell.captionLabel.text = hoursText + minutesText
        cell.delegate = self
    }
}

// MARK: - PodcastTableViewCellDelegate
extension HomeViewController: PodcastTableViewCellDelegate {
    
    func podcastTableViewCellMoreButtonWasTapped(_ podcastTableViewCell: PodcastTableViewCell) {
        guard let indexPath = podcastsTableView.indexPath(for: podcastTableViewCell) else { return }
        print("More button was tapped on tableViewCell[\(indexPath.section)]")
    }
    
    func podcastTableViewCellPlayPauseButtonWasTapped(_ podcastTableViewCell: PodcastTableViewCell) {
        guard let indexPath = podcastsTableView.indexPath(for: podcastTableViewCell) else { return }
        let podcast = podcasts[indexPath.section]
        podcastStreamDelegate.update(ToPodcast: podcast)
        present(podcastPlayerViewController, animated: true, completion: nil)
    }
}
