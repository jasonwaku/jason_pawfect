class MealPlan {
  int _id;
  String _category;
  String _foodType;
  String _quantity;

  MealPlan(this._category,  this._foodType, this._quantity,);

  MealPlan.withId(this._id, this._category, this._foodType, this._quantity,);

  int get id => _id;
  String get category => _category;
  String get foodType => _foodType;
  String get quantity => _quantity;

  set category(String cat) {
    // if (cat.length <= 255) {
    this._category = cat;
    // }
  }

  set foodType(String food) {
    // if (food.length <= 255) {
    this._foodType = food;
    // }
  }

  set quantity(String qty) {
    this._quantity = qty;
  }

// Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['category'] = _category;
    map['foodType'] = _foodType;
    map['quantity'] = _quantity;
    return map;
  }
// Extract a Note object from a Map object
  MealPlan.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._category = map['title'];
    this._foodType = map['foodType'];
    this._quantity = map['quantity'];
  }
}