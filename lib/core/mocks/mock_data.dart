class MockData {
  MockData._();

  // Current user (passenger)
  static const Map<String, dynamic> user = {
    'id': '1',
    'name': 'John Smith',
    'phone': '+1 (555) 123-4567',
    'email': 'john@example.com',
    'avatar': null,
  };

  // Available trips for search results
  static const List<Map<String, dynamic>> availableTrips = [
    {
      'id': '1',
      'from': 'New York',
      'fromAddress': 'Penn Station, Manhattan',
      'to': 'Boston',
      'toAddress': 'South Station',
      'date': 'January 30, 2026',
      'time': '2:00 PM',
      'driver': {
        'id': '101',
        'name': 'Mike Johnson',
        'phone': '+1 (555) 987-6543',
        'rating': 4.85,
        'trips': 145,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'Tesla',
        'model': 'Model 3',
        'year': 2023,
        'color': 'White',
        'plateNumber': 'ABC 1234',
      },
      'totalSeats': 4,
      'availableSeats': 2,
      'price': 45,
      'distance': '215 mi',
      'duration': '~4 hours',
      'amenities': ['A/C', 'Luggage Space'],
    },
    {
      'id': '2',
      'from': 'New York',
      'fromAddress': 'Brooklyn, Atlantic Terminal',
      'to': 'Boston',
      'toAddress': 'Cambridge',
      'date': 'January 30, 2026',
      'time': '3:30 PM',
      'driver': {
        'id': '102',
        'name': 'Sarah Miller',
        'phone': '+1 (555) 234-5678',
        'rating': 4.92,
        'trips': 203,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'Toyota',
        'model': 'Camry',
        'year': 2022,
        'color': 'Black',
        'plateNumber': 'XYZ 5678',
      },
      'totalSeats': 4,
      'availableSeats': 3,
      'price': 40,
      'distance': '215 mi',
      'duration': '~4 hours',
      'amenities': ['A/C', 'Pet Friendly'],
    },
    {
      'id': '3',
      'from': 'New York',
      'fromAddress': 'Times Square',
      'to': 'Boston',
      'toAddress': 'Downtown Boston',
      'date': 'January 30, 2026',
      'time': '4:00 PM',
      'driver': {
        'id': '103',
        'name': 'Alex Kim',
        'phone': '+1 (555) 345-6789',
        'rating': 4.78,
        'trips': 89,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'Honda',
        'model': 'Accord',
        'year': 2021,
        'color': 'Gray',
        'plateNumber': 'DEF 9012',
      },
      'totalSeats': 4,
      'availableSeats': 1,
      'price': 50,
      'distance': '215 mi',
      'duration': '~4 hours',
      'amenities': ['A/C', 'Luggage Space', 'Child Seat'],
    },
  ];

  // User's booked trips
  static const List<Map<String, dynamic>> myTrips = [
    {
      'id': '1',
      'from': 'New York',
      'to': 'Boston',
      'date': 'January 30, 2026',
      'time': '2:00 PM',
      'driver': {
        'id': '101',
        'name': 'Mike Johnson',
        'phone': '+1 (555) 987-6543',
        'rating': 4.85,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'Tesla',
        'model': 'Model 3',
        'color': 'White',
        'plateNumber': 'ABC 1234',
      },
      'seats': 1,
      'totalPrice': 45,
      'status': 'pending',
      'pickupAddress': '123 Main St, Manhattan',
    },
    {
      'id': '2',
      'from': 'Los Angeles',
      'to': 'San Diego',
      'date': 'February 2, 2026',
      'time': '8:00 AM',
      'driver': {
        'id': '104',
        'name': 'Sarah Williams',
        'phone': '+1 (555) 456-7890',
        'rating': 4.90,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'BMW',
        'model': '3 Series',
        'color': 'Blue',
        'plateNumber': 'GHI 3456',
      },
      'seats': 2,
      'totalPrice': 50,
      'status': 'confirmed',
      'pickupAddress': 'Union Station, LA',
    },
    {
      'id': '3',
      'from': 'Miami',
      'to': 'Orlando',
      'date': 'January 20, 2026',
      'time': '10:00 AM',
      'driver': {
        'id': '105',
        'name': 'David Chen',
        'phone': '+1 (555) 567-8901',
        'rating': 4.75,
        'avatar': null,
      },
      'vehicle': {
        'brand': 'Ford',
        'model': 'Mustang',
        'color': 'Red',
        'plateNumber': 'JKL 7890',
      },
      'seats': 1,
      'totalPrice': 35,
      'status': 'completed',
      'pickupAddress': 'Miami Beach',
    },
  ];

  // Chats with drivers
  static const List<Map<String, dynamic>> chats = [
    {
      'id': '1',
      'driver': {
        'id': '101',
        'name': 'Mike Johnson',
        'avatar': null,
      },
      'trip': 'NYC → Boston, Jan 30',
      'lastMessage': "I'll wait at the main entrance of Penn Station.",
      'time': '2:35 PM',
      'unread': true,
    },
    {
      'id': '2',
      'driver': {
        'id': '104',
        'name': 'Sarah Williams',
        'avatar': null,
      },
      'trip': 'LA → San Diego, Feb 2',
      'lastMessage': 'Sounds good!',
      'time': 'yesterday',
      'unread': false,
    },
  ];

  // Chat messages
  static const List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'chatId': '1',
      'text': 'Hi! I booked 1 seat for the trip tomorrow.',
      'isMe': true,
      'time': '2:20 PM',
    },
    {
      'id': '2',
      'chatId': '1',
      'text':
          "Hey! Got your booking. I'll wait at the main entrance of Penn Station.",
      'isMe': false,
      'time': '2:25 PM',
    },
    {
      'id': '3',
      'chatId': '1',
      'text': 'Perfect, thanks!',
      'isMe': true,
      'time': '2:30 PM',
    },
  ];

  // US Cities
  static const List<Map<String, dynamic>> cities = [
    {'id': '1', 'name': 'New York', 'state': 'NY'},
    {'id': '2', 'name': 'Boston', 'state': 'MA'},
    {'id': '3', 'name': 'Los Angeles', 'state': 'CA'},
    {'id': '4', 'name': 'San Diego', 'state': 'CA'},
    {'id': '5', 'name': 'San Francisco', 'state': 'CA'},
    {'id': '6', 'name': 'Chicago', 'state': 'IL'},
    {'id': '7', 'name': 'Miami', 'state': 'FL'},
    {'id': '8', 'name': 'Orlando', 'state': 'FL'},
    {'id': '9', 'name': 'Seattle', 'state': 'WA'},
    {'id': '10', 'name': 'Portland', 'state': 'OR'},
    {'id': '11', 'name': 'Dallas', 'state': 'TX'},
    {'id': '12', 'name': 'Houston', 'state': 'TX'},
    {'id': '13', 'name': 'Phoenix', 'state': 'AZ'},
    {'id': '14', 'name': 'Las Vegas', 'state': 'NV'},
    {'id': '15', 'name': 'Detroit', 'state': 'MI'},
  ];

  // Popular routes
  static const List<Map<String, dynamic>> popularRoutes = [
    {
      'from': 'NYC',
      'to': 'Boston',
      'distance': '215 mi',
      'priceFrom': 35,
    },
    {
      'from': 'LA',
      'to': 'San Diego',
      'distance': '120 mi',
      'priceFrom': 25,
    },
    {
      'from': 'Miami',
      'to': 'Orlando',
      'distance': '235 mi',
      'priceFrom': 30,
    },
    {
      'from': 'Chicago',
      'to': 'Detroit',
      'distance': '280 mi',
      'priceFrom': 35,
    },
    {
      'from': 'Seattle',
      'to': 'Portland',
      'distance': '175 mi',
      'priceFrom': 25,
    },
    {
      'from': 'LA',
      'to': 'San Francisco',
      'distance': '380 mi',
      'priceFrom': 45,
    },
  ];

  // Saved/favorite routes
  static const List<Map<String, dynamic>> savedRoutes = [
    {
      'id': '1',
      'from': 'New York',
      'to': 'Boston',
      'distance': '~215 mi',
      'priceFrom': 35,
    },
    {
      'id': '2',
      'from': 'Los Angeles',
      'to': 'San Francisco',
      'distance': '~380 mi',
      'priceFrom': 45,
    },
    {
      'id': '3',
      'from': 'Miami',
      'to': 'Orlando',
      'distance': '~235 mi',
      'priceFrom': 30,
    },
  ];

  // Onboarding slides for passenger app
  static const List<Map<String, dynamic>> onboardingSlides = [
    {
      'title': 'Travel Between Cities',
      'description':
          'Find rides between cities at affordable prices. Share the journey, split the cost.',
      'image': 'assets/images/onboarding_1.svg',
    },
    {
      'title': 'Save Money',
      'description':
          'Cheaper than rental cars, more flexible than buses. Travel your way.',
      'image': 'assets/images/onboarding_2.svg',
    },
    {
      'title': 'Safe & Verified',
      'description':
          'All drivers are background-checked with verified reviews and ratings.',
      'image': 'assets/images/onboarding_3.svg',
    },
  ];

  // Filter options
  static const List<String> amenities = [
    'Air Conditioning',
    'Pet Friendly',
    'Luggage Space',
    'Child Seat',
    'WiFi',
    'Charger',
  ];

  static const List<Map<String, dynamic>> ratingFilters = [
    {'label': 'Any', 'value': 0.0},
    {'label': '4.0 and above', 'value': 4.0},
    {'label': '4.5 and above', 'value': 4.5},
    {'label': '4.8 and above', 'value': 4.8},
  ];
}
