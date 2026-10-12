import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:villanueva_midterm_act_2_futures_and_streams/models/book.dart';

Future<Book> fetchRandomBook(String genre) async {
  final randomPage = Random().nextInt(5) + 1;
  final uri = Uri.parse(
    'https://gutendex.com/books/?topic=$genre&page=$randomPage',
  );

  final res = await http.get(uri).timeout(const Duration(seconds: 10));

  if (res.statusCode != 200) {
    throw Exception('HTTP ${res.statusCode}');
  }

  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final results = data['results'] as List<dynamic>;

  if (results.isEmpty) {
    throw Exception('No books found for $genre');
  }

  final randomIndex = Random().nextInt(results.length);
  return Book.fromJson(results[randomIndex] as Map<String, dynamic>);
}

class BeltScreen extends StatefulWidget {
  const BeltScreen({super.key});

  @override
  State<BeltScreen> createState() => _BeltScreenState();
}

class _BeltScreenState extends State<BeltScreen> {
  final List<String> _genres = const [
    'fiction',
    'mystery',
    'history',
    'poetry',
    'adventure',
  ];

  String _selectedGenre = 'fiction';
  String? _lastError;

  late final Stream<Book> _stream = _bookStream();

  Stream<Book> _bookStream() async* {
    while (true) {
      try {
        final book = await fetchRandomBook(_selectedGenre);
        _lastError = null;
        yield book;
      } catch (e) {
        _lastError = e.toString();
        debugPrint('random book fetch failed: $e');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book for your Genre'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Genre for Random Book:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _genres.map((genre) {
                      final isSelected = _selectedGenre == genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            genre[0].toUpperCase() + genre.substring(1),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedGenre = genre;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          Expanded(
            child: StreamBuilder<Book>(
              stream: _stream,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Error: ${snap.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (!snap.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          _lastError != null
                              ? 'Offline / Connection error.\nRetrying every 5s...\n($_lastError)'
                              : 'Waiting for first book on the belt...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _lastError != null ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final book = snap.data!;
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.sync,
                                            size: 16, color: Colors.green),
                                        SizedBox(width: 4),
                                        Text(
                                          '',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '#${book.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (book.coverUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    book.coverUrl!,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.menu_book,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.menu_book,
                                  size: 80,
                                  color: Colors.grey,
                                ),

                              const SizedBox(height: 16),
                              Text(
                                book.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'By: ${book.author}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Chip(
                                label: Text(
                                  'Genre: ${_selectedGenre.toUpperCase()}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}