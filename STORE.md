# App Store submission checklist — FiFi Recipes 1.0

## Identity

| Item | Value |
|------|-------|
| Name | FiFi Recipes |
| Bundle ID | `cooking.fifi.ios` |
| Version | 1.0 |
| Category | **Food & Drink** (NOT Kids — kids mode is a feature, app is for grown-ups) |
| Copyright | © 2026 Dr. Fatma / FiFi |
| Support URL | https://iosapp.fifi.cooking/support.html |
| Privacy URL | https://iosapp.fifi.cooking/privacy.html |
| Marketing URL | https://iosapp.fifi.cooking |

## Technical compliance (done in-repo)

- [x] Native SwiftUI app, not a hosted WebView (Guideline 4.2)
- [x] `PrivacyInfo.xcprivacy` — no required-reason APIs beyond declarations
- [x] `ITSAppUsesNonExemptEncryption = false` (plain HTTPS only)
- [x] `UILaunchScreen` configured
- [x] All four iPhone orientations (layout is genuinely adaptive)
- [x] App icon: single 1024×1024 modern icon, no alpha channel
- [x] iPhone-only target; runs resizable on iPad/Duo automatically
- [x] No third-party SDKs, no analytics, no tracking
- [x] Min iOS 17 deployment target

## Accessibility

- [x] Dynamic Type via text styles (bundled fonts scale with system)
- [x] VoiceOver labels/hints on cards and controls
- [x] RTL mirroring for ar/ur/fa/ps/he/ku
- [x] ≥44×44pt hit targets, ≥4.5:1 contrast on the cream palette
- [x] Reduce Motion honored (confetti/shimmer disabled); Reduce Transparency

## Age rating answers

- Objectionable content: **none**
- Unrestricted web access: **NO** — content is curated JSON from
  fifi.cooking plus controlled youtube-nocookie.com embeds
- User-generated content / social: **none**
- Kids category: **NO**

## Privacy nutrition label

**Data Not Collected** — no accounts, identifiers, usage data, or
diagnostics leave the device. YouTube embeds use `youtube-nocookie.com`
(privacy-enhanced mode); Google's policy applies inside the player once the
user presses play — disclosed in `site/privacy.html`. Verify at submission
that no embed/analytics have crept in.

## Blocked on Apple Developer account

- [ ] Enroll ($99/yr, individual or org + D-U-N-S)
- [ ] Real **Team ID** → replace `TEAMID` placeholder in the backend repo
      (`scripts/generate-public-index.ts`, `APPLE_TEAM_ID`) and redeploy —
      this completes Universal Links for `/recipe/*`, `/chapter/*`, `/kids/*`
- [ ] App Store Connect app record (SKU suggestion: `fifi-recipes-ios`)
- [ ] Signing + archive + upload via Xcode
- [ ] Screenshots for 6.9"/6.7"/6.5" displays (capture on device or sim —
      `docs/screenshots/` has sim shots; App Store wants exact-size sets)
- [ ] App Review notes: mention test account not needed (no login),
      videos require network
