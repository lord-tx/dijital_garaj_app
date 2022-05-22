import 'dart:convert';
import 'package:crypto/crypto.dart';


String getHashString(Map<String, String> value){

  String md5Hash = value["md5Hash"] ?? "";
  String email = value["email"] ?? "";
  String hashString = "";
  int mdLength = 32;
  int count = (md5Hash.length)~/mdLength;
  int currentBatch = 0;

  if (md5Hash == "" || email == ""){
    return "";
  }

  while (count != 0){
    // print("Count: $count");
    /// Set the current Hash, the first 32
    String currentHash = md5Hash.substring(currentBatch, currentBatch + mdLength);
    // print("Current Hash: $currentHash");
    /// Fetch the best matching char set
    String nextCharSet = getNextChars(currentHash, hashString, email);
    if (nextCharSet == ""){
      break;
    }
    hashString += nextCharSet;
    currentBatch += mdLength;
    --count;
  }
  // print(hashString);
  return hashString;
}

/// Function to generate md5hash from crypto package
String generateMd5(String input) => md5.convert(utf8.encode(input)).toString();

/// Function to return custom hash String
String hash(String x, String email) => generateMd5((generateMd5(email)+x+generateMd5(x)));

String getNextChars(String currentHash, String currentWord, String email) {
  /// Create character list for bruteForce
  const List<String> charList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '—','.', '_', '@', ','];
  int i = 0; // First Counter
  int j = 0; // Second Counter
  //        println("Current Word: ${currentWord}")

  while (i < charList.length){
    while (j < charList.length){
      String charOne = charList[i];
      String charTwo = charList[j];
      /// Append the two characters to the current word
      String word = currentWord + charOne + charTwo;
      /// Generate a hash of the word
      String wordHash = hash(word, email);
      /// Compare the word to the currentHash
      if (wordHash == currentHash) {
        /// return the two characters as a string
        return (charOne + charTwo);
      }
      /// Increment secondCounter
      j++;
    }
      /// Reset j (secondCounter) and increment firstCounter
    j = 0;
    i++;
  }
  return ""; /// Return empty string
}