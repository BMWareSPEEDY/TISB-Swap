// Placeholder data and constants for the app

class AppConstants {
  // Category options
  static const List<String> categories = [
    'Textbooks',
    'Uniforms',
    'Electronics',
    'Other',
  ];
  
  // Grade levels
  static const List<String> gradeLevels = [
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
    'IGCSE',
    'IB Diploma',
  ];
  
  // House names
  static const List<String> houses = [
    'CALVERY',
    'DANGA',
    'GOKHALE',
    'YAKUMA',
  ];
  
  // Condition options
  static const List<String> conditions = [
    'New', 'Like New', 'Used', 'Fair', 'Poor'
  ];
  
  // Sample items for marketplace
  static final List<Map<String, dynamic>> sampleItems = [
    {
      'id': '1',
      'title': 'IB Physics HL Oxford 2023 Edition',
      'description': 'This textbook was used for one year of IB Physics HL. It\'s in excellent condition with no highlighting or pen marks on the pages.',
      'category': 'Textbooks',
      'house': 'CALVERY',
      'condition': 'Like New',
      'price': 500,
      'image': 'assets/images/textbook_placeholder.png',
      'seller': 'Aarav Patel',
      'grade': 'Grade 12',
      'co2Saved': 2.5,
      'waterSaved': 1200,
    },
    {
      'id': '2',
      'title': 'Size M PE Jersey (Unisex)',
      'description': 'Barely used PE jersey in great condition.',
      'category': 'Uniforms',
      'house': 'DANGA',
      'condition': 'Like New',
      'price': 350,
      'image': 'assets/images/uniform_placeholder.png',
      'seller': 'Priya Sharma',
      'grade': 'Grade 10',
      'co2Saved': 1.8,
      'waterSaved': 2700,
    },
    {
      'id': '3',
      'title': 'Casio FX-991EX Classwiz',
      'description': 'Scientific calculator in fair condition. Works perfectly.',
      'category': 'Electronics',
      'house': 'YAKUMA',
      'condition': 'Fair',
      'price': 800,
      'image': 'assets/images/textbook_placeholder.png',
      'seller': 'Arjun Singh',
      'grade': 'Grade 11',
      'co2Saved': 0.5,
      'waterSaved': 100,
    },
    {
      'id': '4',
      'title': 'Chemistry Lab Coat (Size S)',
      'description': 'White lab coat for chemistry practicals.',
      'category': 'Uniforms',
      'house': 'GOKHALE',
      'condition': 'New',
      'price': 350,
      'image': 'assets/images/uniform_placeholder.png',
      'seller': 'Neha Kumar',
      'grade': 'Grade 11',
      'co2Saved': 1.2,
      'waterSaved': 1800,
    },
    {
      'id': '5',
      'title': 'Cooler Master Laptop Pad',
      'description': 'Laptop cooling pad, barely used.',
      'category': 'Electronics',
      'house': 'CALVERY',
      'condition': 'Used',
      'price': 1200,
      'image': 'assets/images/textbook_placeholder.png',
      'seller': 'Rahul Verma',
      'grade': 'Grade 12',
      'co2Saved': 0.8,
      'waterSaved': 150,
    },
    {
      'id': '6',
      'title': 'IB English Lit: Complete Set',
      'description': 'All required texts for IB English Literature.',
      'category': 'Textbooks',
      'house': 'DANGA',
      'condition': 'Used',
      'price': 600,
      'image': 'assets/images/textbook_placeholder.png',
      'seller': 'Ananya Reddy',
      'grade': 'Grade 11',
      'co2Saved': 3.2,
      'waterSaved': 1500,
    },
  ];
  
  // Sample chat messages
  static final List<Map<String, dynamic>> sampleMessages = [
    {
      'sender': 'other',
      'content': 'Hey, is the textbook still available?',
      'timestamp': '10:25 AM',
    },
    {
      'sender': 'me',
      'content': 'Yes! It has a few notes in it, is that okay?',
      'timestamp': '10:25 AM',
    },
    {
      'sender': 'other',
      'content': 'That\'s fine. Can we meet at break?',
      'timestamp': '10:25 AM',
    },
    {
      'sender': 'me',
      'content': 'Sure, see you at the Atrium.',
      'timestamp': '10:26 AM',
    },
  ];
  
  
  // Impact metrics
  static const double totalCO2Saved = 4520; // kg
  static const int totalItemsSwapped = 127;
  
  // User Profile Data
  static final Map<String, dynamic> userProfile = {
    'name': 'Rohan Gupta',
    'grade': 'Grade 11',
    'house': 'Amber House',
    'greenScore': 850,
    'maxGreenScore': 1000,
    'percentile': 'top 5%',
    'ecoPoints': 1240,
    'treesSaved': 12,
    'itemsReused': 15,
    'co2Avoided': 40, // kg
  };
  
  // User's Active Listings
  static final List<Map<String, dynamic>> userListings = [
    {
      'id': '1',
      'title': 'IB HL Physics ...',
      'condition': 'Good',
      'price': 1200,
      'status': 'ACTIVE',
      'image': 'assets/images/textbook_placeholder.png',
    },
    {
      'id': '2',
      'title': 'TISB Blazer (Si...',
      'condition': 'Like New',
      'price': 2500,
      'status': 'ACTIVE',
      'image': 'assets/images/uniform_placeholder.png',
    },
  ];
  
  // Lost & Found Items
  static final List<Map<String, dynamic>> lostFoundItems = [
    {
      'id': '1',
      'category': 'MATH',
      'title': 'Casio FX-991',
      'description': 'Black scientific calculator. Has a small scratch on the back cover near the battery.',
      'location': 'North Lab, 2nd Floor',
      'timeAgo': '1d ago',
      'type': 'lost',
      'image': 'assets/images/textbook_placeholder.png',
    },
    {
      'id': '2',
      'category': 'UNIFORM',
      'title': 'Grade 10 Blazer',
      'description': 'Standard issue Navy blazer size M. Name tag "Alex J" is sewn inside.',
      'location': 'Gym Changing Room',
      'timeAgo': '3h ago',
      'type': 'found',
      'image': 'assets/images/uniform_placeholder.png',
    },
    {
      'id': '3',
      'category': 'BOOK',
      'title': 'IB Biology Textbook',
      'description': 'Pearson Baccalaureate Higher Level Biology. Left on a table near the entrance.',
      'location': 'School Library',
      'timeAgo': '3h ago',
      'type': 'found',
      'image': 'assets/images/textbook_placeholder.png',
    },
    {
      'id': '4',
      'category': 'PERSONAL',
      'title': 'Metal Hydroflask',
      'description': 'Silver bottle with multiple stickers (NASA, TISB logo).',
      'location': 'Cafeteria',
      'timeAgo': '5h ago',
      'type': 'found',
      'image': 'assets/images/textbook_placeholder.png',
    },
  ];
}

