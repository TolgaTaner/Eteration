//
//  ProductListViewController.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit
import Kingfisher

final class ProductListViewController: UIViewController {
    
    // MARK: - Header Section
    private lazy var headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.appName
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    // MARK: - Search Container
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: AppConstants.search,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.delegate = self
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        
        // Add search icon with padding
        let leftContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        let searchIconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIconImageView.tintColor = .systemGray2
        searchIconImageView.contentMode = .scaleAspectFit
        searchIconImageView.frame = CGRect(x: 12, y: 4, width: 16, height: 16)
        leftContainerView.addSubview(searchIconImageView)
        textField.leftView = leftContainerView
        textField.leftViewMode = .always
        
        // Add right padding for clear button
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .unlessEditing
        
        // Add target for text changes
        textField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var selectFilterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectFilterLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.selectFilter
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filterLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 18)
        label.text = AppConstants.filters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        collectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.noProductsFound
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: ProductListViewModel = ProductListViewModel()
    
    func setSharedProductListViewModel(_ productListViewModel: ProductListViewModel) {
        // For now, we'll keep the existing view model since it's already initialized
        // In a more complex app, you might want to replace the entire view model
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add header elements
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(appTitleLabel)
        
        // Add search container
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        
        // Add select filter container
        view.addSubview(selectFilterContainerView)
        selectFilterContainerView.addSubview(selectFilterLabel)
        
        // Add tap gesture to select filter container
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectFilterTapped))
        selectFilterContainerView.addGestureRecognizer(tapGesture)
        selectFilterContainerView.isUserInteractionEnabled = true
        
        // Add filter label
        view.addSubview(filterLabel)
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // Header Container
            
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // App Title
            appTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            appTitleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            
            // Search Container
            searchContainerView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Search Text Field
            searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            
            // Filter Label
            filterLabel.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 19),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Select Filter Container
            selectFilterContainerView.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            selectFilterContainerView.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: 12),
            selectFilterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectFilterContainerView.heightAnchor.constraint(equalToConstant: 36),
            selectFilterContainerView.widthAnchor.constraint(equalToConstant: 138),
            
            // Select Filter Label
            selectFilterLabel.centerYAnchor.constraint(equalTo: selectFilterContainerView.centerYAnchor),
            selectFilterLabel.centerXAnchor.constraint(equalTo: selectFilterContainerView.centerXAnchor),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty State Label
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
        viewModel.loadProducts()
    }
    
    @objc private func favoritesDidChange() {
        DispatchQueue.main.async {
            // Reload the collection view to update favorite states
            self.collectionView.reloadData()
        }
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        viewModel.updateSearchText(searchText)
    }
    
    @objc private func selectFilterTapped() {
        presentFilterModal()
    }
    
    private func presentFilterModal() {
        let alertController = UIAlertController(
            title: AppConstants.filters,
            message: AppConstants.filteringAndSorting,
            preferredStyle: .actionSheet
        )
        
        // Brand filters
        alertController.addAction(UIAlertAction(title: AppConstants.allBrands, style: viewModel.selectedBrand == nil ? .destructive : .default) { [weak self] _ in
            self?.viewModel.selectedBrand = nil
        })
        
        viewModel.availableBrands.forEach { brand in
            let action = UIAlertAction(title: brand, style: .default) { [weak self] _ in
                self?.viewModel.selectedBrand = brand
            }
            if brand == viewModel.selectedBrand {
                action.setValue(true, forKey: AppConstants.checkedKey)
            }
            alertController.addAction(action)
        }
        
        // Sorting options
        ProductListViewModel.SortOption.allCases.forEach { sortOption in
            let action = UIAlertAction(
                title: sortOption.rawValue,
                style: .default
            ) { [weak self] _ in
                self?.viewModel.selectedSortOption = sortOption
            }
            if sortOption == viewModel.selectedSortOption {
                action.setValue(true, forKey: AppConstants.checkedKey)
            }
            alertController.addAction(action)
        }
        
        // Clear filters
        alertController.addAction(UIAlertAction(title: AppConstants.clearAllFilters, style: .destructive) { [weak self] _ in
            self?.viewModel.clearFilters()
        })
        
        alertController.addAction(UIAlertAction(title: AppConstants.cancel, style: .cancel))
        
        present(alertController, animated: true)
    }

}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.identifier,
            for: indexPath
        ) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard indexPath.item < viewModel.filteredProducts.count else {
            return UICollectionViewCell()
        }
        
        let product = viewModel.filteredProducts[indexPath.item]
        let isFavorite = FavoriteManager.shared.getFavoriteProductIds().contains(product.id)
        
        cell.delegate = self
        cell.configure(
            with: product,
            isFavorite: isFavorite
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Bounds checking to prevent crashes
        guard indexPath.item < viewModel.filteredProducts.count else {
            return
        }
        
        let product = viewModel.filteredProducts[indexPath.item]
        let detailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            // Son 100 pixel kaldığında yeni veri yükle
            if !viewModel.isLoading && viewModel.hasMoreData {
                viewModel.loadMoreProducts()
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleAddToCart(for product: Product) {
        CartManager.shared.addToCart(product: product)
    }
    
    private func handleFavoriteToggle(for product: Product) {
        viewModel.toggleFavorite(for: product)
        
        // Refresh the specific cell
        if let indexPath = viewModel.getIndexPathForProduct(product) {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 10 + 16 + 16
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / 2
        let cellHeight: CGFloat = 302
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isLoading && viewModel.hasMoreData {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.identifier,
                for: indexPath
            ) as! LoadingFooterView
            
            if viewModel.isLoading && viewModel.hasMoreData {
                footerView.startLoading()
            } else {
                footerView.stopLoading()
            }
            return footerView
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UITextFieldDelegate
extension ProductListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.immediateSearch(textField.text ?? "")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearSearch()
        return true
    }
}
extension ProductListViewController: Alertable {}
// MARK: - ProductListViewModelDelegate
extension ProductListViewController: ProductListViewModelDelegate {
    func productDidFetched() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.emptyStateLabel.isHidden = true
        }
    }
    
    func productDidNotFetched(_ error: any Error) {
        showAlert(title: AppConstants.appName, message: error.localizedDescription)
    }
    
    func loadingStateDidChange(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
            if self.viewModel.filteredProducts.isEmpty {
                self.collectionView.isHidden = isLoading
            } else {
                self.collectionView.isHidden = false
            }
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - ProductCollectionViewCellDelegate
extension ProductListViewController: ProductCollectionViewCellDelegate {
    func productCell(_ cell: ProductCollectionViewCell, didTapAddToCartFor product: Product) {
        handleAddToCart(for: product)
    }
    
    func productCell(_ cell: ProductCollectionViewCell, didTapFavoriteFor product: Product) {
        handleFavoriteToggle(for: product)
    }
}
