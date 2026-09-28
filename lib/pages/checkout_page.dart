```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../UiHelper/checkoutpage_textfield_helper.dart';
import '../services/cart_service.dart';
import '../services/order_service.dart';
import 'order_success.dart';

class CheckoutScreen extends StatefulWidget {
const CheckoutScreen({super.key});

@override
State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
final CartService cartService = CartService();
final OrderService orderService = OrderService();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController stateController = TextEditingController();
final TextEditingController pincodeController = TextEditingController();

String selectedPaymentMethod = "Cash on Delivery";

bool isPlacingOrder = false;

@override
void dispose() {
nameController.dispose();
phoneController.dispose();
addressController.dispose();
cityController.dispose();
stateController.dispose();
pincodeController.dispose();

super.dispose();
}

@override
Widget build(BuildContext context) {
final items = cartService.items;

return Scaffold(
backgroundColor: const Color(0xFFF8F8F8),

// ================================================================
// APP BAR
// ================================================================
appBar: AppBar(
backgroundColor: Colors.amber,
elevation: 0,
centerTitle: false,

leading: IconButton(
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
color: Colors.black,
size: 20,
),
onPressed: () {
Navigator.pop(context);
},
),

title: Text(
"CHECKOUT",
style: GoogleFonts.poppins(
color: Colors.black,
fontSize: 21,
fontWeight: FontWeight.w700,
),
),
),

// ================================================================
// BODY
// ================================================================
body: Form(
key: _formKey,

child: Column(
children: [
Expanded(
child: SingleChildScrollView(
padding: const EdgeInsets.all(18),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
// ======================================================
// DELIVERY ADDRESS
// ======================================================
_sectionTitle(
icon: Icons.location_on_outlined,
title: "Delivery Address",
),

const SizedBox(height: 12),

Container(
padding: const EdgeInsets.all(16),

decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),

boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.04),
blurRadius: 12,
offset: const Offset(0, 4),
),
],
),

child: Column(
children: [
// ==================================================
// NAME
// ==================================================
CheckOutpageTextFieldHelper(
controller: nameController,
label: "Full Name",
hint: "Enter your full name",
icon: Icons.person_outline,
keyboardType: TextInputType.name,

validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Please enter your name";
}

if (value.trim().length < 2) {
return "Please enter a valid name";
}

return null;
},
),

const SizedBox(height: 14),

// ==================================================
// PHONE
// ==================================================
CheckOutpageTextFieldHelper(
controller: phoneController,
label: "Phone Number",
hint: "Enter 10-digit phone number",
icon: Icons.phone_outlined,
keyboardType: TextInputType.phone,
maxLength: 10,

validator: (value) {
final phone = value?.trim() ?? "";

if (phone.isEmpty) {
return "Please enter phone number";
}

if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
return "Enter a valid 10-digit number";
}

return null;
},
),

const SizedBox(height: 14),

// ==================================================
// ADDRESS
// ==================================================
CheckOutpageTextFieldHelper(
controller: addressController,
label: "Address",
hint: "House no., street, area",
icon: Icons.home_outlined,
keyboardType: TextInputType.streetAddress,
maxLines: 2,

validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Please enter your address";
}

if (value.trim().length < 5) {
return "Please enter a complete address";
}

return null;
},
),

const SizedBox(height: 14),

// ==================================================
// CITY
// ==================================================
CheckOutpageTextFieldHelper(
controller: cityController,
label: "City",
hint: "Enter your city",
icon: Icons.location_city_outlined,
keyboardType: TextInputType.streetAddress,

validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Please enter your city";
}

return null;
},
),

const SizedBox(height: 14),

// ==================================================
// STATE
// ==================================================
CheckOutpageTextFieldHelper(
controller: stateController,
label: "State",
hint: "Enter your state",
icon: Icons.map_outlined,
keyboardType: TextInputType.streetAddress,

validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Please enter your state";
}

return null;
},
),

const SizedBox(height: 14),

// ==================================================
// PINCODE
// ==================================================
CheckOutpageTextFieldHelper(
controller: pincodeController,
label: "Pincode",
hint: "Enter 6-digit pincode",
icon: Icons.pin_drop_outlined,
keyboardType: TextInputType.number,
maxLength: 6,

validator: (value) {
final pincode = value?.trim() ?? "";

if (pincode.isEmpty) {
return "Please enter pincode";
}

if (!RegExp(r'^[0-9]{6}$')
    .hasMatch(pincode)) {
return "Enter a valid 6-digit pincode";
}

return null;
},
),
],
),
),

const SizedBox(height: 25),

// ======================================================
// PAYMENT METHOD
// ======================================================
_sectionTitle(
icon: Icons.payment_outlined,
title: "Payment Method",
),

const SizedBox(height: 12),

Container(
padding: const EdgeInsets.all(15),

decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),

border: Border.all(
color: Colors.amber.shade300,
width: 1.2,
),
),

child: Row(
children: [
Container(
width: 48,
height: 48,

decoration: BoxDecoration(
color: Colors.amber.shade50,
borderRadius: BorderRadius.circular(14),
),

child: Icon(
Icons.local_atm_rounded,
color: Colors.amber.shade800,
size: 25,
),
),

const SizedBox(width: 14),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
Text(
"Cash on Delivery",
style: GoogleFonts.poppins(
fontSize: 15,
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 3),

Text(
"Pay when your order is delivered",
style: GoogleFonts.poppins(
fontSize: 11,
color: Colors.grey.shade600,
),
),
],
),
),

Radio<String>(
value: "Cash on Delivery",
groupValue: selectedPaymentMethod,
activeColor: Colors.amber.shade800,

onChanged: (value) {
if (value == null) {
return;
}

setState(() {
selectedPaymentMethod = value;
});
},
),
],
),
),

const SizedBox(height: 25),

// ======================================================
// ORDER SUMMARY
// ======================================================
_sectionTitle(
icon: Icons.shopping_bag_outlined,
title: "Order Summary",
),

const SizedBox(height: 12),

Container(
padding: const EdgeInsets.all(16),

decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
),

child: Column(
children: [
// ==================================================
// PRODUCTS
// ==================================================
...items.map(
(item) {
return Padding(
padding:
const EdgeInsets.only(bottom: 14),

child: Row(
children: [
// PRODUCT IMAGE
Container(
width: 55,
height: 55,

padding: const EdgeInsets.all(6),

decoration: BoxDecoration(
color: Colors.amber.shade50,
borderRadius:
BorderRadius.circular(12),
),

child: Image.asset(
item.product.image,
fit: BoxFit.contain,

errorBuilder: (_, __, ___) {
return const Icon(
Icons
    .image_not_supported_outlined,
color: Colors.grey,
);
},
),
),

const SizedBox(width: 12),

// PRODUCT NAME
Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Text(
item.product.text,
maxLines: 1,
overflow:
TextOverflow.ellipsis,

style: GoogleFonts.poppins(
fontSize: 13,
fontWeight:
FontWeight.w600,
),
),

const SizedBox(height: 4),

Text(
"Qty: ${item.quantity}",

style: GoogleFonts.poppins(
fontSize: 11,
color:
Colors.grey.shade600,
),
),
],
),
),

// ITEM TOTAL
Text(
"₹${item.totalPrice.toStringAsFixed(0)}",

style: GoogleFonts.poppins(
fontSize: 14,
fontWeight: FontWeight.w700,
),
),
],
),
);
},
),

Divider(
color: Colors.grey.shade200,
),

const SizedBox(height: 10),

// ITEMS TOTAL
_priceRow(
"Items",
"₹${cartService.totalAmount.toStringAsFixed(0)}",
),

const SizedBox(height: 8),

// DELIVERY
_priceRow(
"Delivery",
"FREE",
valueColor: Colors.green.shade700,
),

const SizedBox(height: 10),

Divider(
color: Colors.grey.shade200,
),

const SizedBox(height: 10),

// FINAL TOTAL
_priceRow(
"Total",
"₹${cartService.totalAmount.toStringAsFixed(0)}",
isTotal: true,
),
],
),
),

const SizedBox(height: 20),

// ======================================================
// COD INFORMATION
// ======================================================
Container(
padding: const EdgeInsets.all(14),

decoration: BoxDecoration(
color: Colors.amber.shade50,
borderRadius: BorderRadius.circular(16),
),

child: Row(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Icon(
Icons.info_outline_rounded,
color: Colors.amber.shade800,
size: 20,
),

const SizedBox(width: 10),

Expanded(
child: Text(
"Please keep the exact order amount ready when your order is delivered.",

style: GoogleFonts.poppins(
fontSize: 11,
height: 1.5,
color: Colors.grey.shade700,
),
),
),
],
),
),

const SizedBox(height: 100),
],
),
),
),

// ================================================================
// PLACE ORDER BUTTON
// ================================================================
Container(
padding: const EdgeInsets.fromLTRB(
18,
14,
18,
14,
),

decoration: BoxDecoration(
color: Colors.white,

boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.08),
blurRadius: 15,
offset: const Offset(0, -4),
),
],
),

child: SafeArea(
top: false,

child: SizedBox(
width: double.infinity,
height: 55,

child: ElevatedButton(
onPressed:
isPlacingOrder || items.isEmpty
? null
    : _placeOrder,

style: ElevatedButton.styleFrom(
backgroundColor: Colors.black,
foregroundColor: Colors.white,
disabledBackgroundColor:
Colors.grey.shade300,
elevation: 0,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(17),
),
),

child: isPlacingOrder
? const SizedBox(
width: 24,
height: 24,

child: CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
)
    : Row(
mainAxisAlignment:
MainAxisAlignment.center,

children: [
const Icon(
Icons
    .check_circle_outline_rounded,
size: 21,
),

const SizedBox(width: 9),

Text(
"Place Order • ₹${cartService.totalAmount.toStringAsFixed(0)}",

style: GoogleFonts.poppins(
fontSize: 14,
fontWeight: FontWeight.w700,
),
),
],
),
),
),
),
),
],
),
),
);
}

// ========================================================================
// PLACE ORDER
// ========================================================================

void _placeOrder() {
if (!_formKey.currentState!.validate()) {
return;
}

if (cartService.items.isEmpty) {
_showMessage("Your cart is empty");
return;
}

_showOrderConfirmation();
}

// ========================================================================
// CONFIRM ORDER
// ========================================================================

void _showOrderConfirmation() {
showModalBottomSheet(
context: context,
backgroundColor: Colors.white,

shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(28),
),
),

builder: (bottomSheetContext) {
return Padding(
padding: const EdgeInsets.fromLTRB(
22,
25,
22,
25,
),

child: SafeArea(
child: Column(
mainAxisSize: MainAxisSize.min,

children: [
// DRAG HANDLE
Container(
width: 55,
height: 5,

decoration: BoxDecoration(
color: Colors.grey.shade300,
borderRadius: BorderRadius.circular(10),
),
),

const SizedBox(height: 25),

// ICON
Container(
width: 70,
height: 70,

decoration: BoxDecoration(
color: Colors.green.shade50,
shape: BoxShape.circle,
),

child: Icon(
Icons.shopping_bag_outlined,
size: 35,
color: Colors.green.shade700,
),
),

const SizedBox(height: 18),

// TITLE
Text(
"Confirm Your Order",

style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 8),

// DESCRIPTION
Text(
"Your order will be placed with Cash on Delivery.",

textAlign: TextAlign.center,

style: GoogleFonts.poppins(
fontSize: 12,
color: Colors.grey.shade600,
),
),

const SizedBox(height: 20),

// ORDER DETAILS
Container(
padding: const EdgeInsets.all(15),

decoration: BoxDecoration(
color: Colors.grey.shade50,
borderRadius: BorderRadius.circular(16),
),

child: Column(
children: [
_confirmationRow(
"Payment",
selectedPaymentMethod,
),

const SizedBox(height: 8),

_confirmationRow(
"Total",
"₹${cartService.totalAmount.toStringAsFixed(0)}",
),
],
),
),

const SizedBox(height: 20),

Row(
children: [
// ========================================================
// CANCEL
// ========================================================
Expanded(
child: OutlinedButton(
onPressed: () {
Navigator.pop(bottomSheetContext);
},

style: OutlinedButton.styleFrom(
foregroundColor: Colors.black,

side: const BorderSide(
color: Colors.black12,
),

minimumSize:
const Size(double.infinity, 52),

shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),

child: Text(
"Cancel",

style: GoogleFonts.poppins(
fontWeight: FontWeight.w600,
),
),
),
),

const SizedBox(width: 12),

// ========================================================
// CONFIRM
// ========================================================
Expanded(
child: ElevatedButton(
onPressed: () async {
Navigator.pop(bottomSheetContext);

await _saveOrder();
},

style: ElevatedButton.styleFrom(
backgroundColor: Colors.black,
foregroundColor: Colors.white,

minimumSize:
const Size(double.infinity, 52),

elevation: 0,

shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),

child: Text(
"Confirm Order",

style: GoogleFonts.poppins(
fontSize: 13,
fontWeight: FontWeight.w700,
),
),
),
),
],
),
],
),
),
);
},
);
}

// ========================================================================
// SAVE ORDER TO FIREBASE
// ========================================================================

Future<void> _saveOrder() async {
if (isPlacingOrder) {
return;
}

if (cartService.items.isEmpty) {
_showMessage("Your cart is empty");
return;
}

setState(() {
isPlacingOrder = true;
});

try {
final String orderId = await orderService.placeOrder(
name: nameController.text.trim(),
phone: phoneController.text.trim(),
address: addressController.text.trim(),
city: cityController.text.trim(),
state: stateController.text.trim(),
pincode: pincodeController.text.trim(),
paymentMethod: selectedPaymentMethod,
);

// ================================================================
// IMPORTANT:
// Clear cart ONLY after Firebase successfully creates the order.
// ================================================================
cartService.clearCart();

if (!mounted) {
return;
}

Navigator.pushReplacement(
context,

MaterialPageRoute(
builder: (_) => OrderSuccessScreen(
orderId: orderId,
),
),
);
} catch (e) {
if (!mounted) {
return;
}

_showMessage(
"Could not place order. Please try again.",
);
} finally {
if (mounted) {
setState(() {
isPlacingOrder = false;
});
}
}
}

// ========================================================================
// SECTION TITLE
// ========================================================================

Widget _sectionTitle({
required IconData icon,
required String title,
}) {
return Row(
children: [
Container(
width: 40,
height: 40,

decoration: BoxDecoration(
color: Colors.amber.shade50,
borderRadius: BorderRadius.circular(12),
),

child: Icon(
icon,
color: Colors.amber.shade800,
size: 21,
),
),

const SizedBox(width: 10),

Text(
title,

style: GoogleFonts.poppins(
fontSize: 17,
fontWeight: FontWeight.w700,
),
),
],
);
}

// ========================================================================
// PRICE ROW
// ========================================================================

Widget _priceRow(
String title,
String value, {
bool isTotal = false,
Color? valueColor,
}) {
return Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
title,

style: GoogleFonts.poppins(
fontSize: isTotal ? 16 : 13,
fontWeight:
isTotal
? FontWeight.w700
    : FontWeight.w500,
color:
isTotal
? Colors.black
    : Colors.grey.shade600,
),
),

Text(
value,

style: GoogleFonts.poppins(
fontSize: isTotal ? 19 : 13,
fontWeight: FontWeight.w700,
color: valueColor ?? Colors.black,
),
),
],
);
}

// ========================================================================
// CONFIRMATION ROW
// ========================================================================

Widget _confirmationRow(
String title,
String value,
) {
return Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
title,

style: GoogleFonts.poppins(
fontSize: 12,
color: Colors.grey.shade600,
),
),

Text(
value,

style: GoogleFonts.poppins(
fontSize: 12,
fontWeight: FontWeight.w700,
),
),
],
);
}

// ========================================================================
// SNACKBAR
// ========================================================================

void _showMessage(String message) {
if (!mounted) {
return;
}

ScaffoldMessenger.of(context)
    .hideCurrentSnackBar();

ScaffoldMessenger.of(context)
    .showSnackBar(
SnackBar(
content: Text(
message,

style: GoogleFonts.poppins(
fontSize: 13,
fontWeight: FontWeight.w500,
),
),

backgroundColor: Colors.black,

behavior: SnackBarBehavior.floating,

margin: const EdgeInsets.all(15),

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
),
);
}
}
```

### One important thing

Your `checkoutpage_textfield_helper.dart` must be the corrected version from the previous message, with this constructor:

```dart
const CheckOutpageTextFieldHelper({
super.key,
required this.controller,
required this.label,
required this.hint,
required this.icon,
this.validator,
this.keyboardType,
this.maxLines = 1,
this.maxLength,
});
```

Then your structure is:

```text
CheckoutScreen
│
├── CheckOutpageTextFieldHelper
│      ├── Full Name
│      ├── Phone
│      ├── Address
│      ├── City
│      ├── State
│      └── Pincode
│
├── Payment Method
│      └── Cash on Delivery
│
├── Order Summary
│
└── Place Order
│
├── Validate form
├── Confirmation bottom sheet
├── OrderService.placeOrder()
├── Clear cart
└── OrderSuccessScreen
```

**The biggest compile error in your original code was `_textField`**. I replaced every `_textField()` call with your reusable `CheckOutpageTextFieldHelper`, so you don't need a separate `_textField()` method anymore.
