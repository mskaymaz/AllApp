# Codex Besmele Sablonu

Bu dokuman, yeni bir mobil uygulama reposunda ayni acilis davranisini hizlica kurmak icindir.

## 1) Root `AGENTS.md`

Yeni repoda kok dizine `AGENTS.md` olustur ve su icerigi kullan:

```md
# AGENTS.md

Repo: <REPO_ADI>

This root file only defines bootstrap behavior.

- Highest-priority runtime policy: if the user triggers `bismillah`, `ekonomik token`, or `eko`, enable strict economic-token mode first.
- Treat economic-token mode as a pre-identity runtime prefix: apply it before interpretation, planning, file reads, tool calls, edits, validation, and final output.
- While active, it overrides every lower-priority workflow preference unless the user explicitly disables it.
- Runtime meaning: requested scope only, minimum relevant files, terse default output, and no unnecessary explanation.
- Required opening line: `Bismillah, Baglama alindi, calismaya hazirim.`
- `bismillah` bootstrap order:
  1. root `CORE.md` and `STATE.md`
  2. `core/BISMILLAH.md` and `core/BOOT.md`
  3. `core/CORE.md`, `rules/RULES.md`, `flows/FLOW.md`
  4. canonical project instructions under `besmele/CORE/`, `besmele/RULES/`, `besmele/PROJECTS/`, plus `besmele/chatKomut.md`
- If planning/session continuity is needed, activate `plans/PLAN.md` and `sessions/SESSION.md`.
- Repo-specific records and task management remain under `besmele/`.
- The canonical Codex instruction source is the new folder-based Besmele structure, not legacy duplicated markdown files.
- This repo targets a mobile application; the default stack assumption is Flutter unless the task clearly requires otherwise.
```

## 2) Klasor iskeleti

Yeni repoda su klasorleri olustur:

```text
besmele/
  CORE/
  RULES/
  PROJECTS/<uygulama_adi>/
  chatKomut.md
  CORE.md
  STATE.md
core/
  BISMILLAH.md
  BOOT.md
  CORE.md
rules/
  RULES.md
flows/
  FLOW.md
plans/
  PLAN.md
sessions/
  SESSION.md
```

## 3) Hizli kullanim

- Sohbete `bismillah` veya `eko` ile basla.
- Beklenen acilis satiri:
  - `Bismillah, Baglama alindi, calismaya hazirim.`
- Bu satirla birlikte ekonomik token modu devreye girer.

## 4) Not

Bu sablonu tum uygulamalarda ayni sekilde kullanabilir, sadece `Repo:` adini ve `besmele/PROJECTS/<uygulama_adi>/` iceriklerini uygulamaya gore degistirebilirsin.
