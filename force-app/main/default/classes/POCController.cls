public class POCController {
    
    // Simple POC method to demonstrate basic functionality
    public static String getPOCMessage() {
        return 'POC Controller is working!';
    }
    
    // Method to get system timestamp
    public static DateTime getCurrentTimestamp() {
        return DateTime.now();
    }
    
    // Method to validate string
    public static Boolean validateString(String input) {
        return String.isNotBlank(input) && input.length() > 0;
    }
}