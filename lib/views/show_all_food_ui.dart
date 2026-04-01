import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/views/add_food_ui.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:flutter_food_log_app/views/update_del_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  // สร้างตัวแปรที่จะใช้เพื่อเก็บข้อมูลที่จะนำไปแสดงใน ListView ส่วน Body
  List<Food> foods = [];
  // สร้าง instance ของ SupabaseService เพื่อใช้ในการดึงข้อมูลอาหารทั้งหมด
  final SupabaseService supabaseService = SupabaseService();

  // สร้างตัวแปรสำหรับเก็บข้อมูลอาหารทั้งหมดที่ดึงมาจาก Supabase
  void loadAllFood() async {
    final data = await supabaseService.getAllFoods();

    setState(() {
      foods = data; // เก็บข้อมูลอาหารทั้งหมดที่ได้จาก Supabase ลงในตัวแปร state
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllFood(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลอาหารทั้งหมดเมื่อหน้าแสดงผลถูกสร้างขึ้น
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 30.0, right: 30.0),
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // 👉 แก้ไขตรงนี้: ส่งข้อมูลอาหารใน List ตำแหน่งที่กด ไปให้หน้า UpdateDelFoodUi
                                  builder: (context) =>
                                      UpdateDelFoodUi(food: foods[index])),
                            ).then((value) {
                              //กลับมาหน้า ShowAllFoodUi แล้วให้โหลดข้อมูลอาหารทั้งหมดใหม่ เพื่ออัพเดตข้อมูลที่อาจจะถูกแก้ไขหรือถูกลบไปแล้ว
                              loadAllFood();
                            });
                          },
                          leading: Image.asset(
                            // 👉 แก้ไขตรงนี้: เอา / ด้านหน้าออก และใส่ assets/ ให้ตรงกับรูป logo ด้านบน
                            'assets/images/hamburger.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          trailing: const Icon(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFoodUi()),
          ).then((value) {
            loadAllFood();
          });
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
