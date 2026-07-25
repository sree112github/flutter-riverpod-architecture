

    class CreateProductRequest {
      final String name;
      final double price;
      final int stockQuantity;

      CreateProductRequest({
        required this.name,
        required this.price,
        required this.stockQuantity,
      });

      Map<String, dynamic> toMap() {
        return {
          'name': name,
          'price': price,
          'stockQuantity': stockQuantity,
        };
      }
    }


    class UpdateProductRequest {
      final String id;
      final String? name;
      final double? price;
      final int? stockQuantity;

      UpdateProductRequest({
        required this.id,
        this.name,
        this.price,
        this.stockQuantity,
      });

      Map<String,dynamic> toJson(){
        final map = <String, dynamic>{};
        map['id'] = id;
        if(name != null && name!.isNotEmpty)  map['name'] = name;
          if(price != null) map['price'] = price;
          if(stockQuantity != null) map['stockQuantity'] = stockQuantity;
          return map;
      }

    }