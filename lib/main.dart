import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'models/item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realm Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ItemPage(),
    );
  }
}

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final Realm realm;
  late final RealmResults<Item> items;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final config = Configuration.local([Item.schema]);
    realm = Realm(config);
    items = realm.all<Item>();
  }

  @override
  void dispose() {
    nameController.dispose();
    realm.close();
    super.dispose();
  }

  void _addItem() {
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    try {
      realm.write(() {
        realm.add(Item(ObjectId(), name));
      });
      nameController.clear();
    } catch (_) {
      // No-op: keep example simple
    }
  }

  void _deleteItem(Item item) {
    try {
      realm.write(() {
        realm.delete(item);
      });
    } catch (_) {
      // No-op
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realm Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<RealmResultsChanges<Item>>(
                stream: items.changes,
                builder: (context, snapshot) {
                  final current = snapshot.data?.results ?? items;
                  if (current.isEmpty) {
                    return const Center(child: Text('No items yet'));
                  }
                  return ListView.separated(
                    itemCount: current.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = current[index];
                      return Dismissible(
                        key: ValueKey(item.id.hexString),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteItem(item),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.id.hexString),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _deleteItem(item),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
