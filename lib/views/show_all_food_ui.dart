import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  //สร้างตัวแปรที่จะใช้เพื่อเก็บข้อมูลที่จะนำไปแสดงใน ListView ส่วนBody
  List<Food> foods = [];
  // สร้าง instance ของ SupabaseService เพื่อใช้ในการดึงข้อมูลอาหารทั้งหมด
  final SupabaseService supabaseService = SupabaseService();
  // สร้างตัวแปรสำหรับเก็บข้อมูลอาหารทั้งหมดที่ดึงมาจาก Supabase
  void loadAllFood() async {
    final data = await supabaseService.getAllFoods();

    setState(() {
      foods = data; // เก็บข้อมูลอาหารทั้งหมดที่ได้จาก Supabase ลงในตัวแปร state
    });
    // ทำอะไรกับข้อมูลอาหารทั้งหมดที่ได้มา เช่น แสดงใน ListView หรือเก็บไว้ในตัวแปร state
  }

  @override
  void initState() {
    super.initState();
    loadAllFood(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลอาหารทั้งหมดเมื่อหน้าแสดงผลถูกสร้างขึ้น
  }

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
              'assets/images/logo_food.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ), // จัดวงเล็บปิดของ Image.asset ให้ถูกต้อง
            SizedBox(
                height:
                    20), // นำ SizedBox กลับเข้ามาอยู่ใน Array ของ children อย่างถูกต้อง
            Expanded(
              child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 30.0, right: 30.0),
                      child: ListTile(
                          onTap: () {},
                          leading: Image.asset(
                            '/images/hamburger.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          trailing: Icon(
                            Icons.info,
                            color: Colors.red,
                          ),
                          title: Text('กิน ${foods[index].foodName}'),
                          subtitle: Text(
                              'วันที่: ${foods[index].foodDate} มื้อ: ${foods[index].foodMeal}'),
                          tileColor: index % 2 == 0
                              ? Colors.red[200]
                              : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    );
                  }),
            ),
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
          ).then((value) {
            loadAllFood();
          }); // เรียกใช้ฟังก์ชัน loadAllFood หลังจากกลับมาจากหน้า AddFoodUi เพื่อรีเฟรชข้อมูลใน ListVie เข้าใจง่ายๆคือการรีโหลดน่าจอ
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
