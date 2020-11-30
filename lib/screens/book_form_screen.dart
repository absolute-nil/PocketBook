import 'package:flutter/material.dart';
import 'package:pocketbook/data/subject_data.dart';
import 'package:pocketbook/model/subject.dart';
import 'package:pocketbook/providers/book.dart';
import 'package:pocketbook/providers/books.dart';
import 'package:pocketbook/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class SubjectDrowdown {
  String id;
  String name;

  SubjectDrowdown(this.id, this.name);

  static List<SubjectDrowdown> getSubjects() {
    return SUBJECT_DATA.map((sub) {
      return SubjectDrowdown(sub.id, sub.title);
    }).toList();
  }
}

class BookFormScreen extends StatefulWidget {
  static const id = "/book-form";
  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _sizeFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  final _authorFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _downloadURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _savedBook = Book(
      id: null,
      title: '',
      description: '',
      downloadUrl: '',
      imageUrl: '',
      isFavourite: false,
      author: '',
      duration: 0,
      size: 0,
      subject: '');

  var _isInit = true;
  var _loading = false;
  List<SubjectDrowdown> _subjectsList = SubjectDrowdown.getSubjects();
  List<DropdownMenuItem<SubjectDrowdown>> _dropdownMenuItems;
  SubjectDrowdown _selectedSubject;

  List<DropdownMenuItem<SubjectDrowdown>> buildDropdownMenuItems(
      List subjects) {
    List<DropdownMenuItem<SubjectDrowdown>> items = List();
    for (SubjectDrowdown sub in subjects) {
      items.add(
        DropdownMenuItem(
          value: sub,
          child: Text(sub.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(SubjectDrowdown selectedSubject) {
    setState(() {
      _selectedSubject = selectedSubject;
      _savedBook = Book(
          id: _savedBook.id,
          isFavourite: _savedBook.isFavourite,
          title: _savedBook.title,
          description: _savedBook.description,
          size: _savedBook.size,
          subject: selectedSubject.id,
          duration: _savedBook.duration,
          downloadUrl: _savedBook.downloadUrl,
          author: _savedBook.author,
          imageUrl: _savedBook.imageUrl);
    });
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_subjectsList);
    _selectedSubject = _savedBook.subject.isEmpty
        ? _dropdownMenuItems[0].value
        : _savedBook.subject;

    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final bookId = ModalRoute.of(context).settings.arguments as String;
      if (bookId != null) {
        _savedBook = Provider.of<Books>(context).findById(bookId);
        _imageURLController.text = _savedBook.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith("http") &&
              !_imageURLController.text.startsWith("https")) ||
          (!_imageURLController.text.endsWith(".png") &&
              !_imageURLController.text.endsWith(".jpg") &&
              !_imageURLController.text.endsWith(".jpeg"))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _durationFocusNode.dispose();
    _subjectFocusNode.dispose();
    _authorFocusNode.dispose();
    _titleFocusNode.dispose();
    _sizeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _downloadURLFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _loading = true;
    });
    if (_savedBook.id != null) {
      await Provider.of<Books>(context, listen: false)
          .updateBook(_savedBook.id, _savedBook);
    } else {
      try {
        await Provider.of<Books>(context, listen: false).addBook(_savedBook);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Could not process request"),
                  content: Text("Some error occoured please try again"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      } // finally {
      //   setState(() {
      //     _loading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _loading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Book"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      drawer: AppDrawer(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _savedBook.title,
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_authorFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: value,
                                description: _savedBook.description,
                                size: _savedBook.size,
                                subject: _savedBook.subject,
                                duration: _savedBook.duration,
                                downloadUrl: _savedBook.downloadUrl,
                                author: _savedBook.author,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedBook.author,
                          focusNode: _authorFocusNode,
                          decoration: InputDecoration(labelText: "Author"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_subjectFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: _savedBook.title,
                                description: _savedBook.description,
                                size: _savedBook.size,
                                subject: _savedBook.subject,
                                duration: _savedBook.duration,
                                downloadUrl: _savedBook.downloadUrl,
                                author: value,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          widthFactor: 2,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Select a subject"),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    focusNode: _subjectFocusNode,
                                    value: _selectedSubject,
                                    items: _dropdownMenuItems,
                                    onChanged: onChangeDropdownItem,
                                  ),
                                ),
                              ]),
                        ),
                        // TextFormField(
                        //   initialValue: _savedBook.subject,
                        //   focusNode: ,
                        //   decoration: InputDecoration(labelText: "Subject"),
                        //   textInputAction: TextInputAction.next,
                        //   onFieldSubmitted: (_) {
                        //     FocusScope.of(context)
                        //         .requestFocus(_descriptionFocusNode);
                        //   },
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'please provide a value';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     _savedBook = Book(
                        //         id: _savedBook.id,
                        //         isFavourite: _savedBook.isFavourite,
                        //         title: _savedBook.title,
                        //         description: _savedBook.description,
                        //         size: _savedBook.size,
                        //         subject: value,
                        //         duration: _savedBook.duration,
                        //         downloadUrl: _savedBook.downloadUrl,
                        //         author: _savedBook.author,
                        //         imageUrl: _savedBook.imageUrl);
                        //   },
                        // ),
                        TextFormField(
                          initialValue: _savedBook.description,
                          decoration: InputDecoration(labelText: "Description"),
                          minLines: 3,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            if (value.length < 10) {
                              return 'description must contain atleast 10 words';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: _savedBook.title,
                                description: value,
                                size: _savedBook.size,
                                subject: _savedBook.subject,
                                duration: _savedBook.duration,
                                downloadUrl: _savedBook.downloadUrl,
                                author: _savedBook.author,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedBook.size.toString(),
                          decoration: InputDecoration(labelText: "Size"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _sizeFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_durationFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter a valid number';
                            }

                            if (double.parse(value) < 0) {
                              return 'please enter a value greater than 0';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: _savedBook.title,
                                description: _savedBook.description,
                                size: int.parse(value),
                                subject: _savedBook.subject,
                                duration: _savedBook.duration,
                                downloadUrl: _savedBook.downloadUrl,
                                author: _savedBook.author,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedBook.duration.toString(),
                          decoration: InputDecoration(labelText: "Duration"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _durationFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_downloadURLFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter a valid number';
                            }

                            if (double.parse(value) < 0) {
                              return 'please enter a value greater than 0';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: _savedBook.title,
                                description: _savedBook.description,
                                size: _savedBook.size,
                                subject: _savedBook.subject,
                                duration: int.parse(value),
                                downloadUrl: _savedBook.downloadUrl,
                                author: _savedBook.author,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: _savedBook.downloadUrl,
                          focusNode: _downloadURLFocusNode,
                          decoration:
                              InputDecoration(labelText: "Download URL"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_imageURLFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _savedBook = Book(
                                id: _savedBook.id,
                                isFavourite: _savedBook.isFavourite,
                                title: _savedBook.title,
                                description: _savedBook.description,
                                size: _savedBook.size,
                                subject: _savedBook.subject,
                                duration: _savedBook.duration,
                                downloadUrl: value,
                                author: _savedBook.author,
                                imageUrl: _savedBook.imageUrl);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: Container(
                                child: _imageURLController.text.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Icon(Icons.image),
                                            Text("Enter Url")
                                          ])
                                    : FittedBox(
                                        child: Image.network(
                                          _imageURLController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageURLController,
                                focusNode: _imageURLFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please provide a value';
                                  }

                                  if (!value.startsWith("http") ||
                                      !value.startsWith("https")) {
                                    return 'please provide a valid url';
                                  }

                                  if (!value.endsWith(".png") &&
                                      !value.endsWith(".jpg") &&
                                      !value.endsWith(".jpeg")) {
                                    return "images should be in png,jpg,jpeg format";
                                  }

                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _savedBook = Book(
                                      id: _savedBook.id,
                                      isFavourite: _savedBook.isFavourite,
                                      title: _savedBook.title,
                                      description: _savedBook.description,
                                      size: _savedBook.size,
                                      subject: _savedBook.subject,
                                      duration: _savedBook.duration,
                                      downloadUrl: _savedBook.downloadUrl,
                                      author: _savedBook.author,
                                      imageUrl: value);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
