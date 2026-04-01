import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supabase_service.dart';
import 'package:intl/intl.dart';

class UpdateDelFoodUi extends StatefulWidget {
  // สร้าวตัวแปรสำหรับรับข้อมูลอาหารที่ต้องการแก้ไขหรือจะลบ จากหน้าShowAllFoodUi
  Food?
      food; // ประกาศตัวแปร food ที่เป็น nullable เพื่อรับข้อมูลอาหารที่ต้องการแก้ไขหรือจะลบ
  UpdateDelFoodUi({
    super.key,
    this.food,
  });

  @override
  State<UpdateDelFoodUi> createState() => _UpdateDelFoodUiState();
}

class _UpdateDelFoodUiState extends State<UpdateDelFoodUi> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //เอาข้อมูลอาหารที่ส่งมาจากหน้า ShowAllFoodUi มาแสดงใน TextField และปุ่มเลือกมื้ออาหาร
    if (widget.food != null) {
      foodNameCtrl.text = widget.food!.foodName;
      foodMeal = widget.food!.foodMeal;
      foodPriceCtrl.text = widget.food!.foodPrice.toString();
      foodPersonCtrl.text = widget.food!.foodPerson.toString();
      foodDateCtrl.text = widget.food!.foodDate;
      //กำหนดค่า foodDate จากวันที่ที่ได้จาก widget.food!.foodDate โดยแปลงจาก String เป็น DateTime
      foodDate = DateTime.parse(widget.food!.foodDate);
    }
  }

  //เรียกใช้าเมธอดบันทึกแก้ไขข้อมูลอาหารที่ส่งไปยัง SupabaseService เพื่ออัพเดตข้อมูลอาหารในฐานข้อมูล Supabase
  void editFood() async {
    //Validate
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
    //เรียกใช้าเมธอดบันทึกแก้ไขข้อมูลอาหารที่ส่งไปยัง SupabaseService เพื่ออัพเดตข้อมูลอาหารในฐานข้อมูล Supabase
    final Service = SupabaseService();
    await Service.updateFood(widget.food!.id!, food);

    //แจ้งผลการแก้ไขข้อมูลอาหารสำเร็จหรือไม่สำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    //ย้อนกลับไปยังหน้า ShowAllFoodUi เพื่อแสดงข้อมูลอาหารที่ถูกแก้ไขแล้ว
    Navigator.pop(context);
  }

  //mathod ลบข้อมูลอาหารที่ส่งไปยัง SupabaseService เพื่อทำการลบข้อมูลอาหารในฐานข้อมูล Supabase
  Future<void> delFood() async {
    //แสดง Dialog เพื่อยืนยันการลบข้อมูลอาหารก่อนที่จะลบข้อมูลอาหารจริงๆ
    await showDialog(
      //ไดอะล็อกแสดงที่หน้าจอไหน หน้านี้แหละ
      context: context,
      builder: (context) => AlertDialog(
        //หัวข้อของไดอะล็อก
        title: Text('ยืนยันการลบข้อมูลอาหาร'),
        //เนื้อหาของไดอะล็อก
        content: Text('คุณต้องการลบข้อมูลอาหารนี้หรือไม่?'),
        //ปุ่มคำสั่งในไดอะล็อก
        actions: [
          //ปุ่มยกเลิกการลบข้อมูลอาหาร
          ElevatedButton(
            onPressed: () {
              //ปิดไดอะล็อกโดยไม่ทำอะไร
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('ยกเลิก',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          //ปุ่มยืนยันการลบข้อมูลอาหาร
          ElevatedButton(
            onPressed: () async {
              //เรียกใช้าเมธอดลบข้อมูลอาหารที่ส่งไปยัง SupabaseService เพื่อทำการลบข้อมูลอาหารในฐานข้อมูล Supabase
              final Service = SupabaseService();
              await Service.deleteFood(widget.food!.id!);

              //แจ้งผลการลบข้อมูลอาหารสำเร็จหรือไม่สำเร็จ
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ลบข้อมูลสำเร็จ'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              //ปิดไดอะล็อกหลังจากลบข้อมูลอาหารเสร็จแล้ว
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('ยืนยันลบข้อมูล',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ส่วนของแอปบาร์
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0000),
        title: const Text(
          'Toriko นักล่าอาหาร (แก้ไข/ลบ)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // กลับไปยังหน้าก่อนหน้า
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      // ส่วนของเนื้อหาในหน้า body
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
                        backgroundColor:
                            foodMeal == 'กลางวัน' ? Colors.green : Colors.grey,
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
                    editFood();
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
                  child: Text("บันทึกแก้ไข",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 10),
                // ปุ่มยกเลิกมีผลในการแสดงผล
                ElevatedButton(
                  onPressed: () {
                    delFood().then((value) {
                      //ย้อนกลับไปยังหน้า ShowAllFoodUi เพื่อแสดงข้อมูลอาหารที่ถูกลบแล้ว
                      Navigator.pop(context);
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
                    "ลบข้อมูล",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
