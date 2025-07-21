//
//  ProductDetailViewController.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController {
    
    // MARK: - Custom Navigation Container
    private lazy var navigationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppImages.arrowLeftIcon(color: .white), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppImages.iconUnfillStar, for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = AppColors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var modelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStaticLabel: UILabel = {
        let label = UILabel()
        label.text = "Price:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = AppColors.blue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addToCartButtonTapped))
        button.addGestureRecognizer(tapGesture)
        
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel: ProductDetailViewModel
    
    init(product: Product) {
        self.viewModel = ProductDetailViewModel(product: product)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        setupActions()
        updateUI(with: viewModel.product)
        
        // Observe favorite changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add custom navigation container
        view.addSubview(navigationContainerView)
        navigationContainerView.addSubview(backButton)
        navigationContainerView.addSubview(navigationTitleLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(modelLabel)
        view.addSubview(priceStaticLabel) // Moved outside scroll view
        view.addSubview(priceLabel) // Moved outside scroll view
        view.addSubview(addToCartButton) // Moved outside scroll view
        contentView.addSubview(loadingIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom Navigation Container
            navigationContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Back Button
            backButton.leadingAnchor.constraint(equalTo: navigationContainerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Navigation Title
            navigationTitleLabel.centerXAnchor.constraint(equalTo: navigationContainerView.centerXAnchor),
            navigationTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: navigationContainerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Product Image
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.75),
            
            // Favorite Button
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -4),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Brand Label
            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Model Label
            modelLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 4),
            modelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            modelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Add to Cart Button (moved to bottom)
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 182),
            addToCartButton.heightAnchor.constraint(equalToConstant: 38),
            
            // Price Static Label (moved to bottom left)
            priceStaticLabel.bottomAnchor.constraint(equalTo: addToCartButton.centerYAnchor, constant: -8),
            priceStaticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceStaticLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: priceStaticLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            
            // Content View bottom constraint
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: modelLabel.bottomAnchor, constant: 120),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func updateUI(with product: Product?) {
        guard let product = product else { return }
        
        nameLabel.text = product.name
        brandLabel.text = product.brand
        modelLabel.text = "Model: \(product.model)"
        navigationTitleLabel.text = product.name
        
        // Format price in Turkish Lira
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.currencySymbol = "₺"
        if let price = Double(product.price) {
            priceLabel.text = formatter.string(from: NSNumber(value: price)) ?? "\(product.price)₺"
        } else {
            priceLabel.text = "\(product.price)₺"
        }
        
        // Update favorite button state
        favoriteButton.isSelected = viewModel.isFavorited
        let starImage = AppImages.favoriteIcon(isFilled: viewModel.isFavorited)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.tintColor = viewModel.isFavorited ? .systemYellow : .systemGray3
        // Load product image with Kingfisher
        if let imageURL = URL(string: product.image) {
            productImageView.kf.setImage(
                with: imageURL,
                placeholder: AppImages.photoFill,
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            productImageView.image = AppImages.photoFill
            productImageView.tintColor = .systemGray4
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
    
    @objc private func addToCartButtonTapped() {
        // Add animation feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = .identity
            }
        }
        
        viewModel.addToCart()
    }
    
    @objc private func favoritesDidChange() {
        DispatchQueue.main.async {
            self.favoriteButton.isSelected = self.viewModel.isFavorited
        }
    }
}

// MARK: - ProductDetailViewModelDelegate
extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func productDidUpdate() {
        DispatchQueue.main.async {
            self.updateUI(with: self.viewModel.product)
        }
    }
    
    func loadingStateDidChange(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.loadingIndicator.startAnimating()
                self.scrollView.isHidden = true
            } else {
                self.loadingIndicator.stopAnimating()
                self.scrollView.isHidden = false
            }
        }
    }
    
    func favoriteStateDidChange(_ isFavorited: Bool) {
        DispatchQueue.main.async {
            self.favoriteButton.isSelected = isFavorited
            
            // Update button image and tint color based on state
            let starImage = AppImages.favoriteIcon(isFilled: isFavorited)
            self.favoriteButton.setImage(starImage, for: .normal)
            self.favoriteButton.tintColor = isFavorited ? .systemYellow : .systemGray3
            
            // Add a subtle animation when toggling
            UIView.animate(withDuration: 0.2) {
                self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.favoriteButton.transform = CGAffineTransform.identity
                }
            }
        }
    }
} 
