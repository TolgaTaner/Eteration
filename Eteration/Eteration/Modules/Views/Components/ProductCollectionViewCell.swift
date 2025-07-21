//
//  ProductCollectionViewCell.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit
import Kingfisher

protocol ProductCollectionViewCellDelegate: AnyObject {
    func productCell(_ cell: ProductCollectionViewCell, didTapAddToCartFor product: Product)
    func productCell(_ cell: ProductCollectionViewCell, didTapFavoriteFor product: Product)
}

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = AppConstants.productCollectionViewCellId
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImages.iconUnfillStar, for: .normal)
        button.setImage(AppImages.iconFillStar, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstants.addToCart, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = AppColors.blue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var product: Product?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        favoriteButton.isSelected = false
        delegate = nil
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(productImageView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(brandLabel)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        let imageAspectConstraint = productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.75)
        imageAspectConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Product Image
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageAspectConstraint,
            productImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            // Favorite Button
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Add to Cart Button
            addToCartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 36),
            
            // Name Label - centered between price and add to cart button
            nameLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Brand Label - below name label
            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            brandLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let product = product else { return }
        delegate?.productCell(self, didTapFavoriteFor: product)
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = product else { return }
        delegate?.productCell(self, didTapAddToCartFor: product)
        
        // Add animation feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = .identity
            }
        }
    }
    
    func configure(
        with product: Product,
        isFavorite: Bool = false
    ) {
        self.product = product
        priceLabel.text = formatPrice(product.price)
        nameLabel.text = product.name
        brandLabel.text = product.brand
        
        // Update favorite button state
        favoriteButton.isSelected = isFavorite
        let starImage = AppImages.favoriteIcon(isFilled: isFavorite)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemYellow : .systemGray3
        
        if let imageURL = URL(string: product.image) {
            productImageView.kf.setImage(
                with: imageURL,
                placeholder: AppImages.photoFill,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                switch result {
                case .success(_):
                    self?.productImageView.tintColor = nil
                case .failure(_):
                    self?.productImageView.tintColor = .systemGray4
                }
            }
        } else {
            productImageView.image = AppImages.photoFill
            productImageView.tintColor = .systemGray4
        }
    }
    
    private func formatPrice(_ priceString: String) -> String {
        guard let price = Double(priceString) else {
            return priceString + "₺"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        if let formattedNumber = formatter.string(from: NSNumber(value: price)) {
            return "\(formattedNumber) ₺"
        }
        
        return priceString + " ₺"
    }
} 
