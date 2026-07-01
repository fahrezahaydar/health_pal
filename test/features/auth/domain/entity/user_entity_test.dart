// C22
import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
void main() {
  group('UserEntity', () {
    test('Equatable props match constructor params', () {
      const a = UserEntity(id: '1', authId: 'a', fullName: 'T', email: 'e@e.com');
      const b = UserEntity(id: '1', authId: 'a', fullName: 'T', email: 'e@e.com');
      expect(a, b);
      expect(a.props.length, 10);
    });
    test('copyWith modifies specified fields', () {
      const e = UserEntity(id: '1', authId: 'a', fullName: 'Old', email: 'o@o.com');
      expect(e.copyWith(fullName: 'New').fullName, 'New');
      expect(e.copyWith().fullName, 'Old');
    });
    test('mock() creates non-null entity', () {
      expect(UserEntity.mock().id, isNotEmpty);
    });
  });
}
