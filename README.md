# CTI Android Application

CTI is an Android application that displays caller information on the screen by fetching data from a CRM system through an API. The app recognizes the phone number of the caller and searches for related details in the CRM.

You can easily customize the data-fetching function to fit your own CRM by modifying a single method in the code.

The app uses the **Phone State** library for smooth call handling and includes a call transfer feature. If you transfer a call but don’t have a direct transfer option, you can press the transfer button to send an SMS to the desired employee’s number with the caller’s info. (Note: SMS sending code is not included in this version due to restrictions in Yemen.)

---

## ⚙️ Features

- Display caller information by searching the CRM via phone number.
- Easily customizable data-fetching function to integrate any CRM.
- Call transfer feature with fallback SMS notification.
- Beautiful, user-friendly interfaces with smooth interaction.
- Note: The app does **not** support all Android versions.

---

## 💾 SQLite for Offline Access

To optimize performance and reduce repeated API calls, CTI uses SQLite to locally store caller data. This allows the app to access stored caller information quickly without querying the API every time.

---

## 🔧 Built With

- Flutter
- Dart
- Phone State plugin
- SQLite for local storage
- HTTP package for API communication

---

## 📦 How to Customize the Data Fetching

You can modify the function responsible for fetching customer data from your CRM by editing the method below.

Replace the URL and API keys with your own CRM endpoint and credentials.

```dart
Future<Map<String, dynamic>> fetchCustomerInfo(String phoneNumber) async {
  final url = Uri.parse(
    "https://your-crm-api-endpoint.com/api/contacts?phoneNumber=eq.$phoneNumber",
  );

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'apikey': 'YOUR_API_KEY_HERE',
      'Authorization': 'Bearer YOUR_AUTH_TOKEN_HERE',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is List && data.isNotEmpty) {
      final customerMap = data[0] as Map<String, dynamic>;

      // Store data asynchronously in SQLite database for offline access
      _storeInDatabaseAsync(customerMap);

      return customerMap;
    } else {
      throw Exception("No customer data found");
    }
  } else {
    throw Exception("Failed to fetch data: ${response.body}");
  }
}
Where to edit:
lib\services\castomer_services.dart
Replace "https://your-crm-api-endpoint.com/api/contacts?phoneNumber=eq.\$phoneNumber" with your CRM API URL.

Replace 'YOUR_API_KEY_HERE' and 'YOUR_AUTH_TOKEN_HERE' with your own authentication credentials.

