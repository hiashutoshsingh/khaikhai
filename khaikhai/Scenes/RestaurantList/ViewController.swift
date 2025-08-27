//
//  ViewController.swift
//  khaikhai
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private(set) var viewModel: RestaurantListViewModel!
    private let tableView = UITableView()
    private var restaurants: [Restaurant] = []
    private let loader = UIActivityIndicatorView(style: .large)
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    func inject(viewModel: RestaurantListViewModel){
        self.viewModel = viewModel
        bindViewModel()
        viewModel.loadRestaurants()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
        loader.center = view.center
        view.addSubview(loader)
        messageLabel.frame = view.bounds
        view.addSubview(messageLabel)
    }

    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.loader.startAnimating()
                    self?.messageLabel.isHidden = true
                    self?.restaurants = []
                    self?.tableView.reloadData()
                case .success(let list):
                    self?.loader.stopAnimating()
                    self?.messageLabel.isHidden = true
                    self?.restaurants = list
                    self?.tableView.reloadData()
                case .empty:
                    self?.loader.stopAnimating()
                    self?.messageLabel.text = "No restaurants available."
                    self?.messageLabel.isHidden = false
                    self?.restaurants = []
                    self?.tableView.reloadData()
                case .error(let msg):
                    self?.loader.stopAnimating()
                    self?.messageLabel.text = "Error: \(msg)"
                    self?.messageLabel.isHidden = false
                    self?.restaurants = []
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = "\(restaurant.name) (⭐️\(restaurant.rating))"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        let vm = MenuViewModel(repository: RestaurantRepository(), restaurantId: restaurant.id)
        let vc = MenuViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
