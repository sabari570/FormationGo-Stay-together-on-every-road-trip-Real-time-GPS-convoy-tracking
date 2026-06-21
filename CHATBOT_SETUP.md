# Chatbot Setup (Free Gemini + Local Fallback)

FormationGo's route chatbot uses **cached POIs along your journey** to answer questions about food, fuel, scenic stops, and rest areas.

## How it works

1. **Primary (free cloud):** Google Gemini API formats friendly tour-guide replies.
2. **Fallback (always free):** If Gemini is unavailable, a local rule-based assistant lists matching POIs from your cached route data — works offline once POIs are cached.

## Enable AI replies (optional but recommended)

1. Go to [Google AI Studio](https://aistudio.google.com/apikey)
2. Create a free API key (no credit card required for the free tier)
3. Run the app with:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

For release builds:

```bash
flutter build apk --dart-define=GEMINI_API_KEY=your_key_here
```

## Without an API key

The chatbot still works in **Local** mode:
- Open **Tour Guide** from the journey map (FAB shows a `Local` badge)
- Ask about food, fuel, scenic spots, etc.
- Answers come from OpenStreetMap POIs cached along your route

## Prerequisites for good answers

1. Host must set **start + destination** on the journey
2. Wait briefly for **route POI caching** (Overpass API) — the FAB shows a spinner until POIs are ready
3. Firestore must be configured (see `FIREBASE_SETUP.md`) so POIs sync across devices

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| FAB says `Local` only | Add `--dart-define=GEMINI_API_KEY=...` |
| "Route data is still being cached" | Wait for route setup + POI pipeline; check network |
| Generic errors | Verify API key at AI Studio; check quota |
| Offline | Local fallback lists cached POIs automatically |

## Privacy note

Do not commit API keys to git. Use `--dart-define` or CI secrets instead.
