import 'package:intl/intl.dart';

/// Utility class for formatting prices in the application
/// Following clean architecture principles - this is a core utility
class PriceFormatter {
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  /// Formats a price with "/night" suffix
  /// 
  /// [price] - The price value to format
  /// [currency] - Optional currency symbol (defaults to $)
  /// [showPerNight] - Whether to append "/night" (defaults to true)
  /// 
  /// Returns formatted string like "$50/night" or "$50"
  static String formatPricePerNight(
    double price, {
    String? currency,
    bool showPerNight = true,
  }) {
    final formattedPrice = _currencyFormatter.format(price);
    final priceWithCustomCurrency = currency != null 
        ? formattedPrice.replaceFirst('\$', currency)
        : formattedPrice;
    return showPerNight ? '$priceWithCustomCurrency/night' : priceWithCustomCurrency;
  }

  /// Formats a price range with "/night" suffix
  /// 
  /// [minPrice] - Minimum price
  /// [maxPrice] - Maximum price
  /// [currency] - Optional currency symbol (defaults to $)
  /// 
  /// Returns formatted string like "$30-$80/night"
  static String formatPriceRange(
    double minPrice,
    double maxPrice, {
    String? currency,
  }) {
    final minFormatted = _currencyFormatter.format(minPrice);
    final maxFormatted = _currencyFormatter.format(maxPrice);
    final minWithCustomCurrency = currency != null 
        ? minFormatted.replaceFirst('\$', currency)
        : minFormatted;
    final maxWithCustomCurrency = currency != null 
        ? maxFormatted.replaceFirst('\$', currency)
        : maxFormatted;
    return '$minWithCustomCurrency-$maxWithCustomCurrency/night';
  }

  /// Formats a price for display without "/night" suffix
  /// 
  /// [price] - The price value to format
  /// [currency] - Optional currency symbol (defaults to $)
  /// 
  /// Returns formatted string like "$50"
  static String formatPrice(double price, {String? currency}) {
    return formatPricePerNight(price, currency: currency, showPerNight: false);
  }
} 