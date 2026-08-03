/**
 * ContactValidator
 * Validates Contact object fields according to Salesforce requirements.
 * Provides validation for FirstName, LastName, Email, Phone, and AccountId.
 */
public class ContactValidator {
	
	/**
	 * Custom exception for validation errors
	 */
	public class ValidationException extends Exception {}

	private static final Integer FIRSTNAME_MAX_LENGTH = 40;
	private static final Integer LASTNAME_MAX_LENGTH = 80;
	private static final String EMAIL_PATTERN = '^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';
	private static final String PHONE_PATTERN = '^[\\d\\s()\\-+.]{10,}$';

	/**
	 * Validates a Contact record and returns validation result
	 * @param contact The Contact record to validate
	 * @return ValidationResult object containing validation status and errors
	 */
	public static ValidationResult validate(Contact contact) {
		ValidationResult result = new ValidationResult();

		if (contact == null) {
			result.addError('Contact object cannot be null');
			return result;
		}

		validateFirstName(contact.FirstName, result);
		validateLastName(contact.LastName, result);
		validateEmail(contact.Email, result);
		validatePhone(contact.Phone, result);
		validateAccountId(contact.AccountId, result);

		return result;
	}

	/**
	 * Validates FirstName field
	 * @param firstName The FirstName value to validate
	 * @param result ValidationResult to collect errors
	 */
	private static void validateFirstName(String firstName, ValidationResult result) {
		if (firstName == null || firstName.isBlank()) {
			result.addError('First Name is required');
			return;
		}

		if (firstName.length() > FIRSTNAME_MAX_LENGTH) {
			result.addError(
				'First Name must not exceed ' + FIRSTNAME_MAX_LENGTH + ' characters'
			);
		}
	}

	/**
	 * Validates LastName field
	 * @param lastName The LastName value to validate
	 * @param result ValidationResult to collect errors
	 */
	private static void validateLastName(String lastName, ValidationResult result) {
		if (lastName == null || lastName.isBlank()) {
			result.addError('Last Name is required');
			return;
		}

		if (lastName.length() > LASTNAME_MAX_LENGTH) {
			result.addError(
				'Last Name must not exceed ' + LASTNAME_MAX_LENGTH + ' characters'
			);
		}
	}

	/**
	 * Validates Email field format
	 * @param email The Email value to validate
	 * @param result ValidationResult to collect errors
	 */
	private static void validateEmail(String email, ValidationResult result) {
		if (email == null || email.isBlank()) {
			return;
		}

		Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
		Matcher emailMatcher = emailPattern.matcher(email);

		if (!emailMatcher.matches()) {
			result.addError('Email must be in a valid format (e.g., user@example.com)');
		}
	}

	/**
	 * Validates Phone field format
	 * @param phone The Phone value to validate
	 * @param result ValidationResult to collect errors
	 */
	private static void validatePhone(String phone, ValidationResult result) {
		if (phone == null || phone.isBlank()) {
			return;
		}

		Pattern phonePattern = Pattern.compile(PHONE_PATTERN);
		Matcher phoneMatcher = phonePattern.matcher(phone);

		if (!phoneMatcher.matches()) {
			result.addError('Phone must contain at least 10 digits');
		}
	}

	/**
	 * Validates AccountId exists if provided
	 * @param accountId The AccountId value to validate
	 * @param result ValidationResult to collect errors
	 */
	private static void validateAccountId(Id accountId, ValidationResult result) {
		if (accountId == null) {
			return;
		}

		List<Account> accounts = [
			SELECT Id
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		if (accounts.isEmpty()) {
			result.addError('Account ID does not exist');
		}
	}

	/**
	 * Inner class to hold validation results
	 */
	public class ValidationResult {
		private List<String> errors;
		private Boolean isValid;

		public ValidationResult() {
			this.errors = new List<String>();
			this.isValid = true;
		}

		public void addError(String error) {
			if (error.isNotBlank()) {
				this.errors.add(error);
				this.isValid = false;
			}
		}

		public Boolean getIsValid() {
			return this.isValid;
		}

		public List<String> getErrors() {
			return new List<String>(this.errors);
		}

		public String getErrorsAsString() {
			return String.join(this.errors, '; ');
		}
	}
}