import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/negotiations_provider.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'widgets/main_layout.dart';

void main() {
  // Add error handling for Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  
  runApp(const MyApp());
}

// Create a key for the Navigator state to allow forced rebuilds if needed
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NegotiationsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'FarmConnect',
        navigatorKey: navigatorKey, // Use the global navigator key
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green,
            secondary: Colors.orange,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
          useMaterial3: true,
        ),
        home: const MainLayout(),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
          ChatScreen.routeName: (ctx) => const ChatScreen(),
          // For routes with required parameters, better to use onGenerateRoute
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case PaymentScreen.routeName:
              try {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  settings: settings, // Keep the original settings
                  builder: (ctx) => PaymentScreen(
                    totalAmount: args?['totalAmount'] ?? 0.0,
                    customerEmail: args?['customerEmail'] ?? '',
                    deliveryMethod: args?['deliveryMethod'] ?? 'Standard',
                    deliveryCharge: args?['deliveryCharge'] ?? 5.0,
                  ),
                );
              } catch (e) {
                print('Error in onGenerateRoute for PaymentScreen: $e');
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) => const PaymentScreen(
                    totalAmount: 0,
                    customerEmail: '',
                    deliveryMethod: 'Standard',
                    deliveryCharge: 5.0,
                  ),
                );
              }
              
            case OrderConfirmationScreen.routeName:
              try {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) => OrderConfirmationScreen(
                    transactionId: args?['transactionId'] ?? '',
                    amount: args?['amount'] ?? 0.0,
                    customerEmail: args?['customerEmail'] ?? '',
                    deliveryMethod: args?['deliveryMethod'] ?? 'Standard Delivery',
                    estimatedDelivery: args?['estimatedDelivery'] ?? '',
                  ),
                );
              } catch (e) {
                print('Error in onGenerateRoute for OrderConfirmationScreen: $e');
                return MaterialPageRoute(
                  settings: settings,
                  builder: (ctx) => const OrderConfirmationScreen(
                    transactionId: '',
                    amount: 0,
                    customerEmail: '',
                    deliveryMethod: 'Standard Delivery',
                    estimatedDelivery: '',
                  ),
                );
              }
              
            default:
              return null;
          }
        },
        // Handle unknown routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (ctx) => const MainLayout(),
          );
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
