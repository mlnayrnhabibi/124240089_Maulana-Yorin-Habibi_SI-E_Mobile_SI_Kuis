import 'package:flutter/material.dart';
import 'stationery_item.dart';

void main() => runApp(const RestoApp());

const kGreen = Color.fromARGB(255, 55, 63, 200);
const kSaffron = Color.fromARGB(255, 55, 63, 200);
const kBg = Color(0xFFF4F8F6);
const kInk = Color(0xFF16231F);
const kMuted = Color.fromARGB(255, 0, 0, 0);

class RestoApp extends StatelessWidget {
  const RestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Alat Tulis bibi ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen, primary: kGreen),
      ),
      home: const MainShell(),
    );
  }
}

// STATEFUL: menyimpan data porsi & tab aktif.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  final List<StationeryItem> _items = StationeryItem.sampleData;

  int get _grandTotal => _items.fold(0, (s, e) => s + e.stock * e.price);
  int get _totalPortions => _items.fold(0, (s, e) => s + e.stock);

  Future<void> _openDetail(StationeryItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailBarangPage(item: item)),
    );
    setState(() {}); // refresh beranda setelah porsi diubah
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MenuPage(
        items: _items,
        grandTotal: _grandTotal,
        totalPortions: _totalPortions,
        onTap: _openDetail,
      ),
      ProfilePage(
        name: 'bibi',
        items: _items,
        grandTotal: _grandTotal,
        totalPortions: _totalPortions,
      ),
    ];
    return Scaffold(
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        backgroundColor: Colors.white,
        indicatorColor: kSaffron,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: kInk),
              label: 'Barang'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: kInk),
              label: 'Profil'),
        ],
      ),
    );
  }
}

// ---------- Header bersama ----------
class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  const Header({super.key, required this.title, required this.subtitle, this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          12, MediaQuery.of(context).padding.top + 12, 20, 22),
      decoration: const BoxDecoration(
        color: kGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          leading ?? const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: Color(0xFFB8D6CF), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget foodImage(String url, {double? h, double? w, double radius = 16}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.network(
      url,
      height: h,
      width: w,
      fit: BoxFit.cover,
      loadingBuilder: (c, child, p) => p == null
          ? child
          : Container(height: h, width: w, color: const Color(0xFFE3EDE9)),
      errorBuilder: (c, e, s) => Container(
        height: h,
        width: w,
        color: const Color(0xFFE3EDE9),
        child: const Icon(Icons.fastfood, color: kMuted),
      ),
    ),
  );
}

// ---------- Halaman Beranda (STATELESS) ----------
class MenuPage extends StatelessWidget {
  final List<StationeryItem> items;
  final int grandTotal;
  final int totalPortions;
  final void Function(StationeryItem) onTap;

  const MenuPage({
    super.key,
    required this.items,
    required this.grandTotal,
    required this.totalPortions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: 'Toko Alat Tulis', subtitle: 'Melayani Sepenuh Hati'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, i) => _FoodCard(item: items[i], onTap: () => onTap(items[i])),
          ),
        ),
        if (totalPortions > 0)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: kInk,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: kSaffron),
                const SizedBox(width: 10),
                Text('$totalPortions Pcs dipesan',
                    style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                Text('Rp ${formatPrice(grandTotal)}',
                    style: const TextStyle(
                        color: kSaffron, fontWeight: FontWeight.w800, fontSize: 17)),
              ],
            ),
          ),
      ],
    );
  }
}

class _FoodCard extends StatelessWidget {
  final StationeryItem item;
  final VoidCallback onTap;
  const _FoodCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = item.stock > 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: active ? kSaffron : const Color(0xFFE1EAE6),
                width: active ? 1.6 : 1),
          ),
          child: Row(
            children: [
              Hero(
                tag: item.name,
                child: foodImage(item.imageUrl, h: 96, w: 96),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, color: kInk)),
                    const SizedBox(height: 3),
                    Text(item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: kMuted, height: 1.3)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: active ? kSaffron : const Color(0xFFEAF1EE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${item.stock} tersedia',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: kInk)),
                              ),
                              const SizedBox(height: 4),
                              Text('Rp ${item.stock} Pcs Tersedia',
                                  style: const TextStyle(fontSize: 11, color: Color.fromARGB(255, 28, 79, 247))),
                            ],
                          ),
                        ),
                        Text('Rp ${item.formattedPrice}/Pcs',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: active ? const Color.fromARGB(255, 121, 240, 29) : const Color.fromARGB(255, 137, 236, 25))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Halaman Detail/Edit (STATEFUL) ----------


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detail Barang',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: const Color(0xFF3F51B5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
      ),
      home: DetailBarangPage(item: StationeryItem(
        id: 1,
        name: 'Pulpen',
        description: 'Pulpen tinta hitam, nyaman digenggam, ujung 0.5 mm.',
        stock: 11,
        price: 50000,
      )), 
    );
  }


class DetailBarangPage extends StatefulWidget {
  final StationeryItem item;
  const DetailBarangPage({super.key, required this.item});

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  static const Color warnaUtama = Color(0xFF3F51B5);

  final TextEditingController _deskripsiController = TextEditingController(
    text: widget.item.description,
  );
  final TextEditingController _stokController =
      TextEditingController(text: widget.item.stock.toString());
  final TextEditingController _hargaController =
      TextEditingController(text: widget.item.price.toString());

  @override
  void dispose() {
    _deskripsiController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _simpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tersimpan: stok ${_stokController.text} pcs, '
          'harga Rp ${_hargaController.text}',
        ),
      ),
    );
  }

  InputDecoration _dekorasi({
    required String label,
    required IconData ikon,
    bool isDollar = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: isDollar
          ? const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                '\$',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            )
          : Icon(ikon, color: Colors.black87),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black38),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: warnaUtama, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: warnaUtama,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Pulpen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.asset(
                  'assets/pulpen.jpg',
                  fit: BoxFit.cover,
                  // Jika gambar belum ditambahkan, tampilkan placeholder
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.edit,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama dan harga satuan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Pulpen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp 3.000 / pcs',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E9E4F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Kartu form
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    minLines: 3,
                    decoration: _dekorasi(
                      label: 'Deskripsi',
                      ikon: Icons.description,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: _dekorasi(
                      label: 'Stok tersedia (pcs)',
                      ikon: Icons.inventory_2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: _dekorasi(
                      label: 'Harga (Rp)',
                      ikon: Icons.attach_money,
                      isDollar: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol simpan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save, size: 18, color: Colors.white),
                label: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaUtama,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ---------- Halaman Profil (STATELESS) ----------
class ProfilePage extends StatelessWidget {
  final String name;
  final List<StationeryItem> items;
  final int grandTotal;
  final int totalPortions;

  const ProfilePage({
    super.key,
    required this.name,
    required this.items,
    required this.grandTotal,
    required this.totalPortions,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = items.where((e) => e.stock > 0).toList();
    return Column(
      children: [
        const Header(title: 'Profil', subtitle: 'Akun Pemilik Toko'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: kSaffron),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: kGreen,
                    child: Text(name[0].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800, color: kInk)),
              ),
              const Center(
                child: Text('Pemilik Toko', style: TextStyle(color: kMuted)),
              ),
              const SizedBox(height: 22),
              _InfoTile(
                icon: Icons.storefront_outlined,
                title: 'Toko Alat Tulis',
                sub: 'Kelola stock dan harga barang dagangan Anda.',
              ),
              const SizedBox(height: 10),
              _InfoTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Barang Unggulan',
                sub: ordered.isEmpty
                    ? 'Pulpen, Buku Tulis dan Pensil.'
                    : '${ordered.map((e) => '${e.name} x${e.stock}').join(', ')}\n'
                        'Total $totalPortions Pcs: Rp ${formatPrice(grandTotal)}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  const _InfoTile({required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1EAE6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: kSaffron,
            child: Icon(icon, color: kInk, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: kInk, fontSize: 15)),
                const SizedBox(height: 2),
                Text(sub,
                    style: const TextStyle(color: kMuted, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
