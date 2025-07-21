//
//  FavoritesViewController.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppImages.heartIcon(color: .systemGray3)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap the heart icon on products to add them to your favorites"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel = FavoriteViewModel()
    private let productListViewModel = ProductListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load products if needed and refresh favorites
        if productListViewModel.allProducts.isEmpty {
            loadProductsAndFavorites()
        } else {
            collectionView.reloadData()
            updateEmptyState()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Collection View
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State View
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            // Empty Image View
            emptyImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Empty Title Label
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            emptyTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            // Empty Subtitle Label
            emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 8),
            emptySubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptySubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        updateEmptyState()
    }
    
    private func getFavoriteProducts() -> [Product] {
        // If we don't have products loaded, we need to load them first
        if productListViewModel.allProducts.isEmpty {
            loadProductsAndFavorites()
            return []
        }
        
        return viewModel.favoriteProductIds.compactMap { productId in
            return productListViewModel.allProducts.first { $0.id == productId }
        }
    }
    
    private func loadProductsAndFavorites() {
        Task {
            let result = await productListViewModel.getProductService().get(path: "/products", queryItems: nil)
            await MainActor.run {
                switch result {
                case .success(let products):
                    self.productListViewModel.allProducts = products
                    self.collectionView.reloadData()
                    self.updateEmptyState()
                case .failure(_):
                    // Handle error if needed
                    break
                }
            }
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.favoriteProductIds.isEmpty
        collectionView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }
    
    private func handleFavoriteToggle(for product: Product) {
        viewModel.removeFromFavorites(product: product)
    }
    
    private func handleAddToCart(for product: Product) {
        CartManager.shared.addToCart(product: product)
        
        // Show feedback
        let alert = UIAlertController(
            title: "Added to Cart",
            message: "\(product.name) has been added to your cart",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getFavoriteProducts().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.identifier,
            for: indexPath
        ) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let favoriteProducts = getFavoriteProducts()
        guard indexPath.item < favoriteProducts.count else { return cell }
        
        let product = favoriteProducts[indexPath.item]
        cell.delegate = self
        cell.configure(
            with: product,
            isFavorite: true
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoriteProducts = getFavoriteProducts()
        guard indexPath.item < favoriteProducts.count else { return }
        
        let product = favoriteProducts[indexPath.item]
        let detailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 10 + 16 // Left margin + Spacing + Right margin
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / 2
        let cellHeight: CGFloat = 320
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - FavoriteViewModelDelegate
extension FavoritesViewController: FavoriteViewModelDelegate {
    func favoritesDidUpdate() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateEmptyState()
        }
    }
}

// MARK: - ProductCollectionViewCellDelegate
extension FavoritesViewController: ProductCollectionViewCellDelegate {
    func productCell(_ cell: ProductCollectionViewCell, didTapAddToCartFor product: Product) {
        handleAddToCart(for: product)
    }
    
    func productCell(_ cell: ProductCollectionViewCell, didTapFavoriteFor product: Product) {
        handleFavoriteToggle(for: product)
    }
}
