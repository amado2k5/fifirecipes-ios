# FiFi Recipes — iOS

> [!WARNING]
> **This repository is being archived.** Its app code now lives in the
> universal iPhone + iPad app,
> [fifirecipes-ipadosapp](https://github.com/amado2k5/fifirecipes-ipadosapp)
> (bundle ID `cooking.fifi.ipados`), which ships the same iPhone tab-bar
> layout alongside the iPad sidebar from one binary. All fixes and features
> merged here (image loading, ingredient layout, translations, Telugu, CI
> annotations) are already in that repo, and its CI tests the iPhone layout
> on an iPhone 17 simulator. Open new issues and pull requests there.
> The `iosapp.fifi.cooking` site goes offline with this repo; support and
> privacy pages are at
> [ipadosapp.fifi.cooking](https://ipadosapp.fifi.cooking).

Native SwiftUI iPhone companion to [fifi.cooking](https://fifi.cooking), the
recipe site by Dr. Fatma / FiFi. Not a WebView wrapper: every screen is real
SwiftUI consuming the static JSON API at `https://fifi.cooking/data/` — the
same contract the Fire TV app uses (`docs/tv-api.md` in the `fifirecipes`
repo, reference client in `fifirecipes-amazonfire`).

- **Bundle ID:** `cooking.fifi.ios` · **Min iOS:** 17 · **Swift:** 6
- **Devices:** iPhone only (`TARGETED_DEVICE_FAMILY=1`; iPad runs it resized,
  and the layout adapts to future Duo/foldable iPhones via size classes)
- **Dependencies:** none — URLSession, AsyncImage, WebKit, Foundation only

## Build & test

```sh
# Build (simulator)
xcodebuild -project FifiRecipes.xcodeproj -scheme FifiRecipes \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build CODE_SIGNING_ALLOWED=NO

# Unit + UI tests
xcodebuild -project FifiRecipes.xcodeproj -scheme FifiRecipes \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test CODE_SIGNING_ALLOWED=NO
```

UI tests hit the live `fifi.cooking` API (the product is online-only).
Launch arguments supported for tests/screenshots:

| Arg | Effect |
|-----|--------|
| `-fifi.reset 1` | Clear persisted language → first-run picker |
| `-fifi.language ar` | Preselect a language |
| `-fifi.apiOrigin <url>` | Point the API elsewhere (offline test) |

## Architecture

```
FifiRecipes/
├── App/            @main App, RootView (phase router), AppState
│                   (manifest → picker → tabs; per-tab NavigationPath;
│                   Universal-Link routing)
├── API/            APIClient — actor; manifest-driven endpoint templates,
│                   ?v= versioned requests, in-flight + URLCache caching,
│                   kids English-fallback on 404; AssetURL resolver
├── Models/         Codable models mirroring src/api/types.ts
├── Localization/   Strings (24 languages from bundled ui-strings.json,
│                   allergen map) + RecipeLocalization (ar master-fallback,
│                   never-English cultural notes, ui.text/textEn precedence)
├── Theme/          Palette (fresh-market colors) + FifiFont
│                   (per-language OFL faces, Dynamic Type via text styles)
├── Components/     RemoteImage (AsyncImage + branded placeholder), cards,
│                   error/skeleton states, YouTubePlayer (WKWebView sheet)
├── Screens/        LanguagePicker, Home, Chapters(+detail), Search,
│                   RecipeDetail, Settings
└── KidsMode/       Kids catalogue, ready checklist, step-by-step,
                    celebration, 190 bundled PNG illustrations, Baloo fonts
```

### Localization

24 languages, RTL (`ar`, `ur`, `fa`, `ps`, `he`, `ku`) flips layout via
`.environment(\.layoutDirection)`. UI strings and allergen names are bundled
from the TV repo's `strings.ts` (via `scripts/export-strings.cjs` →
`ui-strings.json`). Fonts are bundled OFL Google Fonts selected per language:
Plus Jakarta Sans (Latin), Tajawal (ar/RTL), Vazirmatn (fa),
Noto Nastaliq Urdu (ur), Heebo (he), Baloo 2/Baloo Bhaijaan 2 (kids mode) —
all through Dynamic Type text styles, no fixed point sizes for body text.

### Duo / foldable readiness

- Size-class-driven `LazyVGrid(.adaptive)` everywhere; no
  `UIScreen.main.bounds`, no `userInterfaceIdiom`, no orientation checks.
- Standard `TabView` + `NavigationStack` chrome only — adapts to fold poses,
  camera-occlusion bands and side-mounted toolbars for free.
- Safe-area-respecting scroll margins; content never sits under the status bar.
- Manual adaptivity checklist: compact iPhone, Pro Max, resizable sim at
  ~5.4" outer / ~7.6" inner, both orientations in each pose.

### Videos

Recipe videos are YouTube. In-app playback uses a `WKWebView` sheet loading
`https://www.youtube-nocookie.com/embed/{id}?rel=0&playsinline=1`
(fullscreen-capable), with an "Open in YouTube" secondary action. The
nocookie domain avoids tracking cookies until the user presses play — see
`site/privacy.html`.

## Privacy posture

No accounts, no analytics, no crash SDKs, no tracking. App Store privacy
label: **Data Not Collected**. On-device storage is limited to the selected
language (UserDefaults) and URL caches. `PrivacyInfo.xcprivacy` is bundled;
`ITSAppUsesNonExemptEncryption=false` (plain HTTPS).

## CI

- `.github/workflows/pages.yml` — deploys `site/` to GitHub Pages
  (`iosapp.fifi.cooking`) on pushes to `main`.
- `.github/workflows/ios-ci.yml` — builds and runs the full test suite on
  `macos-latest`. Note: private repos get limited free GitHub Actions
  minutes and macOS runners bill at 10× — the workflow is also
  `workflow_dispatch`-able so it can be run on demand.

## Repo layout

```
site/           Static Pages site (landing, support.html, privacy.html,
                CNAME → iosapp.fifi.cooking)
docs/           screenshots/ contact sheet
scripts/        resource generators (ui-strings export, kids-art render)
STORE.md        App Store submission checklist + current answers
```

## App Store status

See `STORE.md`. Summary: app is build- and feature-complete for a 1.0
submission; remaining items need an Apple Developer account (Team ID for
AASA/Universal Links, screenshots from a real device, App Store Connect
record).
