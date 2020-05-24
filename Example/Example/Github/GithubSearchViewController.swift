//
//  GithubSearchViewController.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/05/07.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit
import MobS

class GithubSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = GithubSearchViewModel()

    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor)
        ])
        indicatorView.startAnimating()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
    }

    private func setupUI() {
        tableView.tableFooterView = footerView
    }

    private func setupObserver() {
        viewModel.$repos.didSet(with: self) { (self, _) in
            self.reloadData()
        }
        viewModel.$isLoading.bind(to: footerView, keyPath: \.isHidden) { (isLoading) in
            !isLoading
        }
        addObserver { (self) in
            if let error = self.viewModel.error {
                let message: String
                if case GithubSearchError.error403 = error {
                    message = "API rate limit exceeded. Use Basic Authentication or OAuth for more test."
                } else {
                    message = error.localizedDescription
                }
                self.showAlert(title: "Error", message: message)
            }
        }
    }

}

extension GithubSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func reloadData() {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "GithubSearchCell", for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? GithubSearchCell).map { $0.repo = viewModel.repos[indexPath.row] }
        if indexPath.row == (viewModel.repos.count - 1) {
            viewModel.searchMore()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repo = viewModel.repos[indexPath.row]
        showAlert(title: repo.name, message: repo.description)
    }

}

extension GithubSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(query: searchBar.text ?? "")
    }

}

extension GithubSearchViewController {

    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
