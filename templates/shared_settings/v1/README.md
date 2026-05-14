# AllApp Shared Settings Template v1

This template converts TASK-07 settings modules into reusable contracts for mobile apps.

## Scope
- Bize Ulasin
- Uygulama Bilgileri ve Guncelleme
- Diger Uygulamalarimiz
- Destek Olabilirsiniz
- Biz Kimiz

## Configurable app values
Define these in app config (see `examples/shared_settings.app.sample.json`):
- `app_name`
- `app_id`
- `package_name`
- `admin_name`
- `support/contact texts`
- `update/release links`
- `other apps links`
- `donation/support text`
- `about/who-we-are text`

## Contracts
- `schemas/app_settings.schema.json`
- `schemas/app_catalog.schema.json`
- `schemas/update_manifest.schema.json`
- `schemas/support_contact.schema.json`
- `schemas/about.schema.json`

## About image asset
- Template image file: `assets/about/M_BizKimiz.jpg`
- App config field: `about.image_asset` (for Haydi Namaza: `img/M_BizKimiz.jpg`)

## Example payloads
- `examples/shared_settings.app.sample.json`
- `examples/app_catalog.sample.json`
- `examples/update_manifest.sample.json`

## Flutter copy guide
1. Create an app config object from `shared_settings.app.sample.json` fields.
2. Fetch remote app catalog/update manifest via HTTP.
3. Fallback to local asset JSON when remote fetch fails.
4. Render the 5 TASK-07 sections in Settings screen only.
5. Keep app-specific values in config, not in reusable UI modules.

This template is contract-oriented. It is not a hidden runtime dependency.


