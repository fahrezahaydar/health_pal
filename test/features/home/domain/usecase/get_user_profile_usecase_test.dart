import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:health_pal/core/network/result.dart";
import "package:health_pal/features/home/domain/repository/home_repository.dart";
import "package:health_pal/features/home/domain/entity/user_profile_entity.dart";
import "package:health_pal/features/home/domain/usecase/get_user_profile_usecase.dart";
class _M extends Mock implements HomeRepository {}
void main() {
  test("delegates", () async {
    final r = _M(); final u = GetUserProfileUseCase(r);
    when(() => r.getUserProfile(any())).thenAnswer((_) async => const Success(UserProfileEntity(id: "p", nickname: "T")));
    expect(await u("aid"), isA<Success<UserProfileEntity>>());
  });
}
