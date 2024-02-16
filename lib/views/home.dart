import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/views/dashboard.dart';

// Here we get the current user
User? user = FirebaseAuth.instance.currentUser;
// Here we connect to the database
final databaseReference = FirebaseDatabase.instance.ref();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> latestSearches = []; // List to store the latest searches

  @override
  void initState() {
    super.initState();
    fetchLatestSearches();
  }

  void sendData(String searchWord) {
    final userTasksRef =
        databaseReference.child('users/${user?.uid}/search_word').push();
    userTasksRef.set(searchWord);
  }

  void fetchLatestSearches() {
    final userSearchesRef = FirebaseDatabase.instance
        .ref('users/${FirebaseAuth.instance.currentUser?.uid}/search_word');
    userSearchesRef.orderByKey().onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        List<String> searches = [];
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          searches.add(value); // Insert at the end
        });

        // Get the latest three searches in the correct order
        List<String> latestThreeSearches = searches.reversed.take(3).toList();

        setState(() {
          latestSearches = latestThreeSearches;
        });
      }
    });
  }

  void performSearch({String? searchWord}) {
    searchWord = searchWord ?? _searchController.text.trim();
    if (searchWord.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDashboard(
            searchWord: searchWord!,
            language: '',
          ),
        ),
      );
      _searchController.clear(); // Clear the search field after searching
      if (!_isSearching) {
        toggleSearch(); // Reset the search state
      }
    }
  }

  void toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter search term...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  performSearch(searchWord: value);
                  sendData(value);
                },
              )
            : const Text('Home'),
        actions: _isSearching
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    toggleSearch();
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: toggleSearch,
                ),
              ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_isSearching)
              const Text(
                'What do you want to search today?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            if (!_isSearching && latestSearches.isNotEmpty)
              const Text(
                'Latest Searches:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            Expanded(
              child: ListView.separated(
                itemCount: latestSearches.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade400),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(latestSearches[index]),
                    onTap: () =>
                        performSearch(searchWord: latestSearches[index]),
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
