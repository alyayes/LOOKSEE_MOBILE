import 'package:flutter/material.dart';
import 'payment_details_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedTab = 'All';
  final List<String> tabs = ['All', 'Pending', 'Prepared', 'Shipped'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Orders"), // Warna pink dari main.dart
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          // TABS OVAL
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: tabs.map((tab) => _buildTab(tab)).toList(),
              ),
            ),
          ),

          // LIST ORDER
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _orderItem(
                  date: "01 April 2025",
                  title: "Robbonie Cardigan",
                  price: "1x Rp 195.000",
                  img: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=200",
                  btnLabel: "Pay Now",
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDetailsPage())),
                ),
                _orderItem(
                  date: "28 Maret 2025",
                  title: "Arket Shirt",
                  price: "1x Rp 120.000",
                  img: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200",
                  btnLabel: "See Detail",
                ),
                _orderItem(
                  date: "28 Maret 2025",
                  title: "Arket Shirt",
                  price: "1x Rp 175.000",
                  img: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200",
                  btnLabel: "See Detail",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    bool isActive = selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tab),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF69B4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFFFF69B4) : Colors.grey.shade300),
        ),
        child: Text(
          tab,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _orderItem({
    required String date,
    required String title,
    required String price,
    required String img,
    required String btnLabel,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(img, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(price, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 35,
                      width: 140, // Lebar tombol disesuaikan
                      child: OutlinedButton(
                        onPressed: onTap ?? () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF69B4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(btnLabel, style: const TextStyle(color: Color(0xFFFF69B4), fontSize: 13)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30), // Jarak antar item
      ],
    );
  }
}