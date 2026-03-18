import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  @override
  Widget build(BuildContext context) {
    // เอา const หน้า Scaffold ออก
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0000),
        title: const Text(
          'รายการอาหารทั้งหมด',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/hamburger.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ), // จัดวงเล็บปิดของ Image.asset ให้ถูกต้อง
            const SizedBox(
                height:
                    20), // นำ SizedBox กลับเข้ามาอยู่ใน Array ของ children อย่างถูกต้อง
          ],
        ),
      ),
      // แก้ให้ f ตัวหน้าสุดเป็นตัวพิมพ์เล็ก
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // แก้จาก Navigation เป็น Navigator
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFoodUi()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color(0xFFFF0000),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
