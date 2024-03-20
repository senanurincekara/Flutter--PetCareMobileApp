import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/pets.dart';
import 'package:flutter_application_2/screens/graphpets.dart';
import 'package:flutter_application_2/screens/hatirlatici.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPets extends StatefulWidget {
  final Pet pet;

  const DetailPets({Key? key, required this.pet}) : super(key: key);

  @override
  _DetailPetsState createState() => _DetailPetsState();
}

class _DetailPetsState extends State<DetailPets> {
  int _currentPageIndex = 0;
  late PageController _pageController;
                                                                                    
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pet.type} - ${widget.pet.name}'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          buildDetailPage(),
          Hatirlatici(pet: widget.pet),
          GraphPets(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'PROFİL',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'HATIRLATICI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'GRAFİKLER',
          ),
        ],
      ),
    );
  }

  Widget buildDetailPage() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.cyan[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18,
                  width: 10,
                ),
                Text(
                  'İD: ${widget.pet.id}',
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 18,
                  width: 10,
                ),
                Text(
                  'Ad: ${widget.pet.name}',
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cinsiyet: ${widget.pet.gender}',
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Yaş: ${widget.pet.age}',
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Doğum Tarihi: ${widget.pet.birthDate}',
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
