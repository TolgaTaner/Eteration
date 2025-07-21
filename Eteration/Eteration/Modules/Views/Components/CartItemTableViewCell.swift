//
//  CartItemTableViewCell.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

protocol CartItemTableViewCellDelegate: AnyObject {
    func cartItemCell(_ cell: CartItemTableViewCell, didChangeQuantityFor product: Product, to newQuantity: Int)
}

final class CartItemTableViewCell: UITableViewCell {
    
    static let identifier = AppConstants.cartItemTableViewCellId
    
    weak var delegate: CartItemTableViewCellDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = AppColors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quantityContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle(AppConstants.decreaseSymbol, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = AppColors.blue
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle(AppConstants.increaseSymbol, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var cartItem: CartItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(contentStackView)
        containerView.addSubview(quantityContainerView)
        
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(brandLabel)
        contentStackView.addArrangedSubview(priceLabel)
        
        quantityContainerView.addSubview(quantityStackView)
        quantityStackView.addArrangedSubview(decreaseButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(increaseButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Content Stack View
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // Quantity Container
            quantityContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            quantityContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 157),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 42),
            
            // Quantity Stack View
            quantityStackView.topAnchor.constraint(equalTo: quantityContainerView.topAnchor),
            quantityStackView.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor),
            quantityStackView.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor),
            quantityStackView.bottomAnchor.constraint(equalTo: quantityContainerView.bottomAnchor),
            
            // Quantity Controls
            decreaseButton.widthAnchor.constraint(equalToConstant: 52),
            decreaseButton.heightAnchor.constraint(equalToConstant: 42),
            
            increaseButton.widthAnchor.constraint(equalToConstant: 52),
            increaseButton.heightAnchor.constraint(equalToConstant: 42),
            
            quantityLabel.widthAnchor.constraint(equalToConstant: 53),
            quantityLabel.heightAnchor.constraint(equalToConstant: 42),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityStackView.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
    }
    
    @objc private func increaseButtonTapped() {
        guard let cartItem = cartItem else { return }
        let newQuantity = cartItem.quantity + 1
        delegate?.cartItemCell(self, didChangeQuantityFor: cartItem.product, to: newQuantity)
    }
    
    @objc private func decreaseButtonTapped() {
        guard let cartItem = cartItem, cartItem.quantity > 1 else { return }
        let newQuantity = cartItem.quantity - 1
        delegate?.cartItemCell(self, didChangeQuantityFor: cartItem.product, to: newQuantity)
    }
    
    func configure(with cartItem: CartItem) {
        self.cartItem = cartItem
        nameLabel.text = cartItem.product.name
        brandLabel.text = cartItem.product.brand
        priceLabel.text = cartItem.formattedTotalPrice
        quantityLabel.text = "\(cartItem.quantity)"
    }
} 
