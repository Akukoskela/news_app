import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/views/dashboard.dart';

// Here we get the current user
User? user = FirebaseAuth.instance.currentUser;
// Here we connect to database
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
  final userTasksRef = databaseReference.child('users/${user?.uid}/search_word').push();
  userTasksRef.set(searchWord);
}

  void fetchLatestSearches() async {
    final userSearchesRef = FirebaseDatabase.instance.ref('users/${FirebaseAuth.instance.currentUser?.uid}/search_word');
    DataSnapshot snapshot = await userSearchesRef.limitToFirst(3).get();

    if (snapshot.exists) {
      List<String> searches = [];
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        searches.add(value);
      });
      setState(() {
        latestSearches = searches;
      });
    }
  }

  void performSearch({String? searchWord}) {
    searchWord = searchWord ?? _searchController.text.trim();
    if (searchWord.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDashboard(searchWord: searchWord!),
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
                decoration: InputDecoration(
                  hintText: 'Enter search term...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => {performSearch(),sendData(value)},
              )
            : Text('Home'),
        actions: _isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    toggleSearch();
                  },
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.search),
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
              Text(
                'What do you want to search today?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            if (!_isSearching && latestSearches.isNotEmpty)
              Text(
                'Latest Searches:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            Expanded(
              child: ListView.separated(
                itemCount: latestSearches.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade400),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.history),
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
