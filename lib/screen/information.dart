class Information {
  String? name;
  String? dob;
  String? gender;
  String? phoneNo;

  Information({
    this.name,
    this.dob,
    this.gender,
    this.phoneNo,
  });

  @override
  String toString() {
    return '{name: $name, dob: $dob, gender: $gender, phoneNo: $phoneNo}';
  }

  Information parseInformation(String input) {
    try {
      // Remove curly braces and spaces
      input = input.replaceAll('{', '').replaceAll('}', '');

      // Split the string into key-value pairs
      List<String> pairs = input.split(',');

      // Initialize an Information object
      Information information = Information();

      // Iterate through the key-value pairs
      for (String pair in pairs) {
        // Split each pair into key and value
        List<String> keyValue = pair.split(':');

        // Remove leading and trailing whitespaces
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();

        // Assign the value to the corresponding field in Information
        switch (key) {
          case 'name':
            information.name = value;
            break;
          case 'dob':
            information.dob = value;
            break;
          case 'gender':
            information.gender = value;
            break;
          case 'phoneNo':
            information.phoneNo = value;
            break;
          default:
            // Handle unexpected keys, if needed
            break;
        }
      }

      return information;
    } catch (e) {
      // Handle the exception, e.g., log it or return a default Information object
      print("Error parsing information: $e");
      return Information();
    }
  }
}
