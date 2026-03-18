//คลาสนี้ใช้เป้นการเขียนดโค้ดคำสั่งที่เกี่ยวกับการเชื่อมต่อกับ Supabase ในอนาคต
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/ตัวแปรสำหรับเชื่อมต่อกับ Supabaseเกี่ยวกับงานต่างๆ
  final SupabaseClient supabase = Supabase.instance.client;
  //ส่วนต่อไปเป็นของเมธอดการทำงานต่างๆที่เกี่ยวกับการเชื่อมต่อกับ Supabase เช่น การเพิ่มข้อมูลอาหาร การแสดงข้อมูลอาหาร การแก้ไขข้อมูลอาหาร และการลบข้อมูลอาหาร เป็นต้น
}
