import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() => runApp(const IktibasApp());

class IktibasApp extends StatelessWidget {
  const IktibasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.amber),
      home: const IktibasHome(),
    );
  }
}

class IktibasHome extends StatefulWidget {
  const IktibasHome({super.key});
  @override
  State<IktibasHome> createState() => _IktibasHomeState();
}

class _IktibasHomeState extends State<IktibasHome> {
  final List<Map<String, String>> _iktibaslar = [];
  List<Map<String, String>> _filtreli = [];
  double _size = 18.0;
  final _ara = TextEditingController();

  @override
  void initState() { super.initState(); _filtreli = _iktibaslar; }

  void _ekle({int? i}) {
    String b = i != null ? _iktibaslar[i]['b']! : '', ic = i != null ? _iktibaslar[i]['ic']! : '', n = i != null ? _iktibaslar[i]['n']! : '';
    showDialog(context: context, builder: (c) => AlertDialog(
      title: Text(i == null ? 'Yeni' : 'Düzenle'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(decoration: const InputDecoration(labelText: 'Başlık'), controller: TextEditingController(text: b), onChanged: (v) => b = v),
        TextField(decoration: const InputDecoration(labelText: 'İçerik'), maxLines: 3, controller: TextEditingController(text: ic), onChanged: (v) => ic = v),
        TextField(decoration: const InputDecoration(labelText: 'Not'), controller: TextEditingController(text: n), onChanged: (v) => n = v),
      ]),
      actions: [ElevatedButton(onPressed: () {
        setState(() {
          if (i == null) _iktibaslar.add({'b': b, 'ic': ic, 'n': n});
          else _iktibaslar[i] = {'b': b, 'ic': ic, 'n': n};
          _filtreli = _iktibaslar;
        });
        Navigator.pop(c);
      }, child: const Text('Kaydet'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextField(controller: _ara, decoration: const InputDecoration(hintText: 'Ara...'), onChanged: (v) => setState(() => _filtreli = _iktibaslar.where((e) => e['ic']!.contains(v)).toList()))),
      body: ListView.builder(itemCount: _filtreli.length, itemBuilder: (c, i) => Card(
        child: ListTile(
          title: Text(_filtreli[i]['b']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_filtreli[i]['ic']!, style: TextStyle(fontSize: _size)),
            Text('Not: ${_filtreli[i]['n']}', style: const TextStyle(fontStyle: FontStyle.italic)),
          ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.share), onPressed: () => Share.share(_filtreli[i]['ic']!)),
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _ekle(i: i)),
          ]),
        ),
      )),
      floatingActionButton: FloatingActionButton(onPressed: _ekle, child: const Icon(Icons.add)),
    );
  }
}
