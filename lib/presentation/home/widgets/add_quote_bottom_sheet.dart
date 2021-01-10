import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/data/models/quote_model.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';

class AddQuoteBottomSheet extends StatefulWidget {
  final List<QuoteList> list;
  final Function getQuotesList;
  final BuildContext scaffoldContext;

  const AddQuoteBottomSheet({
    Key key,
    this.list,
    this.getQuotesList,
    this.scaffoldContext,
  }) : super(key: key);

  @override
  _AddQuoteBottomSheetState createState() => _AddQuoteBottomSheetState();
}

class _AddQuoteBottomSheetState extends State<AddQuoteBottomSheet> {
  final _formkey = GlobalKey<FormState>();
  AddQuote _addQuote;
  Quote quote;
  QuoteList quoteList;

  @override
  void initState() {
    super.initState();
    _addQuote = getIt<AddQuote>();
    quote = QuoteModel();
    quoteList = QuoteList();
  }

  @override
  Widget build(BuildContext context) {
    final insetBottom = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOff = insetBottom == 0;

    return Container(
      height: isKeyboardOff
          ? MediaQuery.of(context).size.height / 1.1
          : MediaQuery.of(context).size.height / 1.05,
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Form(
        key: _formkey,
        child: ListView(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).translate('author'),
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return AppLocalizations.of(context).translate('fill_field');
                }

                return null;
              },
              onSaved: (val) {
                quote.author = val;
              },
            ),
            SizedBox(height: isKeyboardOff ? 15 : 10),
            TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white70),
              maxLines: isKeyboardOff ? 10 : 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).translate('quote'),
                alignLabelWithHint: true,
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return AppLocalizations.of(context).translate('fill_field');
                }

                return null;
              },
              onSaved: (val) {
                quote.content = val;
              },
            ),
            DropdownButtonFormField(
              style: TextStyle(color: Colors.white70),
              dropdownColor: Color(0XFF605c65),
              icon: Icon(Icons.arrow_drop_down),
              items: widget.list
                  .map(
                    (item) => DropdownMenuItem(
                      child: Text(item.name),
                      value: item,
                    ),
                  )
                  .toList(),
              onSaved: (val) {
                quoteList = val;
              },
              onChanged: (val) {
                setState(() {
                  quoteList = val;
                });
              },
            ),
            SizedBox(height: isKeyboardOff ? 30 : 10),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('create')),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.green,
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  _formkey.currentState.save();

                  final res = await _addQuote(
                    AddQuoteParams(
                      listId: quoteList.id,
                      author: quote.author,
                      content: quote.content,
                    ),
                  );

                  if (res.isLeft()) {
                    Scaffold.of(widget.scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('add_quote_error')),
                      ),
                    );
                  } else {
                    widget.getQuotesList();

                    Navigator.pop(context);
                  }
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('cancel')),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
