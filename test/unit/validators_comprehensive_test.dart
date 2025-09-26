import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/validators.dart';

void main() {
  group('Validators Comprehensive Tests', () {
    group('Email Validation', () {
      test('isValidEmail should accept valid emails', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'firstname+lastname@company.org',
          'user123@test-domain.com',
          'simple@example.net',
          'very.long.email.address@very.long.domain.example.com',
          'user+tag@example.com',
          'test.email-with+symbol@domain.com'
        ];

        for (final email in validEmails) {
          expect(Validators.isValidEmail(email), true,
              reason: 'Email "$email" should be valid');
        }
      });

      test('isValidEmail should reject invalid emails', () {
        final invalidEmails = [
          '',
          'invalid-email',
          'missing@domain',
          '@domain.com',
          'user@',
          'user..double.dot@example.com',
          'user @example.com', // space before @
          'user@exam ple.com', // space in domain
          '.user@example.com', // starts with dot
          'user.@example.com', // ends with dot
          'user@.example.com', // domain starts with dot
          'user@example..com', // double dot in domain
          'user@example.c', // domain too short
          'user@',
          'plainaddress',
          '@missingusername.com',
          'username@.com',
          'username@com',
          'username..double.dot@example.com'
        ];

        for (final email in invalidEmails) {
          expect(Validators.isValidEmail(email), false,
              reason: 'Email "$email" should be invalid');
        }
      });

      test('isValidEmail should handle edge cases', () {
        expect(Validators.isValidEmail('a@b.co'), true); // minimum valid
        expect(
            Validators.isValidEmail('test@sub.domain.com'), true); // subdomain
        expect(Validators.isValidEmail('user@domain-with-dash.com'),
            true); // dash in domain
      });
    });

    group('Password Validation', () {
      test('isValidPassword should accept strong passwords', () {
        final strongPasswords = [
          'MyStr0ng!Pass',
          'C0mplex#Password123',
          'Secure@2023!',
          'P@ssw0rd!123',
          'Strong#Pass1',
          'MyP@ssw0rd2023',
          'C0mpl3x!P@ss',
          'Str0ng#Passw0rd!'
        ];

        for (final password in strongPasswords) {
          expect(Validators.isValidPassword(password), true,
              reason: 'Password "$password" should be valid');
        }
      });

      test('isValidPassword should reject weak passwords', () {
        final weakPasswords = [
          '', // empty
          'short', // too short
          '1234567', // only numbers, too short
          'password', // only lowercase
          'PASSWORD', // only uppercase
          'Password', // missing number and special char
          'Password1', // missing special char
          'Password!', // missing number
          '12345678', // only numbers
          '!@#\$%^&*', // only special chars
          'pass', // too short
          'Pass1', // too short with valid chars
          'longpasswordwithoutuppercase123!', // no uppercase
          'LONGPASSWORDWITHOUTLOWERCASE123!', // no lowercase
          'LongPasswordWithoutNumbers!', // no numbers
          'LongPasswordWithoutSpecialChars1' // no special chars
        ];

        for (final password in weakPasswords) {
          expect(Validators.isValidPassword(password), false,
              reason: 'Password "$password" should be invalid');
        }
      });

      test('isValidPassword should handle minimum requirements', () {
        // Exactly 8 characters with all requirements
        expect(Validators.isValidPassword('Pass123!'), true);
        // 7 characters - should fail
        expect(Validators.isValidPassword('Pass12!'), false);
      });
    });

    group('Phone Number Validation', () {
      test('isValidPhoneNumber should accept valid formats', () {
        final validPhones = [
          '+33123456789', // international format
          '0123456789', // national format
          '+1234567890123', // long international
          '+49123456789', // German format
          '+44123456789', // UK format
          '0612345678', // mobile format
          '0123456789', // landline format
          '+33612345678', // mobile international
          '01 23 45 67 89', // with spaces
          '01.23.45.67.89', // with dots
          '01-23-45-67-89' // with dashes
        ];

        for (final phone in validPhones) {
          expect(Validators.isValidPhoneNumber(phone), true,
              reason: 'Phone "$phone" should be valid');
        }
      });

      test('isValidPhoneNumber should reject invalid formats', () {
        final invalidPhones = [
          '', // empty
          '123', // too short
          'abcdefghij', // letters
          '++33123456789', // double plus
          '012345', // too short
          '012345678901234567890', // too long
          '+', // only plus
          '0', // single digit
          'phone number', // text
          '123-abc-4567', // mixed letters and numbers
          '   ', // only spaces
          '+33 ', // incomplete international
          '0123456789012345', // too long national
          '++123456789' // invalid international prefix
        ];

        for (final phone in invalidPhones) {
          expect(Validators.isValidPhoneNumber(phone), false,
              reason: 'Phone "$phone" should be invalid');
        }
      });

      test('isValidPhoneNumber should handle edge cases', () {
        expect(Validators.isValidPhoneNumber('+1234567890'),
            true); // minimum international
        expect(Validators.isValidPhoneNumber('1234567890'),
            true); // minimum national
      });
    });

    group('Name Validation', () {
      test('isValidName should accept valid names', () {
        final validNames = [
          'John',
          'Jean-Pierre',
          'Mary Jane',
          'O\'Connor',
          'Van Der Berg',
          'José',
          'François',
          'Al-Rahman',
          'St. John',
          'McGregor',
          'von Neumann',
          'da Silva',
          'Jean Baptiste',
          'Anne-Marie',
          'Two Words'
        ];

        for (final name in validNames) {
          expect(Validators.isValidName(name), true,
              reason: 'Name "$name" should be valid');
        }
      });

      test('isValidName should reject invalid names', () {
        final invalidNames = [
          '', // empty
          '   ', // only spaces
          'John123', // contains numbers
          'John@Doe', // contains symbols
          'J', // too short
          'A', // single letter
          '123', // only numbers
          '@#\$%', // only symbols
          'John  Doe', // double space
          ' John', // starts with space
          'John ', // ends with space
          'john doe with very long name that exceeds reasonable limits for a person name and should be rejected by validation' // too long
        ];

        for (final name in invalidNames) {
          expect(Validators.isValidName(name), false,
              reason: 'Name "$name" should be invalid');
        }
      });

      test('isValidName should handle accented characters', () {
        final accentedNames = [
          'José',
          'François',
          'Björn',
          'Müller',
          'Håkan',
          'Søren',
          'Włodek',
          'Château'
        ];

        for (final name in accentedNames) {
          expect(Validators.isValidName(name), true,
              reason: 'Accented name "$name" should be valid');
        }
      });
    });

    group('General String Validation', () {
      test('isNotEmpty should validate correctly', () {
        expect(Validators.isNotEmpty('text'), true);
        expect(Validators.isNotEmpty('a'), true);
        expect(Validators.isNotEmpty(' '), true); // space counts as not empty
        expect(Validators.isNotEmpty(''), false);
      });

      test('hasMinLength should validate correctly', () {
        expect(Validators.hasMinLength('hello', 3), true);
        expect(Validators.hasMinLength('hello', 5), true);
        expect(Validators.hasMinLength('hello', 6), false);
        expect(Validators.hasMinLength('', 1), false);
        expect(Validators.hasMinLength('a', 1), true);
      });

      test('hasMaxLength should validate correctly', () {
        expect(Validators.hasMaxLength('hello', 10), true);
        expect(Validators.hasMaxLength('hello', 5), true);
        expect(Validators.hasMaxLength('hello', 4), false);
        expect(Validators.hasMaxLength('', 0), true);
        expect(Validators.hasMaxLength('', 5), true);
      });
    });

    group('Comprehensive Validation Tests', () {
      test('should validate multiple inputs simultaneously', () {
        final testCases = [
          {
            'email': 'user@example.com',
            'password': 'MyStr0ng!Pass',
            'phone': '+33123456789',
            'name': 'John Doe',
            'allValid': true
          },
          {
            'email': 'invalid-email',
            'password': 'weak',
            'phone': '123',
            'name': '',
            'allValid': false
          },
          {
            'email': 'test@domain.com',
            'password': 'StrongP@ss1',
            'phone': '0123456789',
            'name': 'Valid Name',
            'allValid': true
          }
        ];

        for (final testCase in testCases) {
          final emailValid =
              Validators.isValidEmail(testCase['email'] as String);
          final passwordValid =
              Validators.isValidPassword(testCase['password'] as String);
          final phoneValid =
              Validators.isValidPhoneNumber(testCase['phone'] as String);
          final nameValid = Validators.isValidName(testCase['name'] as String);

          final allValid =
              emailValid && passwordValid && phoneValid && nameValid;
          expect(allValid, testCase['allValid'],
              reason: 'Test case validation should match expected result');
        }
      });

      test('should handle basic validation combinations', () {
        // Test basic validation combinations
        const testData = [
          {
            'email': 'user@example.com',
            'password': 'StrongPass123!',
            'phone': '+33123456789',
            'name': 'Valid User',
          },
          {
            'email': 'test@domain.org',
            'password': 'SecureP@ss1',
            'phone': '0123456789',
            'name': 'Test Person',
          },
        ];

        for (final data in testData) {
          expect(Validators.isValidEmail(data['email']!), true);
          expect(Validators.isValidPassword(data['password']!), true);
          expect(Validators.isValidPhoneNumber(data['phone']!), true);
          expect(Validators.isValidName(data['name']!), true);
        }
      });
    });
  });
}
