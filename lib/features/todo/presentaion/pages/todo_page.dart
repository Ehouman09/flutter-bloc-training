import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notey/features/todo/presentaion/cubit/todo_cubit.dart';
import 'package:notey/features/todo/presentaion/pages/add_todo.dart';
import 'package:notey/core/widgets/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  Color pickedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title, style: TextStyle(color: Colors.black, fontFamily: 'ceraBold', fontSize: 30),),
        elevation: 0,
        actions: [
          PopupMenuButton<Color>(
            onSelected: (i){
              if(i == pickedColor){

              }else{

              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.sliders, color: darkBlue,),
            ),
            itemBuilder: (BuildContext context) {
              return colors.map((Color color) {
                return PopupMenuItem(
                  value: color,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: (color == pickedColor) ? Border.all(color: Colors.green, width: 4) : Border.all(color: Colors.black, width: 1)
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state){
            if(state is TodoListSuccess){
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: MasonryGridView.builder(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: state.todos.length,
                    itemBuilder: (context, i){
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${state.todos[i].title}", style: TextStyle(fontFamily: 'ceraBold', fontSize: 25, color: Colors.black),),
                            SizedBox(height: 10,),
                            Text("${state.todos[i].description}", style: TextStyle(fontSize: 20, color: Colors.black))
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: state.todos[i].color.toColor(),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.black, width: 1)
                        ),
                      );
                    },
                  )
              );
            } else if(state is TodoListInProgress){
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(color: darkBlue,),
                ),
              );
            } else if(state is TodoFailure){
              return Center(
                child: Container(
                  width: 400,
                  child: Text("${state.message}", textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black, fontFamily: 'ceraBold', fontSize: 20),
                  )
                )
              );
            }
            return  Center(
              child: Text("Noting for the moment...", style: TextStyle(color: Colors.black, fontFamily: 'ceraBold', fontSize: 20),),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFullModal(context);
        },
        backgroundColor: darkBlue,
        elevation: 10,
        tooltip: 'Add Note',
        child: Icon(Icons.add, size: 30,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showFullModal(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(milliseconds: 150), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) { // your widget implementation
        return AddNotePage();
      },
    );
  }
}
