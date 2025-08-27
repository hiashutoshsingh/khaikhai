import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel: MenuViewModel
    private let tableView = UITableView()
    private var menu: [MenuItem] = []
    private let loader = UIActivityIndicatorView(style: .large)
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
        loader.center = view.center
        view.addSubview(loader)
        messageLabel.frame = view.bounds
        view.addSubview(messageLabel)
        
        bindViewModel()
        viewModel.loadMenu()
    }
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.loader.startAnimating()
                    self?.messageLabel.isHidden = true
                    self?.menu = []
                    self?.tableView.reloadData()
                case .success(let list):
                    self?.loader.stopAnimating()
                    self?.messageLabel.isHidden = true
                    self?.menu = list
                    self?.tableView.reloadData()
                case .empty:
                    self?.loader.stopAnimating()
                    self?.messageLabel.text = "No restaurants available."
                    self?.messageLabel.isHidden = false
                    self?.menu = []
                    self?.tableView.reloadData()
                case .error(let msg):
                    self?.loader.stopAnimating()
                    self?.messageLabel.text = "Error: \(msg)"
                    self?.messageLabel.isHidden = false
                    self?.menu = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MenuCell",
            for: indexPath
        ) as? MenuCell else {
            return UITableViewCell()
        }
        let item = menu[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}
