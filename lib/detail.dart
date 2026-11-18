import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'apiservis.dart';
import 'cart.dart';
import 'data.dart';

class DetailPage extends StatefulWidget {
  final int productId;
  final String username;
  const DetailPage({super.key, required this.productId, required this.username});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> _future = ApiService.getProduct(widget.productId);

  String get _cartKey => '${widget.username}|${widget.productId}';

  void _toggleCart(Product p, bool inCart) {
    final box = Hive.box('cart');
    if (inCart) {
      box.delete(_cartKey);
    } else {
      box.put(_cartKey, p.toCartMap(widget.username));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(inCart
            ? 'Dihapus dari keranjang'
            : 'Ditambahkan ke keranjang'
            )
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CartPage(username: widget.username))),
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Error: ${snap.error}'),
                TextButton(
                    onPressed: () => setState(
                        () => _future = ApiService.getProduct(widget.productId)),
                    child: const Text('Coba lagi')),
              ]),
            );
          }
          final p = snap.data!;
          return ListView(padding: const EdgeInsets.all(16), children: [
            // Hero image: paling atas & besar
            Container(
              height: 300,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Image.network(
                p.image,
                fit: BoxFit.contain,
                loadingBuilder: (c, child, prog) => prog == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),
            const SizedBox(height: 16),
            Text(p.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text('${p.rating.toStringAsFixed(1)} (${p.ratingCount} review)'),
            ]),
            const Divider(height: 24),
            const Text('Deskripsi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(p.description),
            const SizedBox(height: 24),
            // Tombol berubah sesuai status produk di keranjang
            ValueListenableBuilder(
              valueListenable: Hive.box('cart').listenable(keys: [_cartKey]),
              builder: (context, Box b, _) {
                final inCart = b.containsKey(_cartKey);
                return SizedBox(
                  width: double.infinity,
                  child: inCart
                      ? FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () => _toggleCart(p, true),
                          icon: const Icon(Icons.remove_shopping_cart),
                          label: const Text('Remove from Cart'),
                        )
                      : FilledButton.icon(
                          onPressed: () => _toggleCart(p, false),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                );
              },
            ),
          ]);
        },
      ),
    );
  }
}
