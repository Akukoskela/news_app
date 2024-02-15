import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/views/dashboard.dart';

User? user = FirebaseAuth.instance.currentUser;
final databaseReference = FirebaseDatabase.instance.ref();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> latestSearches = [];
  String? _selectedLanguage; // Variable to store the selected language
  final List<String> _languages = ['en', 'fi']; // List of languages for the dropdown

  @override
  void initState() {
    super.initState();
    fetchLatestSearches();
  }

  void sendData(String searchWord) {
    final userTasksRef = databaseReference.child('users/${user?.uid}/search_word').push();
    userTasksRef.set(searchWord);
  }

  void fetchLatestSearches() {
    final userSearchesRef = FirebaseDatabase.instance.ref('users/${FirebaseAuth.instance.currentUser?.uid}/search_word');
    userSearchesRef.limitToLast(3).onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        List<String> searches = [];
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          searches.insert(0, value);
        });
        setState(() {
          latestSearches = searches;
        });
      }
    });
  }

  void performSearch({String? searchWord, String? language}) {
    searchWord = searchWord ?? _searchController.text.trim();
    language = language ?? _selectedLanguage ?? 'en'; // Default to English if no language is selected
    if (searchWord.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDashboard(searchWord: searchWord!, language: language!),
        ),
      );
      _searchController.clear();
      if (!_isSearching) {
        toggleSearch();
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
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                toggleSearch();
              },
            ),
          if (!_isSearching)
            DropdownButton<String>(
              value: _selectedLanguage,
              hint: Text('Select Language'),
              items: _languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
            ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: toggleSearch,
            ),
        ],
        centerTitle: false,
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
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade400),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(latestSearches[index]),
                    onTap: () => performSearch(searchWord: latestSearches[index]),
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
