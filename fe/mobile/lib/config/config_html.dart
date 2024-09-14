import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

String stripHtmlTags(String html) {
  dom.Document document = parse(html);
  return parse(document.body?.text ?? '').documentElement?.text ?? '';
}
