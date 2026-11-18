import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'detail.dart';

class CartPage extends StatelessWidget {
  final String username;
  const CartPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('cart');
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box b, _) {
          final keys = b.keys
              .where((k) => (b.get(k) as Map)['username'] == username)
              .toList();
          if (keys.isEmpty) {
            return const Center(child: Text('Cart kosong'));
          }
          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, i) {
              final item = Map<String, dynamic>.from(b.get(keys[i]));
              return ListTile(
                leading: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.network(
                    item['image'] ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(item['title'],
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Row(children: [
                  Text('\$${(item['price'] as num).toStringAsFixed(2)}  •  '),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${(item['rating'] as num).toStringAsFixed(1)}'),
                ]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => b.delete(keys[i]),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(
                            productId: item['productId'],
                            username: username))),
              );
            },
          );
        },
      ),
    );
  }
}
