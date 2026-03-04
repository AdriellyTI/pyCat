import 'package:flutter/material.dart';
import '../models/cat.dart';
import '../widgets/cat_card.dart';
import 'add_cat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  int _selectedCatIndex = 0;

  final List<Cat> _cats = [
    const Cat(
      name: 'Pixiba',
      ageYears: 2,
    ),
    const Cat(
      name: 'Romeu',
      ageYears: 2,
    ),
  ];

  List<Cat> get _displayCats {
    return _cats.asMap().entries.map((entry) {
      return Cat(
        name: entry.value.name,
        ageYears: entry.value.ageYears,
        imageUrl: entry.value.imageUrl,
        isSelected: entry.key == _selectedCatIndex,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF5B7DB8),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Hello, Alice.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () async {
                final cat = await Navigator.push<Cat>(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCatScreen()),
                );
                if (cat != null) {
                  setState(() {
                    _cats.add(cat);
                  });
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Adicionar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cat list
          Expanded(
            child: ListView.builder(
              itemCount: _displayCats.length,
              itemBuilder: (context, index) {
                return CatCard(
                  cat: _displayCats[index],
                  onTap: () {
                    setState(() {
                      _selectedCatIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF3B5998),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_outlined, size: 28),
              label: 'Saúde',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined, size: 28),
              label: 'Registros',
            ),
          ],
        ),
      ),
    );
  }
}
