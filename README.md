# Eteration - iOS E-commerce App

A modern iOS e-commerce application built with Swift and UIKit, featuring a clean MVVM architecture and comprehensive shopping cart functionality.

## 📱 Features

### Core Functionality
- **Product Browsing**: Browse and search through product catalog
- **Product Details**: Detailed product information with images and specifications
- **Shopping Cart**: Add, remove, and manage items in cart
- **Favorites**: Save and manage favorite products
- **Real-time Updates**: Live cart and favorites synchronization across views

### User Experience
- **Smooth Animations**: Responsive button animations and transitions
- **Loading States**: Proper loading indicators during data fetching
- **Error Handling**: User-friendly error messages and fallbacks
- **Modern UI**: Clean, intuitive interface with proper spacing and typography

## 🏗️ Architecture

### MVVM Pattern
- **Models**: Product, CartItem, and data models
- **ViewModels**: Business logic and data management
- **Views**: UI components and user interactions
- **Delegates**: Communication between ViewModels and Views

### Key Components

#### ViewModels
- `ProductListViewModel`: Manages product listing, search, and filtering
- `CartViewModel`: Handles cart operations and item management
- `ProductDetailViewModel`: Manages product details and interactions
- `FavoriteViewModel`: Manages favorites functionality

#### Views
- `ProductListViewController`: Main product browsing interface
- `CartViewController`: Shopping cart management
- `ProductDetailViewController`: Detailed product view
- `FavoritesViewController`: Saved products management
- `MainTabBarController`: Navigation and tab management

#### Services
- `APIClient`: Network layer for data fetching
- `CartManager`: Core Data integration for cart persistence
- `FavoriteManager`: Local storage for favorites

## 🛠️ Technical Stack

### Core Technologies
- **Swift**: Primary programming language
- **UIKit**: User interface framework
- **Core Data**: Local data persistence
- **Kingfisher**: Image loading and caching
- **Auto Layout**: Responsive UI design

### Dependencies
- **Kingfisher**: Image loading and caching library
- **Core Data**: Local data persistence framework

## 📁 Project Structure

```
Eteration/
├── Eteration/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Modules/
│   │   ├── Views/
│   │   │   ├── MainTabBarController.swift
│   │   │   ├── ProductListViewController.swift
│   │   │   ├── ProductDetailViewController.swift
│   │   │   ├── CartViewController.swift
│   │   │   ├── FavoritesViewController.swift
│   │   │   └── Components/
│   │   │       ├── ProductCollectionViewCell.swift
│   │   │       └── CartItemTableViewCell.swift
│   │   └── ViewModels/
│   │       ├── ProductListViewModel.swift
│   │       ├── CartViewModel.swift
│   │       ├── ProductDetailViewModel.swift
│   │       └── FavoriteViewModel.swift
│   ├── Networking/
│   │   ├── Base/
│   │   │   ├── APIClient.swift
│   │   │   ├── APIError.swift
│   │   │   └── Endpoint.swift
│   │   ├── Model/
│   │   │   └── Product.swift
│   │   └── Client/
│   │       └── ProductClient.swift
│   ├── CoreData/
│   │   └── CoreDataManager.swift
│   ├── Utilities/
│   │   ├── AppColors.swift
│   │   ├── AppConstants.swift
│   │   ├── CartManager.swift
│   │   ├── FavoriteManager.swift
│   │   └── UIHeightCalculator.swift
│   └── Assets.xcassets/
├── EterationTests/
└── EterationUITests/
```

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.0 or later

### Installation
1. Clone the repository
2. Open `Eteration.xcodeproj` in Xcode
3. Build and run the project on a simulator or device

### Configuration
- Update API endpoints in `Networking/Base/Endpoint.swift` if needed
- Configure Core Data model if required
- Adjust UI constants in `Utilities/AppConstants.swift`

## 🎨 UI/UX Features

### Design System
- **Colors**: Consistent color scheme with primary blue theme
- **Typography**: System fonts with proper weight hierarchy
- **Spacing**: Consistent margins and padding throughout
- **Animations**: Subtle animations for better user feedback

### Navigation
- **Tab Bar**: Home, Cart, Favorites, and Profile tabs
- **Navigation Controller**: Proper back navigation and titles
- **Modal Presentations**: Product detail modals

## 🔧 Key Features Implementation

### Shopping Cart
- **Add to Cart**: Products can be added from list and detail views
- **Quantity Management**: Increase/decrease quantities in cart
- **Remove Items**: Swipe to delete or remove when quantity reaches zero
- **Total Calculation**: Real-time total price updates
- **Persistence**: Cart data persists using Core Data

### Favorites System
- **Toggle Favorites**: Add/remove products from favorites
- **Visual Feedback**: Star icons with proper states
- **Persistence**: Favorites stored locally
- **Synchronization**: Updates across all views

### Product Management
- **Search & Filter**: Product search and filtering capabilities
- **Sorting**: Multiple sorting options
- **Pagination**: Efficient loading of large product lists
- **Image Caching**: Optimized image loading with Kingfisher

## 🧪 Testing

### Unit Tests
- `ProductListViewModelTests`: Comprehensive testing of product list functionality
- Mock implementations for API client and delegates
- Async/await testing for network operations

### Test Coverage
- ViewModel business logic
- Network layer functionality
- Data persistence operations
- UI interaction flows

## 📱 Screenshots

*[Add screenshots of the main app screens here]*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Tolga Taner**
- Created on: 18.07.2025
- Contact: [Add contact information]

## 🙏 Acknowledgments

- Kingfisher library for image handling
- Core Data for local persistence
- UIKit for the user interface framework
- Swift community for best practices and patterns

---

**Note**: This is a demonstration project showcasing modern iOS development practices with MVVM architecture, Core Data integration, and comprehensive e-commerce functionality. 