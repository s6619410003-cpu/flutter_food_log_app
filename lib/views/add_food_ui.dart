import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:intl/intl.dart';

class AddFoodUi extends StatefulWidget {
  const AddFoodUi({super.key});

  @override
  State<AddFoodUi> createState() => _AddFoodUiState();
}

class _AddFoodUiState extends State<AddFoodUi> {
  //ตัวควบคุมการป้อนข้อมูลใน TextField
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
  //ตัวแปรเก็บมื้อที่เลือก
  String foodMeal = 'เช้า';
  //ตัวแปรสำหรับเก็บข้อมูลวันที่ที่เลือกจากปฎิทิน
  DateTime? foodDate;
  //เมธอดเปิดปฎิทินให้ผู้ใช้เลือกวันที่ใน TextField นำวันที่เลือกไว้ใน foodDate และนำวันที่ที่เลือกมาแสดงใน TextField
  Future<void> pickDate() async {
    //เปิดปฎิทินให้ผู้ใช้เลือกวันที่ใน TextField
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        foodDate = picked;

        foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //เมธอดข้อมูลไปที่ Supabase
  Future<void> saveFood() async {
    //Validate Ui ตรวจสอบเบื้องต้นข้อมูลที่ผู้ใช้ป้อนเข้ามา
    if (foodNameCtrl.text.isEmpty ||
        foodPriceCtrl.text.isEmpty ||
        foodPersonCtrl.text.isEmpty ||
        foodDateCtrl.text.isEmpty) {
      //แจ้งเตือนผู้ใช้ให้กรอกข้อมูลให้ครบถ้วน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    //แพ็กข้อมูล
    Food food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDate!.toIso8601String(),
    );
    //ส่งไปยังบันทึกที่ Supabase ผ่าน SupabaseService
    //สร้าง instance ของ SupabaseService
    final Service = SupabaseService();
    await Service.insertFood(food);

    //แจ้งผลการทำงานกับผู้ใช้ เช่น บันทึกสำเร็จหรือไม่สำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    //กลับไปหน้า ShowAllFoodUi
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Toriko (トリコ)',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.yellow),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 40,
              right: 40,
              bottom: 50,
            ),
            child: Center(
              child: Column(
                children: [
                  // ส่วนแสดง Logo
                  Image.asset(
                    '/images/logo_food.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  // ป้อนกินอะไร
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'กินอะไร',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextField(
                    controller: foodNameCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'เช่น KFC, Pizza',
                    ),
                  ),
                  SizedBox(height: 20),
                  // เลือกกินมื้อไหน
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'กินมื้อไหน',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            foodMeal = 'เช้า';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              foodMeal == 'เช้า' ? Colors.green : Colors.grey,
                        ),
                        child: Text(
                          'เช้า',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            foodMeal = 'กลางวัน';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: foodMeal == 'กลางวัน'
                              ? Colors.green
                              : Colors.grey,
                        ),
                        child: Text(
                          'กลางวัน',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            foodMeal = 'เย็น';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              foodMeal == 'เย็น' ? Colors.green : Colors.grey,
                        ),
                        child: Text(
                          'เย็น',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            foodMeal = 'ว่าง';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              foodMeal == 'ว่าง' ? Colors.green : Colors.grey,
                        ),
                        child: Text(
                          'ว่าง',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // ป้อนกินไปเท่าไหร่
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'กินไปเท่าไหร่',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextField(
                    controller: foodPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'เช่น 299.50',
                    ),
                  ),
                  SizedBox(height: 20),
                  // ป้อนกินกันกี่คน
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'กินกันกี่คน',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextField(
                    controller: foodPersonCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'เช่น 3',
                    ),
                  ),
                  SizedBox(height: 20),
                  // เลือกกินไปวันไหน
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'กินไปวันไหน',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextField(
                    controller: foodDateCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'เช่น 2020-01-31',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    //เปิดปฎิทิน ให้ผู้ใช้เลือกวันที่ใน TextField
                    onTap: () {
                      pickDate();
                    },
                  ),
                  SizedBox(height: 20),
                  // ปุ่มบันทึก
                  ElevatedButton(
                    onPressed: () {
                      saveFood();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                    ),
                    child: Text("บันทึก",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(height: 10),
                  // ปุ่มยกเลิกมีผลในการแสดงผล
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        foodNameCtrl.clear();
                        foodPriceCtrl.clear();
                        foodPersonCtrl.clear();
                        foodDateCtrl.clear();
                        foodMeal = 'เช้า';
                        foodDate = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
