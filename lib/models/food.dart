//คลาสนี้ใช้สำหรับทำงานร่วมกับตารางในฐานข้อมูลที่จะทำงานด้วย

// ignore_for_file: non_constant_identifier_names

class Food {
  //ตัวแปลที่ตั้งชื่อให้ตรงกับคอลัมน์ในตารางของฐานข้อมูล เพื่อให้ง่ายต่อการแปลงข้อมูล
  String? id;
  String foodDate;
  String foodMeal;
  String foodName;
  double foodPrice;
  int foodPerson;

  Food({
    this.id,
    required this.foodDate,
    required this.foodMeal,
    required this.foodName,
    required this.foodPrice,
    required this.foodPerson,
  });

//แปลงข้อมูลที่รับมาจาก Supabase เพื่อมาใช้ในแอปฯ
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      foodDate: json['foodDate'],
      foodMeal: json['foodMeal'],
      foodName: json['foodName'],
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodPerson: json['foodPerson'],
    );
  }

//แปลงข้อมูลจากแอปฯ เพื่อส่งไปยัง Supabase
  Map<String, dynamic> toJson() {
    return {
      "foodDate": foodDate,
      "foodMeal": foodMeal,
      "foodName": foodName,
      "foodPrice": foodPrice,
      "foodPerson": foodPerson,
    };
  }
}
