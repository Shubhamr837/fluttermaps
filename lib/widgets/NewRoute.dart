import 'package:flutter/material.dart';

class NewRoute extends StatefulWidget {
  final Function addRoute;

  NewRoute(this.addRoute);

  @override
  _NewRouteState createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredDescription = amountController.text;

    if (enteredTitle.isEmpty ) {
      return;
    }

    widget.addRoute(
      enteredTitle,
      enteredDescription,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: MediaQuery.of(context).size.height*0.6,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
              // onChanged: (val) {
              //   titleInput = val;

            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: amountController,

              onSubmitted: (_) => submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            FlatButton(
              child: Text('Add Route'),
              textColor: Colors.blue,
              onPressed: submitData,
            ),
          ],
        ),
      ),
    );
  }
}