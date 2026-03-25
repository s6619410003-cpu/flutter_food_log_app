//คลาสนี้ใช้เป้นการเขียนดโค้ดคำสั่งที่เกี่ยวกับการเชื่อมต่อกับ Supabase ในอนาคต
import 'package:flutter_food_log_app/models/food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/ตัวแปรสำหรับเชื่อมต่อกับ Supabaseเกี่ยวกับงานต่างๆ
  final SupabaseClient supabase = Supabase.instance.client;
  //ส่วนต่อไปเป็นของเมธอดการทำงานต่างๆที่เกี่ยวกับการเชื่อมต่อกับ Supabase เช่น การเพิ่มข้อมูลอาหาร การแสดงข้อมูลอาหาร การแก้ไขข้อมูลอาหาร และการลบข้อมูลอาหาร เป็นต้น

  //สร้างเมธอดสำหรับการดึงข้อมูลทั้งหมดจาก food_tb ใน Supabase
  Future<List<Food>> getAllFoods() async {
    final data = await supabase
        .from('food_tb')
        .select("*")
        .order('foodDate', ascending: false);
    //แปลงข้อมูลที่ได้จาก Supabase เป็น json และนำไปสร้างเป็น List ของ Food
    return data.map((e) => Food.fromJson(e)).toList();
  }

  //สร้างเมธอดเพิ่มข้ิมูลอาหารใหม่ลงใน food_tb ใน Supabase
  Future insertFood(Food food) async {
    await supabase.from('food_tb').insert(food.toJson());
  }
}
