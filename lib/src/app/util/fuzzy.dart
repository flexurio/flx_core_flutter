bool fuzzyMatch(String query, String target) {
  if (query.isEmpty) {
    return true;
  }

  var queryIndex = 0;

  for (var i = 0; i < target.length; i++) {
    if (target[i].toLowerCase() == query[queryIndex].toLowerCase()) {
      queryIndex++;
      if (queryIndex == query.length) {
        return true;
      }
    }
  }

  return false;
}
