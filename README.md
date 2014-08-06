# Tapiture iOS Shopping Cart
#### By Bennett Lee

### Demo

![Alt text](demo.gif)

### Description
The “Tapiture iOS Shopping Cart” provides users with a seamless shopping experience within the Tapiture iOS application. Users now have the ability to select different options of a product (size, color, material, etc.), add products to a local shopping cart, and update or remove cart items.

Note: This application includes the ENTIRE user flow (from waterfall -> product -> shopping cart -> checkout page).

### Product Flow Overview

![Alt text](Shopping-Cart-Flow.png)

The following is a list of the most important features implemented in “Tapiture iOS Shopping Cart”:

### ProductDetailView Integration
* Options selection
	* Select a combination of options for a particular product (i.e. size, color, material, etc)
* "Add To Cart" Button, users can add a product to cart.
* "Notify Me" Button
	* If all variations of a product are out of stock, “Add To Cart” Button will be replaced by “Notify Me” Button

### OptionsDetailView
* Displays different variation of the same option category for users to select.
	* Example: Option Category: “Size”. Option Values: “S, M, L, XL”.
* If an option is “Out of Stock”, user can tap the option to be notified when product is back in stock.

## Back In Stock Notification
* Placeholder code is embedded to integrate Tapiture’s shopping cart with “Back In Stock API”

### Shopping Cart
* Persistent storage of shopping cart data on device. If user exits the Tapiture application, their cart information will still be saved on their local devices.
* Update cart item quantity
* Remove cart items
* Displays total item count and subtotal
* Checkout: Displays a web view with Shopify’s checkout webpage



