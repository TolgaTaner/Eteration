//
//  CartViewController.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CartItemTableViewCell.self,
            forCellReuseIdentifier: CartItemTableViewCell.identifier
        )
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var totalContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.total
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstants.complete, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = AppColors.blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppImages.cartIcon(color: .systemGray3)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.cartEmpty
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.addProductsToGetStarted
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel = CartViewModel()
    
    func setSharedProductListViewModel(_ productListViewModel: ProductListViewModel) {
        viewModel.setSharedProductListViewModel(productListViewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCartItems()
        // updateUI() will be called by the delegate when cart items are loaded
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(appTitleLabel)
        view.addSubview(tableView)
        view.addSubview(totalContainerView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingIndicator)
        
        totalContainerView.addSubview(totalLabel)
        totalContainerView.addSubview(totalPriceLabel)
        totalContainerView.addSubview(checkoutButton)
        
        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyTitleLabel)
        emptyStateView.addSubview(emptySubtitleLabel)
    }
    
    private func setupConstraints() {
        let totalHeight = UIHeightCalculator.calculateTotalHeight(for: self)
        
        NSLayoutConstraint.activate([
            // Header Container View
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: totalHeight),
            
            // App Title Label
            appTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            appTitleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalContainerView.topAnchor),
            
            // Total Container View
            totalContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            totalContainerView.heightAnchor.constraint(equalToConstant: 140),
            
            // Checkout Button
            checkoutButton.centerYAnchor.constraint(equalTo: totalContainerView.centerYAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: totalContainerView.centerXAnchor, constant: 8),
            checkoutButton.trailingAnchor.constraint(equalTo: totalContainerView.trailingAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 38),
            
            // Total Label
            totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.centerYAnchor, constant: -4),
            totalLabel.leadingAnchor.constraint(equalTo: totalContainerView.leadingAnchor, constant: 16),
            
            // Total Price Label
            totalPriceLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalContainerView.leadingAnchor, constant: 16),
            
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
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        updateUI()
    }
    
    private func setupActions() {
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    private func updateUI() {
        let isEmpty = viewModel.cartItems.isEmpty
        
        tableView.isHidden = isEmpty
        totalContainerView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        
        if !isEmpty {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            let formattedNumber = formatter.string(from: NSNumber(value: viewModel.totalPrice)) ?? "0"
            totalPriceLabel.text = "\(formattedNumber) ₺"
        }
        
        tableView.reloadData()
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            totalContainerView.isHidden = true
            emptyStateView.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            updateUI()
        }
    }
    
    @objc private func checkoutButtonTapped() {
        let alert = UIAlertController(
            title: AppConstants.completeOrder,
            message: AppConstants.completeOrderConfirmation,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: AppConstants.cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: AppConstants.complete, style: .default) { [weak self] _ in
            self?.viewModel.completeOrder()
            
            let successAlert = UIAlertController(
                title: AppConstants.orderCompleted,
                message: AppConstants.orderCompletedMessage,
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: AppConstants.ok, style: .default))
            self?.present(successAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func handleQuantityChanged(for product: Product, newQuantity: Int) {
        print("CartViewController: handleQuantityChanged called for product \(product.name) with newQuantity \(newQuantity)") // Debug print
        
        if newQuantity == 0 {
            print("CartViewController: Removing product from cart") // Debug print
            viewModel.removeFromCart(product: product)
        } else {
            let currentQuantity = viewModel.cartItems.first { $0.product.id == product.id }?.quantity ?? 0
            print("CartViewController: Current quantity is \(currentQuantity)") // Debug print
            if newQuantity > currentQuantity {
                print("CartViewController: Increasing quantity") // Debug print
                viewModel.increaseQuantity(for: product)
            } else {
                print("CartViewController: Decreasing quantity") // Debug print
                viewModel.decreaseQuantity(for: product)
            }
        }
        viewModel.loadCartItems()
        updateUI()
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemTableViewCell.identifier,
            for: indexPath
        ) as? CartItemTableViewCell else {
            return UITableViewCell()
        }
        
        let cartItem = viewModel.cartItems[indexPath.row]
        
        cell.delegate = self
        cell.configure(with: cartItem)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cartItem = viewModel.cartItems[indexPath.row]
            viewModel.removeFromCart(product: cartItem.product)
            viewModel.loadCartItems()
            updateUI()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return AppConstants.remove
    }
}

// MARK: - CartViewModelDelegate
extension CartViewController: CartViewModelDelegate {
    func cartDidUpdate() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func loadingStateDidChange(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.updateLoadingState(isLoading)
        }
    }
}

// MARK: - CartItemTableViewCellDelegate
extension CartViewController: CartItemTableViewCellDelegate {
    func cartItemCell(_ cell: CartItemTableViewCell, didChangeQuantityFor product: Product, to newQuantity: Int) {
        print("CartViewController: cartItemCell delegate method called for product \(product.name) with quantity \(newQuantity)") // Debug print
        handleQuantityChanged(for: product, newQuantity: newQuantity)
    }
}
