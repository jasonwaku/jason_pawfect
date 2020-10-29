import 'package:flutter/material.dart';
import 'package:pawfect/models/meal_plan.dart';
import 'package:pawfect/utils/local/database_helper.dart';

class MealPlanModify extends StatefulWidget {
  final MealPlan mealPlan;

  MealPlanModify(this.mealPlan);

  @override
  State<StatefulWidget> createState() {
    return MealPlanModifyState(this.mealPlan);
  }
}

class MealPlanModifyState extends State<MealPlanModify> {
  List<String> _category = [
    'Beef',
    'Chicken',
    'Lamb',
    'Fruits',
    'Vegetables',
  ];
  String _selectedCategory;

  List<String> _foodType = [
    'type 1',
    'type 2',
    'type 3',
    'type 4',
    'type 5',
  ];
  String _selectedFoodType;

  //static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  MealPlan todo;

  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  MealPlanModifyState(this.todo);

  onChangeDropdownItemCategory(selectedCategory) {
    setState(() {
      // fieldFocusChange(context, _CategoryFocusNode, _FoodTypeFocusNode);
      _selectedCategory = selectedCategory;
      todo.category = _selectedCategory;
      // _petBreed = _selectedCategory;
    });
  }

  onChangeDropdownItemFoodType(selectedFoodType) {
    setState(() {
      // fieldFocusChange(context, _activityLevelFocusNode, _sexFocusNode);
      _selectedFoodType = selectedFoodType;
      todo.foodType = _selectedFoodType;
      // _petActivityLevel = _selectedFoodType;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black54,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    );

    quantityController.text = todo.quantity;
    // descriptionController.text = todo.description;
    final categoryDropdown = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          'Select Category',
          style: TextStyle(
            color: Colors.black54,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
        autofocus: true,
        value: _selectedCategory,
        onChanged: onChangeDropdownItemCategory,
        isDense: false,
        items: _category.map((category) {
          return DropdownMenuItem(
            child: new Text(category),
            value: category,
          );
        }).toList(),
        style: TextStyle(
          color: Colors.black54,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    );

    final foodTypeDropdown = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        isExpanded: true,
        hint: Text(
          'Select Food Type',
          style: TextStyle(
            color: Colors.black54,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
        autofocus: true,
        value: _selectedFoodType,
        onChanged: onChangeDropdownItemFoodType,
        isDense: false,
        items: _foodType.map((foodType) {
          return DropdownMenuItem(
            child: new Text(foodType),
            value: foodType,
          );
        }).toList(),
        style: TextStyle(
          color: Colors.black54,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    );

    return
      // WillPopScope(
      //   onWillPop: () {
      //     // Write some code to control things, when user press Back navigation button in device navigationBar
      //     // ignore: missing_return
      //     moveToLastScreen();
      //   },
      //   child:

        Scaffold(
          appBar: AppBar(
            title: Text('Dog Meal Plan'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // First element
                // ListTile(
                //   title: DropdownButton(
                // 	    items: _category.map((String dropDownStringItem) {
                // 	    	return DropdownMenuItem<String> (
                // 			    value: dropDownStringItem,
                // 			    child: Text(dropDownStringItem),
                // 		    );
                // 	    }).toList(),
                //
                // 	    style: textStyle,
                //
                // 	    value: _selectedCategory, //getPriorityAsString(todo.priority),
                //
                // 	    onChanged: onChangeDropdownItemCategory, //(valueSelectedByUser) {
                // 	    	// setState(() {
                // 	    	//   debugPrint('User selected $valueSelectedByUser');
                // 	    	//   todo.category = _selectedCategory; //updatePriorityAsInt(valueSelectedByUser);
                // 	    	// });
                // 	    // }
                //   ),
                // ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: categoryDropdown,
                  // TextField(
                  //   controller: quantityController,
                  //   style: textStyle,
                  //   onChanged: (value) {
                  //     debugPrint('Something changed in Title Text Field');
                  //     updateQuantity();
                  //   },
                  //   decoration: InputDecoration(
                  //       labelText: 'Title',
                  //       labelStyle: textStyle,
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0))),
                  // ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: foodTypeDropdown,
                  // TextField(
                  //   controller: descriptionController,
                  //   style: textStyle,
                  //   onChanged: (value) {
                  //     debugPrint('Something changed in Description Text Field');
                  //     updateDescription();
                  //   },
                  //   decoration: InputDecoration(
                  //       labelText: 'Description',
                  //       labelStyle: textStyle,
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5.0))),
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: quantityController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Quantity changed');
                      updateQuantity();
                    },
                    decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Color(0xFF03B898),
                          textColor: Colors.white,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Color(0xFF03B898),
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // )
      );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  // void updatePriorityAsInt(String value) {
  // 	switch (value) {
  // 		case 'High':
  // 			todo.priority = 1;
  // 			break;
  // 		case 'Low':
  // 			todo.priority = 2;
  // 			break;
  // 	}
  // }

  // Convert int priority to String priority and display it to user in DropDown
  // String getPriorityAsString(int value) {
  // 	String priority;
  // 	switch (value) {
  // 		case 1:
  // 			priority = _priorities[0];  // 'High'
  // 			break;
  // 		case 2:
  // 			priority = _priorities[1];  // 'Low'
  // 			break;
  // 	}
  // 	return priority;
  // }

  // // Update the title of todo object
  // void updateCategory() {
  //   todo.title = titleController.text;
  // }
  //
  // // Update the description of todo object
  // void updateDescription() {
  //   todo.description = descriptionController.text;
  // }

  void updateQuantity() {
    todo.quantity = quantityController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', ' Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving ');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW todo i.e. he has come to
    // the detail page by pressing the FAB of todoList page.
    if (todo.id == null) {
      _showAlertDialog('Status', 'Nothing was deleted');
      return;
    }

    // Case 2: User is trying to delete the old todo that already has a valid ID.
    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', ' Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting ');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
