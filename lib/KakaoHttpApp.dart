import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KakaoHttpApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _KakaoHttpApp();
  }
}

class _KakaoHttpApp extends State<KakaoHttpApp>{
  TextEditingController? _textEditingController;
  ScrollController? _scrollController;

  List? data;
  int page = 1;
  bool is_end = false;

  @override
  void initState(){
    super.initState();
    data = new List.empty(growable: true);
    _textEditingController = new TextEditingController();
    _scrollController = new ScrollController();

    _scrollController!.addListener(() {
      if(_scrollController!.offset >= _scrollController!.position.maxScrollExtent && !_scrollController!.position.outOfRange && is_end == false){
        page++;
        getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title : TextField(
          controller: _textEditingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: "검색어를 입력해주세요"),
        )
      ),
      body: Container(
        child: Center(






          child: data!.length == 0 
           ? Text("데이터가 없습니다")
          :
            ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index){
              return Card(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Image.network(
                        data![index]["thumbnail"],
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: Text(
                              data![index]['title'].toString(),
                              textAlign: TextAlign.center,
                            ),

                          ),
                          
                          Text(data![index]['authors'].toString()),
                          Text(data![index]['sale_price'].toString()),
                          Text(data![index]['status'].toString()),
                        ],
                      ),


                    ],
                  ),
                ),
              );
            },
            
            itemCount: data!.length,
            
            )






        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          data!.clear();
          await getData();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  getData() async{
    var url = "https://dapi.kakao.com/v3/search/book?target=title"
              "&page=${page}&query=${_textEditingController!.value.text}"; //카카오 url
    var respone = await http.get(Uri.parse(url),
      headers: {"Authorization" : "KakaoAK c92f7f1e09657c9a386ef001951615d8"}
    );

    setState(() {
      var dataFromJson = json.decode(respone.body);

      List result = dataFromJson["documents"];
      is_end = dataFromJson["meta"]["is_end"];

      data!.addAll(result);
    });
  }
}