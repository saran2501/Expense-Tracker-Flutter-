

import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter =DateFormat.yMd();
enum Category {
  food,
  travel,
  entertainment,
  groceries,
  medical,
  savings,
  shopping,
  personalcare,
}

const categoryicons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.entertainment: Icons.movie,
  Category.groceries: Icons.shopping_cart, // Daily groceries
  Category.medical: Icons.local_hospital, // Medical expenses
  Category.savings: Icons.savings, // Savings and deposits
  Category.shopping: Icons.shopping_bag, // Shopping expenses
  Category.personalcare: Icons.spa, // Beauty, grooming, etc.
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }): id =uuid.v4();
 
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category  category;
  String get formattedDate{return formatter.format(date);}
}
class ExpenseBucket{
 const  ExpenseBucket({
    required this.category,
    required this.expense,
   });
  
 ExpenseBucket.forCategory(List<Expense> allExpenses,this.category):expense=allExpenses.where((expense) => expense.category == category).toList();
     
   
  final Category category;
  final List<Expense> expense;
  double get totalExpenses{
    double sum =0;
    for (final expense in expense ) 
    {
      sum=sum+expense.amount;
    }
    return sum;

  }

}