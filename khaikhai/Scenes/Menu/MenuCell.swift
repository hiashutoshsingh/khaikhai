//
//  RestrauntCell.swift
//  khaikhai
//
//  Created by Ashutosh Singh on 27/08/25.
//

import UIKit
// MARK: - RestaurantCell
class MenuCell: UITableViewCell {
    private let restaurantImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    
    private var imageLoadTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
        imageLoadTask?.cancel()
    }
    
    private func setupViews() {
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.clipsToBounds = true
        restaurantImageView.layer.cornerRadius = 8
        contentView.addSubview(restaurantImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        contentView.addSubview(nameLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.textColor = .secondaryLabel
        contentView.addSubview(priceLabel)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 15)
        ratingLabel.textColor = .systemOrange
        contentView.addSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            restaurantImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            restaurantImageView.widthAnchor.constraint(equalToConstant: 60),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -8),
            
            ratingLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            restaurantImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with menu: MenuItem) {
        nameLabel.text = menu.name
        priceLabel.text = "\(menu.price)"
        restaurantImageView.image = nil
        if let url = URL(string: menu.imageUrl) {
            imageLoadTask?.cancel()
            let session = URLSession.shared
            imageLoadTask = session.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.restaurantImageView.image = image
                }
            }
            imageLoadTask?.resume()
        }
    }
}
