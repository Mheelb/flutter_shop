import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/auth/data/models/user_model.dart';
import 'package:flutter_shop/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel Tests', () {
    const testUserModel = UserModel(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      isEmailVerified: true,
      createdAt: '2023-01-01T00:00:00Z',
    );

    const testUserModelMinimal = UserModel(
      id: '456',
      email: 'minimal@example.com',
      name: 'Minimal User',
      isEmailVerified: false,
    );

    group('Model Creation', () {
      test('should create UserModel with all fields', () {
        expect(testUserModel.id, '123');
        expect(testUserModel.email, 'test@example.com');
        expect(testUserModel.name, 'Test User');
        expect(testUserModel.isEmailVerified, true);
        expect(testUserModel.createdAt, '2023-01-01T00:00:00Z');
      });

      test('should create UserModel with minimal fields', () {
        expect(testUserModelMinimal.id, '456');
        expect(testUserModelMinimal.email, 'minimal@example.com');
        expect(testUserModelMinimal.name, 'Minimal User');
        expect(testUserModelMinimal.isEmailVerified, false);
        expect(testUserModelMinimal.createdAt, isNull);
      });

      test('should create UserModel with different verification status', () {
        const unverifiedUser = UserModel(
          id: '789',
          email: 'unverified@example.com',
          name: 'Unverified User',
          isEmailVerified: false,
        );

        expect(unverifiedUser.isEmailVerified, false);
      });
    });

    group('JSON Serialization', () {
      test('fromJson should create UserModel from JSON', () {
        final json = {
          'id': '123',
          'email': 'test@example.com',
          'name': 'Test User',
          'isEmailVerified': true,
          'createdAt': '2023-01-01T00:00:00Z',
        };

        final userModel = UserModel.fromJson(json);

        expect(userModel.id, '123');
        expect(userModel.email, 'test@example.com');
        expect(userModel.name, 'Test User');
        expect(userModel.isEmailVerified, true);
        expect(userModel.createdAt, '2023-01-01T00:00:00Z');
      });

      test('fromJson should handle missing optional fields', () {
        final json = {
          'id': '456',
          'email': 'minimal@example.com',
          'name': 'Minimal User',
          'isEmailVerified': false,
        };

        final userModel = UserModel.fromJson(json);

        expect(userModel.id, '456');
        expect(userModel.email, 'minimal@example.com');
        expect(userModel.name, 'Minimal User');
        expect(userModel.isEmailVerified, false);
        expect(userModel.createdAt, isNull);
      });

      test('toJson should convert UserModel to JSON', () {
        final json = testUserModel.toJson();

        expect(json['id'], '123');
        expect(json['email'], 'test@example.com');
        expect(json['name'], 'Test User');
        expect(json['isEmailVerified'], true);
        expect(json['createdAt'], '2023-01-01T00:00:00Z');
      });

      test('toJson should handle null createdAt', () {
        final json = testUserModelMinimal.toJson();

        expect(json['id'], '456');
        expect(json['email'], 'minimal@example.com');
        expect(json['name'], 'Minimal User');
        expect(json['isEmailVerified'], false);
        expect(json.containsKey('createdAt'), true);
        expect(json['createdAt'], isNull);
      });

      test('should handle round trip serialization', () {
        final json = testUserModel.toJson();
        final recreatedUserModel = UserModel.fromJson(json);

        expect(recreatedUserModel.id, testUserModel.id);
        expect(recreatedUserModel.email, testUserModel.email);
        expect(recreatedUserModel.name, testUserModel.name);
        expect(
            recreatedUserModel.isEmailVerified, testUserModel.isEmailVerified);
        expect(recreatedUserModel.createdAt, testUserModel.createdAt);
      });
    });

    group('Entity Conversion', () {
      test('toEntity should convert UserModel to User entity', () {
        final userEntity = testUserModel.toEntity();

        expect(userEntity, isA<User>());
        expect(userEntity.id, testUserModel.id);
        expect(userEntity.email, testUserModel.email);
        expect(userEntity.name, testUserModel.name);
        expect(userEntity.isEmailVerified, testUserModel.isEmailVerified);
      });

      test('toEntity should handle minimal user model', () {
        final userEntity = testUserModelMinimal.toEntity();

        expect(userEntity, isA<User>());
        expect(userEntity.id, testUserModelMinimal.id);
        expect(userEntity.email, testUserModelMinimal.email);
        expect(userEntity.name, testUserModelMinimal.name);
        expect(
            userEntity.isEmailVerified, testUserModelMinimal.isEmailVerified);
      });

      test('fromEntity should convert User entity to UserModel', () {
        final userEntity = User(
          id: '999',
          email: 'entity@example.com',
          name: 'Entity User',
          isEmailVerified: true,
        );

        final userModel = UserModel.fromEntity(userEntity);

        expect(userModel.id, userEntity.id);
        expect(userModel.email, userEntity.email);
        expect(userModel.name, userEntity.name);
        expect(userModel.isEmailVerified, userEntity.isEmailVerified);
        expect(userModel.createdAt,
            isNull); // Should be null when converting from entity
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties are same', () {
        const user1 = UserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: '2023-01-01T00:00:00Z',
        );

        const user2 = UserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: '2023-01-01T00:00:00Z',
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when id differs', () {
        const user1 = UserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );

        const user2 = UserModel(
          id: '456',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );

        expect(user1, isNot(equals(user2)));
        expect(user1.hashCode, isNot(equals(user2.hashCode)));
      });

      test('should not be equal when email differs', () {
        const user1 = UserModel(
          id: '123',
          email: 'test1@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );

        const user2 = UserModel(
          id: '123',
          email: 'test2@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when verification status differs', () {
        const user1 = UserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
        );

        const user2 = UserModel(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: false,
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('CopyWith Method', () {
      test('copyWith should create new instance with updated fields', () {
        final updatedUser = testUserModel.copyWith(
          name: 'Updated Name',
          isEmailVerified: false,
        );

        expect(updatedUser.id, testUserModel.id);
        expect(updatedUser.email, testUserModel.email);
        expect(updatedUser.name, 'Updated Name');
        expect(updatedUser.isEmailVerified, false);
        expect(updatedUser.createdAt, testUserModel.createdAt);
      });

      test('copyWith should handle partial updates', () {
        final updatedUser = testUserModel.copyWith(email: 'new@example.com');

        expect(updatedUser.id, testUserModel.id);
        expect(updatedUser.email, 'new@example.com');
        expect(updatedUser.name, testUserModel.name);
        expect(updatedUser.isEmailVerified, testUserModel.isEmailVerified);
        expect(updatedUser.createdAt, testUserModel.createdAt);
      });

      test('copyWith without parameters should create identical copy', () {
        final copiedUser = testUserModel.copyWith();

        expect(copiedUser, equals(testUserModel));
        expect(copiedUser.hashCode, equals(testUserModel.hashCode));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle empty strings', () {
        const userWithEmptyStrings = UserModel(
          id: '',
          email: '',
          name: '',
          isEmailVerified: false,
        );

        expect(userWithEmptyStrings.id, '');
        expect(userWithEmptyStrings.email, '');
        expect(userWithEmptyStrings.name, '');
        expect(userWithEmptyStrings.isEmailVerified, false);
      });

      test('should handle special characters in fields', () {
        const userWithSpecialChars = UserModel(
          id: '特殊字符-123',
          email: 'user+test@example-domain.co.uk',
          name: 'José María O\'Connor-Smith',
          isEmailVerified: true,
        );

        expect(userWithSpecialChars.id, '特殊字符-123');
        expect(userWithSpecialChars.email, 'user+test@example-domain.co.uk');
        expect(userWithSpecialChars.name, 'José María O\'Connor-Smith');
      });

      test('should handle very long strings', () {
        final longString = 'a' * 1000;
        final userWithLongStrings = UserModel(
          id: longString,
          email: '${longString}@example.com',
          name: longString,
          isEmailVerified: true,
        );

        expect(userWithLongStrings.id.length, 1000);
        expect(userWithLongStrings.name.length, 1000);
      });
    });

    group('Stress Testing', () {
      test('should handle many serialization operations', () {
        for (int i = 0; i < 1000; i++) {
          final user = UserModel(
            id: 'user_$i',
            email: 'user$i@example.com',
            name: 'User $i',
            isEmailVerified: i % 2 == 0,
            createdAt:
                '2023-01-${(i % 28 + 1).toString().padLeft(2, '0')}T00:00:00Z',
          );

          final json = user.toJson();
          final recreated = UserModel.fromJson(json);

          expect(recreated.id, user.id);
          expect(recreated.email, user.email);
          expect(recreated.name, user.name);
          expect(recreated.isEmailVerified, user.isEmailVerified);
          expect(recreated.createdAt, user.createdAt);
        }
      });
    });
  });
}
