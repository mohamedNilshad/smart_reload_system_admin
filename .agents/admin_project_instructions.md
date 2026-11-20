# Admin Desktop Project Agent Instructions

Use this file in a fresh Flutter desktop admin project. Follow these rules exactly.

## 1) Architecture protocol

- Use **Clean Architecture + BLoC + get_it**.
- Layer flow must always be:
  - `presentation -> domain/usecase -> domain/repository (interface) -> data/repository (impl) -> data/datasource`
- UI/widgets must never call Firebase/API/database directly.
- Repositories return `Either<Failure, T>` (dartz).
- Datasources throw typed exceptions; repository maps to failures.

## 2) Required package stack

- `flutter_bloc`
- `get_it`
- `equatable`
- `dartz`
- `json_annotation`
- `json_serializable`
- `build_runner`

If backend is Firebase, also add:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_database` (only if needed)
- `flutter_secure_storage` (for local secure persistence)

## 3) Project structure (keep same style)

Use this structure and naming style:

```text
lib/
  main.dart
  src/
    app.dart
    injection_container.dart
    core/
      bloc/
      constants/
      domain/
      error/
      presentation/
        widgets/
        screens/
        popups/
        snack_bars/
      router/
      theme/
      usecase/
      utils/
        helpers/
    feature/
      admin/
        <feature_name>/
          data/
            datasource/
            model/            # only when data shape differs from domain entity
            repository/
          domain/
            entity/
            repository/
            usecase/
          presentation/
            bloc/
            screens/
            widgets/
```

## 4) File naming convention (must follow)

Use dot-based names exactly:

- Entity: `user.entity.dart`
- Entity generated: `user.entity.g.dart`
- Repo interface: `auth.repo.dart`
- Repo impl: `auth.repo_impl.dart`
- Datasource: `auth.remote_datasource.dart` / `auth.local_datasource.dart`
- Usecase: `login.usecase.dart`
- Bloc files: `auth.event.dart`, `auth.state.dart`, `auth.bloc.dart`
- Screen: `login.screen.dart`

Use absolute package imports only (no relative imports):
- `package:<project_name>/...`

## 5) Shared reusable core files (keep same names)

Keep these common files in the new admin project with the same names:

- `lib/src/core/constants/app_colors.dart`
- `lib/src/core/constants/app_strings.dart`
- `lib/src/core/constants/sizes.dart`
- `lib/src/core/constants/image_strings.dart`
- `lib/src/core/constants/svg_strings.dart`
- `lib/src/core/constants/font_strings.dart`
- `lib/src/core/constants/app_data.dart`
- `lib/src/core/constants/constant.dart`
- `lib/src/core/utils/helpers/helper_functions.dart`

Additional existing reusable utils naming style to keep:
- `lib/src/core/utils/money.util.dart`
- `lib/src/core/utils/report_format.util.dart`

## 6) Strict helper and constants rules

- All non-UI helper methods go inside:
  - `HelperFunctions` class in `core/utils/helpers/helper_functions.dart`
- Do not create random standalone helper functions in multiple files.
- All color constants must be in:
  - `core/constants/app_colors.dart`
- All static app labels must be in:
  - `core/constants/app_strings.dart`
- Use `Sizes` from:
  - `core/constants/sizes.dart`

## 7) Dependency injection rules

- Register dependencies in `lib/src/injection_container.dart`.
- Use `GetIt` instance named `sl`.
- Register data sources, repositories, usecases, services with `registerLazySingleton`.
- Register feature blocs in DI and provide them in root `MultiBlocProvider` in `app.dart`.
- Prefer app-level bloc provisioning unless a feature requires strict route scoping.

## 8) Feature implementation checklist

For every new admin feature, create in this order:

1. `domain/entity/*.entity.dart` (+ run build_runner)
2. `domain/repository/*.repo.dart`
3. `domain/usecase/*.usecase.dart`
4. `data/datasource/*_datasource.dart`
5. `data/repository/*.repo_impl.dart`
6. `presentation/bloc/*.event.dart`
7. `presentation/bloc/*.state.dart`
8. `presentation/bloc/*.bloc.dart`
9. `presentation/screens/*.screen.dart`
10. Register all in `injection_container.dart`
11. Add bloc provider in root `app.dart`

## 9) JSON entity generation rule

- Entities are annotated with `@JsonSerializable()`.
- Add `part '<name>.entity.g.dart';`
- Never edit generated `.g.dart` manually.

Command:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 10) Error handling contract

- Datasource catches external SDK errors and throws project exceptions.
- Repository catches exceptions and returns `Left(Failure)`.
- Usecase delegates to repository.
- Bloc maps result to states using `.fold(...)`.
- UI reacts to bloc state only.

## 11) Hard rules

- No direct Firebase/API calls from widget or bloc.
- No business logic in UI layer.
- No relative imports.
- No scattered color/string/helper constants outside core files above.
- No hand-edited generated files.

## 12) Startup commands

```bash
flutter pub get
dart run build_runner watch --delete-conflicting-outputs
flutter run -d windows
flutter test
```

## 13) Security note for copied constants

- If `core/constants/constant.dart` contains secrets (merchant keys, service URLs), do **not** commit real secrets.
- Move secrets to secure config (`--dart-define`, env files, CI secrets, or backend-managed values).

