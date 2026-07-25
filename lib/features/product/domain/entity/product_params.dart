class CreateProductParams {
  final String name;
  final double price;
  final int stockQuantity;
  CreateProductParams({
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

}



class UpdateProductParams {
  final String id;
  final String? name;
  final double? price;
  final int? stockQuantity;

  UpdateProductParams({
    required this.id,
    this.name,
    this.price,
    this.stockQuantity,
  });

}
