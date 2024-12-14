# hackerkernal
This is a Flutter app that allows users to log in, manage products, and search for products. The app provides functionality for creating and deleting products, as well as a search bar to filter through the product list. The product data is stored in SharedPreferences for persistent storage.

Features
1. Login Page
Email and Password Login: Users can log in with email and password.
Login API: The app uses the https://reqres.in/api/login API to authenticate the user.
POST Method
Request Body:
json
Copy code
{
  "email": "eve.holt@reqres.in",
  "password": "pistol"
}
Navigation: Upon successful login, users are redirected to the Home Page.
Logout: The home page includes a logout option to exit the session.
Access Control: Users cannot access the Home Page without logging in. Once logged in, the Login Page is inaccessible.
2. Home Page
Search Bar: Users can search products by name.
Product List: Displays all added products, showing their names, prices, and an option to delete.
Delete Product: Each product has a delete icon that allows users to remove it from the list.
Add Product: Users can navigate to the "Add Product" page via a floating action button.
3. Add Product Page
Form to Add Product:
Product Name (Required)
Product Price (Required)
Product Image (Optional)
Add Button to submit the form and save the product.
Validation: The form validates that both name and price are provided before submission.
No Product Duplicacy: Products cannot be added more than once.
4. Product Storage
Products are stored in SharedPreferences for persistence.
When no products are added, a message "No Product Found" is displayed.
5. Loading and Error Handling
Each API call is accompanied by a loading indicator.
Errors are handled and displayed using Snackbar or Toast.
Technologies Used
Flutter: Cross-platform mobile development framework.
SharedPreferences: Used to persist the product data.
HTTP: Used for making API requests to the backend.
