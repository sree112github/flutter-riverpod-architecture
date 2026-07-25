

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/product/domain/entity/product.dart';
import 'package:grpc_app/features/product/domain/entity/product_params.dart';
import 'package:grpc_app/features/product/presentation/provider/product_provider.dart';

final productControllerProvider = AsyncNotifierProvider<ProductController,List<Product>>(
  () => ProductController(),
);

class ProductController extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    try {
      final res = await ref.read(productServiceProvider).getAllProducts();
      return res;
    } catch (e, st) {
  
      rethrow;
    }
  }

  Future<void> createProduct(CreateProductParams product) async {
    final prev = state.value;
    final service = ref.read(productServiceProvider);
    final newProduct = await service.createProduct(product);
    if (prev != null) {
      state = AsyncValue.data([...prev, newProduct]);
    }
  }

  Future<void> updateProduct(UpdateProductParams params) async {
    final prev = state.value;
    final service = ref.read(productServiceProvider);
    final updatedProduct = await service.updateProduct(params);
    if (prev != null) {
      final index = prev.indexWhere((p) => p.id == params.id);
      if (index != -1) {
        final updatedProducts = List<Product>.from(prev);
        updatedProducts[index] = updatedProduct;
        state = AsyncValue.data(updatedProducts);
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final prev = state.value;
    final service = ref.read(productServiceProvider);
    await service.deleteProduct(id);
    if (prev != null) {
      state = AsyncValue.data(prev.where((p) => p.id != id).toList());
    }
  }
}