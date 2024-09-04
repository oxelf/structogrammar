
class CppParser {
  static List<String> keywords = [
    "for",
    "while",
    "if",
    "else",
    "(",
    ")",
    "{",
    "}",
    "[",
    "]",
    ";",
    "=",
    "==",
    "+",
    "-",
    "*",
    "/",
    "%",
    ">",
    "<"
  ];

  static List<String> tokenize(String code) {
    List<String> tokens = [];
    List<String> split = code.split(" ");

    List<String> cleanToken(String t) {
      List<String> newTokens = [];

      if (t.isEmpty) {
        return [];
      }

      // Iterate over each keyword and check if the current token contains it
      for (var keyword in keywords) {
        if (t.contains(keyword)) {
          int index = t.indexOf(keyword);
          String beforeKeyword = t.substring(0, index);
          String afterKeyword = t.substring(index + keyword.length);

          if (beforeKeyword.isNotEmpty) {
            newTokens.addAll(cleanToken(beforeKeyword));
          }

          newTokens.add(keyword);

          if (afterKeyword.isNotEmpty) {
            newTokens.addAll(cleanToken(afterKeyword));
          }

          return newTokens;
        }
      }
      return [t];
    }


    return tokens;
  }
}
