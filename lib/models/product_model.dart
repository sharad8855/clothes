// Model for a single product variant (price info)
class ProductVariant {
  final String productVariantId;
  final double? buyingPrice;
  final double? regularPrice;
  final double? marketPrice;
  final double? discountedPrice;
  final double? discountAmount;
  final double totalDiscountPercentage;

  const ProductVariant({
    required this.productVariantId,
    this.buyingPrice,
    this.regularPrice,
    this.marketPrice,
    this.discountedPrice,
    this.discountAmount,
    this.totalDiscountPercentage = 0,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      productVariantId: json['product_variant_id'] as String? ?? '',
      buyingPrice: (json['buying_price'] as num?)?.toDouble(),
      regularPrice: (json['regular_price'] as num?)?.toDouble(),
      marketPrice: (json['market_price'] as num?)?.toDouble(),
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      totalDiscountPercentage:
          (json['total_discount_percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

// Model for product media
class ProductMedia {
  final String id;
  final String mediaUrl;
  final String mediaType;

  const ProductMedia({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    return ProductMedia(
      id: json['id'] as String? ?? '',
      mediaUrl: json['media_url'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? 'image',
    );
  }
}

// Model for product category
class ProductCategory {
  final String id;
  final String name;

  const ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

// Main Product model
class Product {
  final String productId;
  final String name;
  final String clientId;
  final String sku;
  final String slug;
  final String uniqueNumber;
  final double gst;
  final String currency;
  final bool isActive;
  final String inventoryStatus;
  final List<ProductMedia> media;
  final List<ProductVariant> variants;
  final List<ProductCategory> productCategory;

  const Product({
    required this.productId,
    required this.name,
    required this.clientId,
    required this.sku,
    required this.slug,
    required this.uniqueNumber,
    required this.gst,
    required this.currency,
    required this.isActive,
    required this.inventoryStatus,
    required this.media,
    required this.variants,
    required this.productCategory,
  });

  /// Convenience getter — returns the primary (first) variant's discounted/regular price
  double get displayPrice {
    if (variants.isEmpty) return 0;
    final v = variants.first;
    return v.discountedPrice ?? v.regularPrice ?? v.marketPrice ?? 0;
  }

  /// Convenience getter — returns the first media URL if available
  String? get primaryImageUrl {
    if (media.isEmpty) return null;
    return media.first.mediaUrl;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final mediaList = (json['media'] as List<dynamic>? ?? [])
        .map((m) => ProductMedia.fromJson(m as Map<String, dynamic>))
        .toList();

    final variantList = (json['variants'] as List<dynamic>? ?? [])
        .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
        .toList();

    final categoryList = (json['product_category'] as List<dynamic>? ?? [])
        .map((c) => ProductCategory.fromJson(c as Map<String, dynamic>))
        .toList();

    return Product(
      productId: json['product_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      clientId: json['client_id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      uniqueNumber: json['unique_number'] as String? ?? '',
      gst: (json['gst'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'INR',
      isActive: json['is_active'] as bool? ?? true,
      inventoryStatus: json['inventory_status'] as String? ?? 'available',
      media: mediaList,
      variants: variantList,
      productCategory: categoryList,
    );
  }
}

// Response wrapper for the get-products endpoint
class ProductListResponse {
  final bool success;
  final String message;
  final List<Product> data;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  const ProductListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();

    return ProductListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataList,
      totalCount: json['total_count'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 1,
    );
  }
}
