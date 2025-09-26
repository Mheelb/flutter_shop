import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/email_validator.dart';

void main() {
  group('EmailValidator', () {
    group('isValid', () {
      test('should return true for valid emails', () {
        expect(EmailValidator.isValid('test@example.com'), true);
        expect(EmailValidator.isValid('user.name@domain.co.uk'), true);
        expect(EmailValidator.isValid('user+tag@example.org'), true);
        expect(EmailValidator.isValid('user123@test.io'), true);
      });

      test('should return false for invalid emails', () {
        expect(EmailValidator.isValid(''), false);
        expect(EmailValidator.isValid('invalid-email'), false);
        expect(EmailValidator.isValid('user@'), false);
        expect(EmailValidator.isValid('@domain.com'), false);
        expect(EmailValidator.isValid('user@domain'), false);
        expect(EmailValidator.isValid('user@domain.'), false);
      });
    });

    group('validate', () {
      test('should return null for valid emails', () {
        expect(EmailValidator.validate('test@example.com'), null);
        expect(EmailValidator.validate('valid@email.org'), null);
      });

      test('should return error message for null email', () {
        expect(EmailValidator.validate(null), 'Email is required');
      });

      test('should return error message for empty email', () {
        expect(EmailValidator.validate(''), 'Email is required');
      });

      test('should return error message for invalid emails', () {
        expect(
            EmailValidator.validate('invalid'), 'Please enter a valid email');
        expect(EmailValidator.validate('user@'), 'Please enter a valid email');
      });
    });
  });
}
