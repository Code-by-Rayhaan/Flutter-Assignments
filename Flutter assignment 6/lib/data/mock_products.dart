import '../models/product.dart';

class MockProducts {
  static const List<String> categories = [
    'All',
    'Electronics',
    'Audio',
    'Wearables',
    'Footwear',
    'Accessories',
    'Home',
  ];

  static List<Product> getProducts() {
    return [
      const Product(
        id: 'p1',
        name: 'Sony WH-1000XM5 Wireless Headphones',
        category: 'Audio',
        brand: 'Sony',
        price: 29990.00,
        rating: 4.8,
        reviewCount: 2450,
        description:
            'Industry-leading noise cancellation with two processors and 8 microphones. Exceptional sound quality with Hi-Res Audio and up to 30-hour battery life.',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&q=80',
        inStock: true,
        tags: ['Wireless', 'ANC', 'Bluetooth', 'Over-Ear'],
        specifications: {
          'Battery Life': '30 Hours',
          'Connectivity': 'Bluetooth 5.2',
          'Weight': '250g',
          'Noise Cancelling': 'Dual Processor Active NC',
        },
      ),
      const Product(
        id: 'p2',
        name: 'Apple MacBook Air M3 (13.6-inch)',
        category: 'Electronics',
        brand: 'Apple',
        price: 114900.00,
        rating: 4.9,
        reviewCount: 3820,
        description:
            'Lean. Mean. M3 machine. Supercharged by the next-generation M3 chip, MacBook Air combines incredible performance and up to 18 hours of battery life into a strikingly thin design.',
        imageUrl:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80',
        inStock: true,
        tags: ['Laptop', 'M3', 'macOS', 'Portable'],
        specifications: {
          'Processor': 'Apple M3 chip (8-core CPU)',
          'RAM': '16GB Unified Memory',
          'Storage': '512GB SSD',
          'Display': '13.6" Liquid Retina',
        },
      ),
      const Product(
        id: 'p3',
        name: 'Garmin Fenix 7 Pro Solar Watch',
        category: 'Wearables',
        brand: 'Garmin',
        price: 67990.00,
        rating: 4.7,
        reviewCount: 940,
        description:
            'Ultimate multisport GPS smartwatch with solar charging lens, built-in LED flashlight, advanced training metrics, and 24/7 health monitoring.',
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&q=80',
        inStock: true,
        tags: ['GPS', 'Solar', 'Fitness', 'Smartwatch'],
        specifications: {
          'Water Rating': '10 ATM (100m)',
          'Battery Life': 'Up to 22 days in smartwatch mode',
          'Display': '1.3" Sunlight-visible MIP',
          'Sensors': 'Wrist HR, Pulse Ox, Compass, GPS',
        },
      ),
      const Product(
        id: 'p4',
        name: 'Nike Air Zoom Pegasus 40',
        category: 'Footwear',
        brand: 'Nike',
        price: 10495.00,
        rating: 4.6,
        reviewCount: 1680,
        description:
            'A springy ride for every run. The familiar, just-for-you feel of the Pegasus returns to help you accomplish your goals with improved midfoot security.',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
        inStock: true,
        tags: ['Running', 'Cushioned', 'Sneakers', 'Athletic'],
        specifications: {
          'Surface': 'Road / Track',
          'Drop': '10mm',
          'Weight': '288g',
          'Cushioning': 'Nike React + Zoom Air',
        },
      ),
      const Product(
        id: 'p5',
        name: 'Keychron Q1 Pro Mechanical Keyboard',
        category: 'Electronics',
        brand: 'Keychron',
        price: 16999.00,
        rating: 4.8,
        reviewCount: 730,
        description:
            'All-metal QMK/VIA wireless custom mechanical keyboard with hot-swappable switches, double-gasket design, and CNC aluminum body.',
        imageUrl:
            'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=80',
        inStock: false,
        tags: ['Mechanical', 'Wireless', 'Hot-swap', 'RGB'],
        specifications: {
          'Layout': '75% Layout',
          'Connectivity': 'Bluetooth 5.1 & Type-C',
          'Body Material': 'Full CNC Machined Aluminum',
          'Switches': 'K Pro Red Mechanical Switches',
        },
      ),
      const Product(
        id: 'p6',
        name: 'Bose QuietComfort Ultra Earbuds',
        category: 'Audio',
        brand: 'Bose',
        price: 25900.00,
        rating: 4.5,
        reviewCount: 1120,
        description:
            'Spatial audio meets world-class noise cancellation. CustomTune technology personalizes sound to your ear shape for pure immersion.',
        imageUrl:
            'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=80',
        inStock: true,
        tags: ['Earbuds', 'Spatial Audio', 'ANC', 'Water Resistant'],
        specifications: {
          'Battery Life': 'Up to 6 hours (24 with case)',
          'Water Resistance': 'IPX4',
          'Microphones': '9 total microphones',
          'Bluetooth': 'Version 5.3',
        },
      ),
      const Product(
        id: 'p7',
        name: 'Peak Design Everyday Backpack 20L',
        category: 'Accessories',
        brand: 'Peak Design',
        price: 22999.00,
        rating: 4.9,
        reviewCount: 3100,
        description:
            'An iconic, award-winning pack for everyday carry and photo gear. Features weatherproof 100% recycled 400D nylon canvas shell and MagLatch hardware.',
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&q=80',
        inStock: true,
        tags: ['Backpack', 'Waterproof', 'Camera', 'Travel'],
        specifications: {
          'Capacity': '20 Liters',
          'Laptop Carry': 'Fits up to 15" laptops',
          'Material': 'Weatherproof 400D Double Poly-Coated Canvas',
          'Weight': '2.01 kg',
        },
      ),
      const Product(
        id: 'p8',
        name: 'Fellow Stagg EKG Electric Pour-Over Kettle',
        category: 'Home',
        brand: 'Fellow',
        price: 14500.00,
        rating: 4.7,
        reviewCount: 1840,
        description:
            'Variable temperature control kettle for pour-over coffee aficionados. Sleek matte black minimalist design with precision pour spout.',
        imageUrl:
            'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=600&q=80',
        inStock: true,
        tags: ['Coffee', 'Kitchen', 'Barista', 'Minimalist'],
        specifications: {
          'Capacity': '0.9 Liter',
          'Power': '1200W Rapid Heating',
          'Temperature Range': '135°F - 212°F (57°C - 100°C)',
          'Material': '304 Stainless Steel',
        },
      ),
      const Product(
        id: 'p9',
        name: 'Ray-Ban Meta Wayfarer Smart Glasses',
        category: 'Wearables',
        brand: 'Ray-Ban',
        price: 26900.00,
        rating: 4.4,
        reviewCount: 890,
        description:
            'Next-generation smart glasses featuring an ultra-wide 12 MP camera, 5-mic audio system, open-ear speakers, and Meta AI voice commands.',
        imageUrl:
            'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&q=80',
        inStock: false,
        tags: ['Smart Glasses', 'AI', 'Camera', 'Audio'],
        specifications: {
          'Camera': '12MP Ultra-wide, 1080p Video',
          'Audio': '2 custom-built open-ear micro speakers',
          'Battery': '4 hours per single charge, 36h with case',
          'Storage': '32GB flash memory',
        },
      ),
      const Product(
        id: 'p10',
        name: 'Bellroy Hide & Seek Premium Leather Wallet',
        category: 'Accessories',
        brand: 'Bellroy',
        price: 7490.00,
        rating: 4.6,
        reviewCount: 2200,
        description:
            'Classic all-rounder with secret compartment and RFID protection. Crafted from environmentally certified premium top-grain leather.',
        imageUrl:
            'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&q=80',
        inStock: true,
        tags: ['Leather', 'Slim', 'RFID', 'Wallet'],
        specifications: {
          'Capacity': '5-12 cards + flat bills',
          'Dimensions': '115mm x 95mm',
          'Security': 'RFID Protection Built-in',
          'Warranty': '3 Years',
        },
      ),
      const Product(
        id: 'p11',
        name: 'Logitech MX Master 3S Wireless Mouse',
        category: 'Electronics',
        brand: 'Logitech',
        price: 8995.00,
        rating: 4.8,
        reviewCount: 5400,
        description:
            'Performance wireless mouse with 8K DPI track-on-glass sensor, Quiet Clicks, and MagSpeed electromagnetic scrolling wheel.',
        imageUrl:
            'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&q=80',
        inStock: true,
        tags: ['Ergonomic', 'Productivity', 'Wireless', 'Mouse'],
        specifications: {
          'Sensor': '8,000 DPI Darkfield High Precision',
          'Battery': 'Rechargeable Li-Po (500 mAh), up to 70 days',
          'Buttons': '7 Buttons (Left/Right, Back/Forward, App-Switch, Wheel Mode, Middle)',
          'Connectivity': 'Bluetooth Low Energy & Logi Bolt USB',
        },
      ),
      const Product(
        id: 'p12',
        name: 'Adidas Ultraboost Light Running Shoes',
        category: 'Footwear',
        brand: 'Adidas',
        price: 15999.00,
        rating: 4.6,
        reviewCount: 1420,
        description:
            'Experience epic energy with the Light BOOST midsole—the lightest BOOST cushioning ever engineered for maximum responsiveness.',
        imageUrl:
            'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80',
        inStock: true,
        tags: ['Boost', 'Running', 'Lightweight', 'Sneakers'],
        specifications: {
          'Midsole': 'Light BOOST cushioning',
          'Upper': 'PRIMEKNIT+ textile upper',
          'Outsole': 'Continental™ Better Rubber',
          'Weight': '293g (Size 9)',
        },
      ),
      const Product(
        id: 'p13',
        name: 'Dyson Purifier Cool Gen1 Air Purifier',
        category: 'Home',
        brand: 'Dyson',
        price: 36900.00,
        rating: 4.7,
        reviewCount: 960,
        description:
            'Automatically senses, captures, and traps 99.97% of microscopic particles down to 0.3 microns. Dual functionality purifies and cools simultaneously.',
        imageUrl:
            'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600&q=80',
        inStock: true,
        tags: ['Air Purifier', 'HEPA', 'Cooling', 'Smart Home'],
        specifications: {
          'Filtration': 'HEPA H13 + Activated Carbon',
          'Oscillation': 'Up to 350 degrees',
          'Airflow': '290 Liters/second max',
          'Sound Level': 'Max 61 dB',
        },
      ),
    ];
  }
}
