# ConvoyIQ — Implementation Plan

**Prepared for:** Antigravity  
**Application:** ConvoyIQ — Flutter Android Convoy Tracking App  
**Document Version:** 1.0  
**Date:** 2026-05-21

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Phase Breakdown](#3-phase-breakdown)
4. [Phase 1 — Foundation & Project Scaffolding](#phase-1--foundation--project-scaffolding)
5. [Phase 2 — Core Infrastructure](#phase-2--core-infrastructure)
6. [Phase 3 — Feature Development](#phase-3--feature-development)
7. [Phase 4 — AI Integration & Discovery](#phase-4--ai-integration--discovery)
8. [Phase 5 — Background Services & Offline](#phase-5--background-services--offline)
9. [Phase 6 — Bonus Features](#phase-6--bonus-features)
10. [Phase 7 — QA, Performance & Release](#phase-7--qa-performance--release)
11. [Dependency Map](#11-dependency-map)
12. [External Services Checklist](#12-external-services-checklist)
13. [Risk Register](#13-risk-register)
14. [Definition of Done](#14-definition-of-done)

---

## 1. Project Overview

ConvoyIQ is a production-grade Flutter Android application that solves a real-world group travel problem: convoy leaders cannot monitor whether rear members are keeping pace without physically stopping. The app replaces manual look-back checks with real-time GPS proximity tracking, smart alerts, checkpoint coordination, and route-aware utilities — all without requiring user login.

**Package name:** `com.convoyiq.convoy_iq`  
**Platform:** Android only (portrait-locked)  
**Min SDK:** 23 | **Target SDK:** 34  
**Flutter tooling:** `fvm` with latest stable channel  
**State management:** Riverpod with code generation  
**Local persistence:** Drift (SQLite ORM)  
**Real-time sync:** Firebase Realtime Database (primary), Socket.IO relay (fallback interface)

---

## 2. Architecture Overview

The application follows Clean Architecture with feature-based folder organization, divided into three layers:

```
Presentation Layer
  Flutter Widgets + Riverpod AsyncNotifiers
  No business logic in widgets; all state via providers

Domain Layer
  Pure Dart use cases and entity models
  Zero Flutter dependencies

Data Layer
  Repository implementations
  Drift DAOs for local storage
  Dio services for remote API calls
  Firebase Realtime Database adapter
```

Each feature is organized as a self-contained slice:

```
features/{feature_name}/
  presentation/
    screens/
    widgets/
    providers/
  domain/
    entities/
    usecases/
  data/
    models/
    repository_impl/
```

Infrastructure services (background GPS, notifications, socket relay) are all injectable via Riverpod providers and reside outside feature folders under `lib/shared/`.

---

## 3. Phase Breakdown

| Phase | Scope | Estimated Effort |
|---|---|---|
| Phase 1 | Foundation & Project Scaffolding | 3–4 days |
| Phase 2 | Core Infrastructure | 5–6 days |
| Phase 3 | Feature Development (Features 1–7) | 14–18 days |
| Phase 4 | AI Integration & Discover Feature | 4–5 days |
| Phase 5 | Background Services & Offline | 3–4 days |
| Phase 6 | Bonus Features | 5–7 days |
| Phase 7 | QA, Performance & Release | 4–5 days |
| **Total** | | **38–49 days** |

---

## Phase 1 — Foundation & Project Scaffolding

### 1.1 Environment Setup

- Install and configure `fvm`, pin to latest stable Flutter channel
- Create project: `fvm flutter create --org com.convoyiq --project-name convoy_iq convoy_iq`
- Configure `android/app/build.gradle`: `minSdkVersion 23`, `targetSdkVersion 34`
- Set up `ProGuard/R8` with rules for `google_maps_flutter`, `firebase_database`, `socket_io_client`, and `drift`
- Add `google-services.json` placeholder path at `android/app/`
- Add `.gitignore` entries for `api_keys.dart`, `google-services.json`, and keystore files

### 1.2 Portrait Lock

In `main.dart`, before `runApp`, lock orientation:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Firebase init, etc.
  runApp(ProviderScope(child: ConvoyIQApp()));
}
```

### 1.3 Responsive Layout Baseline

Wrap root widget in `ScreenUtilInit` with design baseline `Size(390, 844)` (iPhone 14 Pro logical resolution as the cross-device midpoint):

- All horizontal dimensions: `.w` extension
- All vertical dimensions: `.h` extension
- All font sizes: `.sp` extension
- All radii: `.r` extension
- No hardcoded pixel values anywhere in the widget tree

### 1.4 Project Folder Structure

Create the full directory tree:

```
lib/
  core/
    constants/       # AppStrings, AppColors, ApiKeys (gitignored)
    theme/           # AppTheme, AppTextStyles
    router/          # GoRouter config, route names, deep link handler
    utils/           # Haversine calc, formatters, validators
    extensions/      # BuildContext, String, LatLng extensions
  data/
    database/        # Drift schema, DAOs, migrations
    models/          # Freezed + json_serializable models
    repositories/    # Abstract interfaces + implementations
    datasources/     # Remote (Dio, Firebase) + Local (Drift)
  domain/
    entities/        # Pure Dart entity classes
    usecases/        # One class per use case
  features/
    home/
    journey/
    tracking/
    checkpoints/
    discover/
    settings/
  shared/
    widgets/
    animations/
    providers/       # App-level Riverpod providers
assets/
  lottie/
  fonts/
  images/
test/
integration_test/
```

### 1.5 pubspec.yaml Dependencies

Declare all dependencies pinned to compatible versions. Key packages:

**State & DI:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`  
**Database:** `drift`, `sqlite3_flutter_libs`, `path_provider`  
**Maps:** `google_maps_flutter`, `geolocator`, `geocoding`, `flutter_map`, `flutter_map_tile_caching`  
**Networking:** `dio`, `connectivity_plus`  
**Real-time:** `firebase_database`, `socket_io_client`  
**Notifications:** `flutter_local_notifications`, `awesome_notifications`  
**Background:** `flutter_background_service`  
**Auth/Identity:** `device_info_plus`, `uuid`, `shared_preferences`  
**Animations:** `flutter_animate`, `lottie`, `rive`  
**Routing:** `go_router`, `app_links`  
**Code gen:** `build_runner`, `freezed`, `json_serializable`  
**AI:** `http` (for Anthropic REST calls)  
**QR:** `qr_flutter`, `mobile_scanner`  
**Sharing:** `share_plus`  
**Misc:** `permission_handler`, `flutter_polyline_points`, `maps_launcher`, `google_maps_webservice`, `flutter_screenutil`, `cached_network_image`, `firebase_crashlytics`, `firebase_analytics`

---

## Phase 2 — Core Infrastructure

### 2.1 Design System

Implement `AppTheme` and `AppColors` covering the full dark-first color palette:

| Token | Hex | Usage |
|---|---|---|
| `convoyGreen` | `#00E676` | Member in range |
| `convoyAmber` | `#FFC400` | Member approaching limit |
| `convoyRed` | `#FF1744` | Member out of range |
| `convoyBlue` | `#2979FF` | Checkpoints, active elements |
| `convoyNeutral` | `#90CAF9` | Labels, secondary text |
| `bg0` | `#0A0E1A` | Deepest background |
| `bg1` | `#111827` | Card backgrounds |
| `bg2` | `#1C2536` | Elevated surfaces |
| `border` | `#2A3550` | Subtle dividers |

Typography:
- `GoogleFonts.spaceMono` — numeric/distance readouts
- `GoogleFonts.inter` — body text
- `GoogleFonts.orbitron` — app name, hero headings only

All values exposed through `AppTheme` class — no hardcoded values in widget tree.

### 2.2 Drift Database Schema

Define tables and generate DAOs for:

- `device_profile` — UUID, display name, avatar color, created_at
- `journeys` — id, title, status (`draft|active|paused|completed`), timestamps, `share_code`
- `journey_members` — id, journey_id, device_id, role (`leader|member`), location fields, status
- `member_locations` — time-series GPS records, pruned after 24 hours
- `checkpoints` — id, journey_id, title, coords, radius, status, created_by
- `checkpoint_arrivals` — checkpoint_id, member_id, arrived_at
- `saved_places` — place_id, category (`hotel|restaurant|petrol|custom`), coords, cached data

Include migration infrastructure from version 1 upward.

### 2.3 GoRouter Configuration

Define all named routes and handle three deep link entry scenarios for `convoyiq://join/{share_code}`:

- Cold start (app terminated): complete onboarding if needed, then navigate to join confirmation
- Warm start (backgrounded): navigate directly to join confirmation
- Foreground: navigate in-place to join confirmation

Configure `AndroidManifest.xml` intent filter for `convoyiq` scheme and `join` host.

### 2.4 Riverpod Provider Tree

Set up app-level providers:

- `deviceProfileProvider` — watches `device_profile` table
- `activeJourneyProvider` — current active journey from Drift
- `connectivityProvider` — network state stream
- `locationServiceProvider` — `geolocator` stream
- `firebaseLocationSyncProvider` — Firebase Realtime Database adapter
- `anthropicServiceProvider` — Claude API HTTP client

Document the full provider dependency graph in `docs/provider_graph.md`.

### 2.5 Permissions Manager

Implement `PermissionService` that requests in sequence with rationale dialogs:

1. `Permission.locationWhenInUse`
2. `Permission.locationAlways`
3. `Permission.notification`
4. `Permission.ignoreBatteryOptimizations`

If location is permanently denied: show non-dismissable dialog with "Open Settings" CTA. App is non-functional without location permission.

### 2.6 Device Identity Service

On first launch: generate UUID v4 via `uuid` package, persist in `SharedPreferences` under key `device_id`. This value is the user's permanent identity — never regenerated.

---

## Phase 3 — Feature Development

### Feature 1: App Bootstrap & Onboarding

**Scope:** First-launch experience, permissions, profile creation.

Deliverables:
- Animated 3-slide onboarding using `flutter_animate` + Lottie JSON assets explaining: convoy tracking, checkpoints, discovery
- Sequential permission request flow with rationale dialogs
- GPS-disabled full-screen gate with Lottie animation and "Enable GPS" CTA (deep links to system location settings)
- Display name input + avatar color picker (8 animated color pill presets)
- Profile persisted to `device_profile` Drift table
- Skip onboarding on subsequent launches using `SharedPreferences` flag

---

### Feature 2: Home Dashboard

**Scope:** App shell, bottom navigation, home feed.

Deliverables:
- Bottom navigation: Home, Active Journey (pulse animation when journey running), Discover, Settings
- `CustomScrollView` + `SliverAppBar` with parallax road/map Lottie header
- Active journey card with live animated member count
- Recent journeys list (last 5 from Drift, tappable to summary)
- Expandable FAB: "Start New Journey" and "Join Journey" sub-actions with staggered reveal animation
- Weather widget via OpenWeatherMap free API (current conditions for device location)
- Daily motivational quote from hardcoded list of 30 (rotated by day-of-year index)

---

### Feature 3: Journey Creation, QR Sharing & Deep Link Join

**Scope:** Full journey lifecycle entry point.

Deliverables:

**Journey Creator Screen:**
- Journey title input with Google Places autocomplete suggestions
- Proximity alert radius slider (100m–2000m, default 500m) with live ring preview on mini map
- Alert style picker: vibration only / sound + vibration / notification banner
- On save: generate 6-char alphanumeric `share_code`, insert journey + leader member to Drift

**QR Code Generation & Sharing Sheet:**
- Full-screen animated bottom sheet immediately after creation
- `qr_flutter` QR encoding `convoyiq://join/{share_code}`
- QR rendered at full sheet width with title and code in monospace below
- "Share QR" — `share_plus` system share sheet with QR as PNG (`RenderRepaintBoundary`, `pixelRatio: 3.0`) + text caption
- "Copy Link" — copies URI to clipboard with toast
- "Share as Text" — text-only caption share
- Re-accessible from journey detail screen (leader only)

**Manual Join Screen:**
- 6-box OTP-style code entry field
- "Scan QR Code" opens `mobile_scanner` full-screen with animated finder overlay
- Preview card: journey title, leader name, current member count, "Join & Enable Location" CTA
- Handles location permission request inline if not yet granted

**Deep Link Join Handler (three scenarios — all covered):**
- Cold start: complete onboarding, then navigate to join confirmation pre-filled
- Warm start: navigate to join confirmation
- Foreground: in-place navigation to join confirmation

**Journey Management:**
- Leader actions: start, pause, end journey; add/remove checkpoints; remove members; update radius
- Member actions: view details, leave journey, view member list
- All state transitions driven by `journeys.status` field

---

### Feature 4: Real-Time Convoy Tracking Map

**Scope:** Core screen — full-screen map with live member tracking.

Deliverables:

**Map Layers:**
- Live member markers: `BitmapDescriptor` custom markers with name initial + avatar color; pulsing ring animation when moving
- Proximity rings: translucent circles around leader representing alert radius
- Route polyline: drawn from leader's `member_locations` history
- Checkpoint markers: distinct per status (pending = gray, active = blue pulse, reached = green check)
- Own location: heading-aware indicator, always foregrounded

**Proximity Status System:**
- Haversine distance calculation per member vs leader, run every location update
- GREEN (0–60% of radius), AMBER (60–90%), RED (>100%) thresholds
- AMBER: pulsing animation on member card; RED: red flashing + haptic + `flutter_local_notifications` alert to all members

**Member Status Strip:**
- `DraggableScrollableSheet` bottom sheet, `maxChildSize: 0.92`
- Horizontal scrollable member cards: `0.42.sw` fixed width (2.2 visible at all times)
- Each card: avatar, name, distance, speed (km/h), status color via `AnimatedContainer`
- Tap to camera-pan to member; "Ping" button sends vibration notification

**Alert System:**
- RED member: push rich notification to all members: "[Name] is too far — [X]m behind"
- Reconnect: "All members back in range" success notification
- GPS signal lost >30s: "Signal Lost" ghost marker at last known location
- Leader persistent top banner when any member out of range

**Map Overlay Controls:**
- Center on me
- Fit all members in viewport
- Toggle satellite / standard
- Toggle traffic layer
- Add checkpoint at current location
- SOS button (long press to trigger) — emergency broadcast to all members

---

### Feature 5: Checkpoints

**Scope:** Leader-controlled waypoint system with arrival detection.

Deliverables:
- Leader drops pin on map (drag to reposition), sets title, description, arrival radius (50m–500m)
- Checkpoint broadcast to all members via Firebase; persisted to `checkpoints` Drift table
- Geofencing via `geolocator` stream to auto-detect arrival
- "Checkpoint Reached" Lottie confetti overlay (3 seconds, auto-dismisses)
- Arrival list: who has arrived vs en route with live ETAs from current speed
- Leader can mark complete (continue) or hold for stragglers
- Checkpoint timeline: custom painter vertical timeline — completed (green), current (blue pulse), upcoming (gray)
- Arrivals stored in `checkpoint_arrivals` table

---

### Feature 6: Discover — Hotels, Restaurants & Petrol Pumps

**Scope:** Route-aware place discovery with AI-enhanced content.

Deliverables:
- Route polyline overlaid on discovery map
- Toggleable place layers: Restaurants, Hotels, Petrol Pumps, Rest Areas
- Google Places Nearby Search at sampled intervals along polyline
- Filters: minimum rating (3+, 4+, 4.5+), open now, price level
- Bottom sheet place cards: photo, name, rating (star display), distance, open/closed badge, hygiene badge
- Detail sheet: photo gallery, AI-generated review summary, hours, "Open in Maps" CTA
- Offline: cached results from `saved_places` Drift table with "Last updated X ago" banner

AI features covered under Phase 4.

---

### Feature 7: Settings

**Scope:** User profile and app configuration.

Deliverables:
- Display name editor with live avatar preview
- Avatar color picker
- Global default proximity alert radius
- Alert style selector
- Map style selector: standard / satellite / terrain / dark mode
- Clear journey history (with confirmation dialog)
- Export journey data as JSON via `share_plus`
- Device ID display (copyable — for support purposes)
- App version and About screen

---

## Phase 4 — AI Integration & Discovery

### 4.1 Anthropic API Service

Implement `AnthropicApiService` using `http` package with REST calls to `https://api.anthropic.com/v1/messages`:

- Exponential backoff retry logic (max 3 retries, delays: 1s, 2s, 4s)
- Configurable `max_tokens` per call type
- All calls non-blocking — displayed with shimmer skeleton loaders in UI
- API key read from `ApiKeys.anthropicApiKey` (gitignored file)

### 4.2 AI Endpoints to Implement

**Route Narrative:**  
Input: route waypoints (first 10), destination, departure time, member count.  
Output: 2-sentence journey summary, optimal lunch stop time, notable points of interest, weather advisory. Max 150 words.

**Hygiene & Safety Scoring:**  
Input: list of review text strings for a restaurant.  
Output: hygiene score 1–5 + one-line reason. Displayed as shield icon on place cards.

**Smart Stop Suggestion:**  
Input: remaining km, average speed km/h, member count, current time.  
Output: recommended stop timing and place type.

**Post-Journey Summary:**  
Input: journey metadata, checkpoint list, member count, distance, duration.  
Output: shareable social media caption summarizing the journey.

**Petrol Pump Advisor:**  
Input: estimated fuel level (user-entered), distance to destination, nearby petrol pump density.  
Output: warning if a fuel stop is required in the next N km.

### 4.3 Discover AI Integration

- "Route Summary" button on Discover screen triggers route narrative call
- Restaurant detail sheets show AI hygiene score (fetched once, cached in `saved_places`)
- "Smart Stop" suggestion card appears on tracking map when journey duration > 2 hours
- All AI content shown with shimmer loader; gracefully degrades to "AI summary unavailable" if API fails

---

## Phase 5 — Background Services & Offline

### 5.1 Background GPS Service

Using `flutter_background_service`:

- Foreground service with persistent notification: "ConvoyIQ tracking active — X members online"
- GPS update every 5 seconds when active, every 30 seconds when backgrounded
- `setAutoStartOnBoot(true)` configured
- Android Doze mode handled via foreground service channel
- `geolocator` configured with `LocationSettings(distanceFilter: 10)` to prevent battery drain

### 5.2 Offline Map Caching

Using `flutter_map` + `flutter_map_tile_caching`:

- When a journey is created: prompt user to pre-cache tiles for 10km radius around start point at zoom levels 12–17
- Show storage estimate and user confirmation before caching
- Offline tile fallback layer active whenever connectivity is lost

### 5.3 Offline-First Data Strategy

- All location events written to `member_locations` Drift table first; synced to Firebase when online
- Journey config fully persisted in Drift — journeys remain usable offline
- Offline members shown with last-known position as ghost markers: "Last seen X min ago"
- Place data cached in `saved_places` for 24 hours

### 5.4 Firebase Realtime Database Sync

Firebase path structure per journey:

```
/journeys/{share_code}/members/{device_id}
  device_id, display_name, lat, lng, accuracy, speed, heading, timestamp, battery
```

- Members write location every 5 seconds
- Members listen to all sibling device_id nodes
- Offline persistence via Firebase built-in disk cache
- Firebase security rules deployed — database not left open

---

## Phase 6 — Bonus Features

These features are enhancements beyond the core set. Implement in order of dependency readiness.

### 6.1 Journey Replay

After journey ends: animated map playback of convoy movement with scrubber timeline. Source data from `member_locations` table. Playback speed controls (1x, 2x, 5x).

### 6.2 Emergency SOS Broadcast

Long-press SOS button on tracking map: sends distress signal with GPS coordinates to all convoy members via Firebase, plus optional SMS via `url_launcher` SMS deep link to a pre-configured emergency contact.

### 6.3 Estimated Arrival Sync

Per-member live ETA to next checkpoint or destination, calculated from current speed and remaining distance. Updated every location cycle.

### 6.4 Convoy Speed Limiter Alert

Configurable max speed threshold (default 80 km/h). If any member exceeds it, push a gentle "Slow down" notification to that member. Configurable in Settings.

### 6.5 Weather Along Route

Fetch weather at multiple points along the planned route (every 50km) using OpenWeatherMap API. Display as a horizontal timeline strip: conditions icon + temperature per segment, with rain warnings highlighted.

### 6.6 Journey Photo Wall

Members can capture photos during a journey. Photos are GPS-tagged and shown as camera pin icons on the map. Stored locally in `shared_preferences`/file cache; optionally uploaded to Firebase Storage. Tapping a pin shows the photo full-screen.

### 6.7 Fuel Tracker

Per-member fuel fill-up logging: amount (litres) + cost (INR). End-of-journey stats: per-member cost, total convoy fuel expenditure. Logged to a local Drift `fuel_logs` table.

### 6.8 Voice Notes

Record up to 30 seconds of audio. Broadcast to all convoy members via Firebase Storage URL pushed through Realtime Database. Playback inline in a member event feed.

---

## Phase 7 — QA, Performance & Release

### 7.1 Testing Requirements

**Unit tests** (all use cases and repository implementations):
- `CreateJourneyUseCase`, `JoinJourneyUseCase`, `UpdateLocationUseCase`
- All repository implementations with mocked datasources
- Haversine calculation utility

**Widget tests** (all custom widgets):
- `ConvoyMemberMarker`, `ProximityStatusCard`, `CheckpointTimeline`
- `PlaceRatingBadge`, `JourneyCodeDisplay`, `OTPCodeInputField`
- `JourneyQRShareSheet`, `QRScannerOverlay`, `Speedometer`

**Integration tests:**
- Journey creation flow end-to-end
- Join journey via manual code entry
- Join journey via QR scan
- Deep link cold-start join flow

### 7.2 Performance Targets

| Metric | Target |
|---|---|
| Cold start to home screen | < 2 seconds (Snapdragon 665 class) |
| Map render after journey start | < 1 second |
| Location update cycle (active) | Every 5 seconds |
| Location update cycle (backgrounded) | Every 30 seconds |
| Member marker update latency | < 2 seconds end-to-end |

Enforcement:
- All map operations off main isolate via `compute()` where needed
- All lists use `ListView.builder` — no `Column` with mapped children
- All remote images via `cached_network_image`
- No `setState` — all state via Riverpod `.watch` / `.listen`
- `flutter analyze` must show zero warnings before any feature is considered complete

### 7.3 Code Quality Checklist

- All public classes, methods, and providers have dartdoc comments
- All data models use `freezed` (immutable, `copyWith`, equality, serialization)
- All providers use `riverpod_annotation` (generated, not manual)
- All async operations wrapped in `AsyncValue` — no raw `Future` in UI
- All error states show retry-able UI, never just a snackbar
- All strings in `AppStrings` constants class (i18n-ready structure)
- All colors, font sizes, spacing values reference `AppTheme` — no hardcoded values

### 7.4 Release Build

- `flutter build apk --release` must produce a working, installable APK
- ProGuard rules included and validated for all relevant packages
- Release keystore generated and SHA-1 registered in Firebase and Google Cloud Console
- `flutter analyze` — zero errors
- `build_runner build --delete-conflicting-outputs` — all generated code clean

---

## 11. Dependency Map

```
Feature 1 (Onboarding)
  └── requires: Drift (device_profile), PermissionService, DeviceIdentityService

Feature 2 (Home Dashboard)
  └── requires: Feature 1, GoRouter, activeJourneyProvider, OpenWeatherMap API

Feature 3 (Journey Creation & Join)
  └── requires: Feature 1, Drift (journeys, journey_members), Firebase adapter, QR, deep link handler

Feature 4 (Tracking Map)
  └── requires: Feature 3, geolocator, firebase location sync, flutter_local_notifications, background service

Feature 5 (Checkpoints)
  └── requires: Feature 4 (tracking map running), Drift (checkpoints), geofencing

Feature 6 (Discover)
  └── requires: Feature 3 (route data), Google Places API, Phase 4 (AI layer)

Feature 7 (Settings)
  └── requires: Feature 1 (device profile), Drift

Phase 5 (Background & Offline)
  └── requires: Feature 4 (tracking operational), flutter_map tile caching

Phase 6 (Bonus Features)
  └── requires: Feature 4 fully stable, member_locations data populated
```

---

## 12. External Services Checklist

These steps require manual account actions and cannot be automated by the code generator.

- [ ] Google Cloud Console project created (`ConvoyIQ`)
- [ ] Five Google APIs enabled: Maps SDK for Android, Places, Geocoding, Directions, Maps Static
- [ ] Google Maps API key generated and restricted to `com.convoyiq.convoy_iq` + SHA-1
- [ ] Firebase project created linked to the same Google Cloud project
- [ ] Firebase Android app registered with package name and SHA-1
- [ ] `google-services.json` downloaded and placed at `android/app/google-services.json`
- [ ] Firebase Realtime Database created (region: `asia-southeast1` for India)
- [ ] Firebase Crashlytics enabled
- [ ] Firebase security rules deployed (database not in test mode for production)
- [ ] Firebase Dynamic Links domain configured: `https://convoyiq.page.link`
- [ ] Debug SHA-1 fingerprint obtained via `keytool` and registered
- [ ] Release keystore generated and release SHA-1 registered separately
- [ ] Anthropic API key obtained from `console.anthropic.com` and added to `api_keys.dart`
- [ ] OpenWeatherMap API key obtained (free tier) and added to `api_keys.dart`
- [ ] `api_keys.dart` confirmed in `.gitignore` — never committed to version control
- [ ] `fvm flutter pub get` run successfully
- [ ] `fvm flutter pub run build_runner build --delete-conflicting-outputs` run successfully
- [ ] `fvm flutter analyze` returns zero errors

---

## 13. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Firebase free tier quota exceeded under heavy testing | Medium | Medium | Monitor usage; throttle location writes in dev; switch to Socket.IO relay if needed |
| Background GPS killed by Android OEM battery optimizers (Samsung, Xiaomi, Realme) | High | High | Foreground service with persistent notification; guide users to disable battery optimization per-device; test on OEM devices specifically |
| `geolocator` accuracy degraded on devices without Google Play Services | Low | Medium | Fallback to network-based location; show accuracy indicator to user |
| Google Maps API key billing if Places API calls spike | Medium | High | Implement aggressive caching in `saved_places`; 24-hour TTL; debounce search inputs |
| Anthropic API latency causing UI stalls | Low | Medium | All AI calls fully async with skeleton loaders; graceful fallback to "unavailable" state |
| Deep link handling failure on cold start with `app_links` | Medium | High | Test all three launch scenarios (cold, warm, foreground) on multiple Android versions; verify intent filter config |
| Code generation (build_runner) conflicts after package updates | Medium | Low | Pin all codegen package versions; run `--delete-conflicting-outputs` consistently |

---

## 14. Definition of Done

A feature is considered complete when all of the following are true:

- All acceptance criteria from the feature specification are implemented
- `flutter analyze` reports zero errors or warnings for the feature's files
- Unit tests written and passing for all use cases and repositories in the feature
- Widget tests written and passing for all custom widgets in the feature
- All strings are in `AppStrings`, all colors/sizes reference `AppTheme`
- All public APIs have dartdoc comments
- Error states are retry-able (not snackbar-only)
- Layout tested and confirmed non-overflowing at 360dp, 390dp, and 430dp screen widths
- No hardcoded pixel values — all sizes via `flutter_screenutil` extensions
- Feature has been reviewed against the performance requirements in Section 7.2
- PR reviewed and merged to main branch

---

*End of Implementation Plan*
