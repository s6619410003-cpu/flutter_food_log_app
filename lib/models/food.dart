//คลาสนี้ใช้สำหรับจทำงานร่วมกับตารางอาหารในฐานข้อมูลของ Supabase
// ignore_for_file: non_constant_identifier_names

class Food {
  //สร้างตัวแปรสำหรับเก็บข้อมูลของอาหารแต่ละรายการและล้อกับชื่อคอลัมน์ในตารางอาหารของฐานข้อมูลที่จะทำงานด้วย
  String? id;
  DateTime? created_at;
  DateTime? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;
//กำหนดคอนสตรัคเตอร์สำหรัยกำหนดค่าข้อมูล
  Food({
    this.id,
    this.created_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
  });

  //แปลงข้อมูลจาแอป เพื่อส่งไปยัง supabase
  Map<String, dynamic> toMap() => {
        'id': id,
        'created_at': created_at?.toIso8601String(),
        'foodDate': foodDate?.toIso8601String(),
        'foodMeal': foodMeal,
        'foodName': foodName,
        'foodPrice': foodPrice,
        'foodPerson': foodPerson,
      };
  //แปลงข้อมูลจาก supabase เพื่อส่งไปยังแอป(ใช้)
  factory Food.fromMap(Map<String, dynamic> map) => Food(
        id: map['id'] as String?,
        created_at: DateTime.tryParse(map['created_at'] as String),
        foodDate: DateTime.tryParse(map['foodDate'] as String),
        foodMeal: map['foodMeal'] as String,
        foodName: map['foodName'] as String,
        foodPrice: double.tryParse(map['foodPrice'] as String),
        foodPerson: int.tryParse(map['foodPerson'] as String),
      );
}
