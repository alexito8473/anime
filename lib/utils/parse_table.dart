import 'package:anime/utils/zip.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

List parseTable(Bs4Element? table) {
  final columns = table
      ?.find('thead')
      ?.find('tr')
      ?.findAll('th')
      .map((x) => x.string)
      .toList();
  final rows = [];
  for (var row in table!.find('tbody')!.findAll('tr')) {
    final values = row.findAll('td');

    if (values.length != columns?.length) {
      throw Exception('Values size does not match column size.');
    }

    rows.add({
      for (var hx in Zip.zip([columns!, values])) hx[0]: hx[1]
    });
  }
  return rows;
}