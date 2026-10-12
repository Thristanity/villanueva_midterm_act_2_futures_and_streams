import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:villanueva_midterm_act_2_futures_and_streams/models/book.dart';

Future<List<Book>> fetchTopBooks() async {
  final uri = Uri.parse('https://gutendex.com/books/?sort=popular');
  final res = await http.get(uri).timeout(const Duration(seconds: 10));

  if (res.statusCode != 200) {
    throw Exception('Server said ${res.statusCode}');
  }

  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final list = data['results'] as List<dynamic>;
  return list
      .map((j) => Book.fromJson(j as Map<String, dynamic>))
      .toList();
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchTopBooks();
  }

  void _retry() {
    setState(() {
      _booksFuture = fetchTopBooks();
    });
  }

  Widget _buildBody(BuildContext ctx, AsyncSnapshot<List<Book>> snap) {
    if (snap.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading top classic books...'),
          ],
        ),
      );
    }

    if (snap.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed: ${snap.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _retry,
                child: const Text('Tap to retry'),
              ),
            ],
          ),
        ),
      );
    }

    final books = snap.data ?? [];
    if (books.isEmpty) {
      return const Center(child: Text('Nothing here yet'));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (_, i) {
        final book = books[i];
        final rank = i + 1;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: rank <= 3
                      ? Colors.amber.shade700
                      : Colors.deepPurple.shade100,
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: rank <= 3 ? Colors.white : Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (book.coverUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      book.coverUrl!,
                      width: 40,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.book, size: 32),
                    ),
                  )
                else
                  const Icon(Icons.book, size: 32),
              ],
            ),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              'ID: ${book.id}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Classic Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: _buildBody,
      ),
    );
  }
}