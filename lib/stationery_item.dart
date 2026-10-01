class StationeryItem {
  final String name;
  String description;
  String imageUrl;
  int stock;
  int price;

  StationeryItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.price,
  });

  String get formattedPrice => formatPrice(price);

  static final List<StationeryItem> sampleData = [
    StationeryItem(
      name: 'Pulpen',
      description: 'Pulpen tinta hitam, nyaman digenggam, ujung 0.5 mm.',
      imageUrl:
          'https://images.unsplash.com/photo-1523726491678-bf852e717f6a?w=800&q=80&auto=format&fit=crop',
      stock: 0,
      price: 3000,
    ),
    StationeryItem(
      name: 'Pensil',
      description: 'Pensil kayu 2B dengan penghapus di ujungnya.',
      imageUrl:
          'https://images.unsplash.com/photo-1598620617377-3bfb505b4384?w=800&q=80&auto=format&fit=crop',
      stock: 0,
      price: 4000,
    ),
    StationeryItem(
      name: 'Buku Tulis',
      description: 'Buku tulis 38 lembar, garis satu, kertas tebal.',
      imageUrl:
          'https://images.unsplash.com/photo-1573848855919-9abecc93e456?w=800&q=80&auto=format&fit=crop',
      stock: 0,
      price: 5500,
    ),
    StationeryItem(
      name: 'Penghapus',
      description: 'Penghapus karet lembut, tidak meninggalkan bekas.',
      imageUrl:
          'https://images.unsplash.com/photo-1749451578131-0adb36858f4f?w=800&q=80&auto=format&fit=crop',
      stock: 0,
      price: 2000,
    ),
    StationeryItem(
      name: 'Penggaris',
      description: 'Penggaris plastik transparan panjang 30 cm.',
      imageUrl:
          'https://images.unsplash.com/photo-1683127983818-208f46227c24?w=800&q=80&auto=format&fit=crop',
      stock: 0,
      price: 3500,
    ),
  ];
}

String formatPrice(int value) {
  return value.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]}.',
      );
}