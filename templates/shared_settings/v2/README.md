# Shared Settings Template v2

This template is derived from the current M_HaydiNamaza settings pattern and adapted for the RekatSay shared-app standard.

## Standard sections

1. Hakkımızda
2. Uygulama Bilgileri ve Güncelleme
3. Uygulamalarımız
4. Destek Olabilirsiniz

## App identity convention

- `app_id`: lowercase ASCII, no spaces. Example: `rekatsay`.
- Display name: product name exactly as shown to users. Example: `RekatSay`.
- Do not use legacy `RekatSayar`, `Rekat Sayar`, or `rekat_sayar` for new shared settings data.

## Other apps catalog category values

Use one of these values in `app_catalog.json`:

- `mobile`
- `desktop`
- `web`

The mobile app renders the categories in this order: Mobile, Desktop, Web.

## Integration notes

- Copy the files under `lib/` into the target Flutter app.
- Copy `assets/data/shared_settings/` into the target Flutter app.
- Add this to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/data/shared_settings/
```

- Target app must already have `url_launcher`, `http`, `package_info_plus`, and `shared_preferences` if the full settings set is used.

