import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search medicine name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  _MedicineTile("Paracetamol", "Available at 3 shops"),
                  _MedicineTile("Azithromycin", "Available at 2 shops"),
                  _MedicineTile("Cetrizine", "Available at 5 shops"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineTile extends StatelessWidget {
  final String name;
  final String subtitle;

  const _MedicineTile(this.name, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
