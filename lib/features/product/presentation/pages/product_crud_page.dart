import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc_app/features/product/domain/entity/product.dart';
import 'package:grpc_app/features/product/domain/entity/product_params.dart';
import 'package:grpc_app/features/product/presentation/controller/product_controller.dart';
import 'package:grpc_app/features/user/presentation/controller/current_user_controller.dart';

class ProductCrudPage extends ConsumerWidget {
  const ProductCrudPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productControllerProvider);
    final currentUserState = ref.watch(currentUserControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: currentUserState.when(
          data: (user) => Text(user != null ? 'Products (${user.name})' : 'Product Inventory'),
          loading: () => const Text('Loading user...'),
          error: (_, __) => const Text('Product Inventory'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              context.push('/profile');
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (productState.hasError) {
            return Center(
              child: Text(
                'Error: ${productState.error}\nTap to retry',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (productState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (productState.hasValue) {
            final products = productState.value!;
            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductListItem(
                  product: product,
                  onEdit: () => _showProductDialog(context, ref, product: product),
                );
              },
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductDialog(BuildContext context, WidgetRef ref, {Product? product}) {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product != null ? product.price.toString() : '');
    final stockController = TextEditingController(text: product != null ? product.stockQuantity.toString() : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Product' : 'Add Product'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Name is required';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Price is required';
                          final price = double.tryParse(val);
                          if (price == null) return 'Enter a valid number';
                          if (price <= 0) return 'Price must be greater than 0';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: stockController,
                        decoration: const InputDecoration(labelText: 'Stock Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Stock Quantity is required';
                          final stock = int.tryParse(val);
                          if (stock == null) return 'Enter a valid integer';
                          if (stock < 0) return 'Stock cannot be negative';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isSaving = true);
                            try {
                              if (isEditing) {
                                await ref.read(productControllerProvider.notifier).updateProduct(
                                  UpdateProductParams(
                                    id: product.id,
                                    name: nameController.text.trim(),
                                    price: double.parse(priceController.text),
                                    stockQuantity: int.parse(stockController.text),
                                  ),
                                );
                              } else {
                                await ref.read(productControllerProvider.notifier).createProduct(
                                  CreateProductParams(
                                    name: nameController.text.trim(),
                                    price: double.parse(priceController.text),
                                    stockQuantity: int.parse(stockController.text),
                                  ),
                                );
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isEditing ? 'Product updated successfully' : 'Product added successfully')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() => isSaving = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          }
                        },
                  child: isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ProductListItem extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback onEdit;

  const ProductListItem({super.key, required this.product, required this.onEdit});

  @override
  ConsumerState<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends ConsumerState<ProductListItem> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final outOfStock = widget.product.stockQuantity == 0;

    return ListTile(
      title: Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\$${widget.product.price.toStringAsFixed(2)}'),
          Text(
            outOfStock ? 'Out of Stock' : 'In Stock: ${widget.product.stockQuantity}',
            style: TextStyle(
              color: outOfStock ? Colors.red : Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: _isDeleting ? null : widget.onEdit,
          ),
          IconButton(
            icon: _isDeleting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.delete, color: Colors.red),
            onPressed: _isDeleting
                ? null
                : () async {
                    setState(() => _isDeleting = true);
                    try {
                      await ref.read(productControllerProvider.notifier).deleteProduct(widget.product.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product deleted successfully')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        setState(() => _isDeleting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}
