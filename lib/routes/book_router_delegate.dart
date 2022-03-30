// ignore_for_file: avoid_renaming_method_parameters

import 'package:fltuter_web/routes/book_route_path.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../screens/books_detail_screen.dart';
import '../screens/books_list_screen.dart';
import '../screens/unknown_screen.dart';

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Book _selectedBook = NullBook();
  bool show404 = false;
  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  BookRoutePath get currentConfiguration {
    if (show404) {
      return BookRoutePath.unknown();
    }

    return _selectedBook is NullBook
        ? BookRoutePath.home()
        : BookRoutePath.details(
            books.indexOf(_selectedBook),
          );
  }

  void _handleBookTapped(Book book) {
    _selectedBook = book;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          key: const ValueKey('BooksListPage'),
          child: BooksListScreen(
            books: books,
            onTapped: _handleBookTapped,
          ),
        ),
        if (show404)
          const MaterialPage(
            key: ValueKey('UnknowPage'),
            child: UnknownScreen(),
          )
        else if (_selectedBook is! NullBook)
          MaterialPage(
            key: ValueKey(_selectedBook),
            child: BookDetailsScreen(book: _selectedBook),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _selectedBook = NullBook();
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    if (path.isUnknown) {
      _selectedBook = NullBook();
      show404 = true;
      return;
    }
    if (!path.isDetailsPage) {
      _selectedBook = NullBook();
      show404 = false;
      return;
    }

    final bool isValidPath =
        path.id != null && (path.id! > 0 || path.id! < books.length - 1);

    if (!isValidPath) {
      show404 = true;
      return;
    }

    _selectedBook = books[path.id!];
    show404 = false;
  }
}
