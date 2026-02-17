# Mood-Map — Product Vision Document

**Version:** 1.0  
**Date:** February 2026  
**Status:** Strategic Planning

---

## 1. Executive Summary

Mood-Map is an iOS mood and emotional wellness tracking app built on SwiftUI with a cloud backend (Appwrite). Users capture daily emotional states enriched with life context — sleep, exercise, weather, location, photos, and voice notes — and gain insights through heatmaps, scatter plots, and distribution charts.

The app has strong foundational architecture (MVVM, modular MoodMapKit package, clean data models), but its current integrations only scratch the surface of what the Apple platform can offer. This document identifies a comprehensive set of Apple system APIs that can transform Mood-Map from a personal mood logger into an intelligent, proactive emotional wellness companion.

---

## 2. Current State Snapshot

### What the App Does Today
- Multi-dimensional mood selection from 100+ emotions organized by energy/valence quadrants (HEP, HEU, LEP, LEU)
- Life factor capture: sleep hours, exercise hours, weather (manual), and place (manual)
- Photo and voice note attachment per mood entry
- GitHub-style check-in heatmap and scatter plot analytics
- Cloud sync via Appwrite (documents, image bucket, audio bucket)
- Daily motivational quotes and home screen widget
- Local push notification reminders

### What Is Manually Entered (And Could Be Automated)
| Factor | Current State | Opportunity |
|---|---|---|
| Weather | User picks manually | WeatherKit auto-detection |
| Location/Place | User picks category | CoreLocation + geofencing |
| Sleep | User enters hours | HealthKit sleep data |
| Exercise | User enters hours | HealthKit / CoreMotion |
| Voice note transcription | Audio blob, unanalyzed | Speech + Natural Language |
| Mood insights | Rule-based charts | CoreML pattern recognition |

---

## 3. Vision Statement

> **Make Mood-Map the most contextually intelligent, privacy-first emotional wellness companion on Apple platforms — one that understands your life so you don't have to manually log it.**

The goal is not to add features for the sake of it. Each API integration must directly reduce friction for the user, increase the quality of emotional insights, or surface genuinely useful patterns the user could not see themselves.

---

## 4. System API Audit & Integration Opportunities

---

### 4.1 HealthKit
**Priority: Critical**  
**iOS Version:** iOS 8+ (extended mental health APIs iOS 17+)

#### What It Provides
- **Sleep Analysis:** Sleep stages (in-bed, asleep, REM, core, deep) — far richer than a manually entered "hours slept"
- **Heart Rate Variability (HRV):** SDNN-based stress indicator correlated with emotional state
- **Resting Heart Rate:** Cardiovascular baseline, a proxy for stress and recovery
- **Mindful Minutes:** Sessions from Breathe/Mindfulness apps
- **Step Count + Active Energy:** Physical activity proxy
- **State of Mind (iOS 17+):** `HKStateOfMind` — Apple's own emotional state type, writing to HealthKit so mood data participates in Apple Health's unified timeline
- **Workout Sessions:** Exercise type, duration, intensity from Apple Watch

#### Mood-Map Integration Plan
1. **Read** sleep stages nightly and pre-populate the sleep field in next morning's check-in
2. **Read** HRV and resting heart rate and display as a "physiological stress" overlay on the heatmap
3. **Read** step count + active energy and pre-populate the exercise field
4. **Write** `HKStateOfMind` records so user's mood data appears in Apple Health and the Mindfulness summary
5. **Read** Mindful Minutes to show meditation correlation with mood
6. Surface a "Your body data" card on the insights screen showing physio-emotional correlations

#### Key Types
```swift
HKHealthStore, HKQuantityType.heartRateVariabilitySDNN
HKCategoryType.sleepAnalysis, HKStateOfMind
HKQuery.predicateForSamples, HKSampleQuery
```

---

### 4.2 WeatherKit
**Priority: High**  
**iOS Version:** iOS 16+

#### What It Provides
- Current conditions: temperature, precipitation, UV index, cloud cover, wind, visibility, atmospheric pressure
- Hourly and daily forecasts
- Weather severity alerts
- Historical weather data for correlation

#### Mood-Map Integration Plan
1. At check-in time, automatically fetch current weather from device location and pre-populate the weather field — eliminating a manual step
2. Store the full `WeatherCondition` alongside the entry (not just the user's simplified category)
3. On the Insights screen, plot "mood vs. temperature" and "mood vs. UV index" trend lines — richer than the current binary weather tag
4. Add a "weather impact" card: "On rainy days, your happiness index drops an average of 1.4 points"

#### Key Types
```swift
WeatherService, WeatherQuery, CurrentWeather
WeatherCondition, UVIndex, Wind, Precipitation
```

---

### 4.3 CoreLocation
**Priority: High**  
**iOS Version:** iOS 4+

#### What It Provides
- GPS coordinates at check-in time
- Significant location change monitoring (low battery cost)
- Region/geofence monitoring: enter/exit notifications
- Visit tracking: system-detected frequent places

#### Mood-Map Integration Plan
1. At check-in, use reverse geocoding to suggest the place category (home / work / gym / restaurant / etc.) automatically — currently 100% manual
2. Create named geofences for user-defined locations ("My office", "Mom's house") and trigger check-in prompts on arrival/departure
3. Store GPS coordinates with entries to build a private "mood map" — a literal geographic heat map showing happiest and saddest locations
4. In a future watchOS extension, trigger a gentle haptic check-in prompt when arriving at frequent locations

#### Key Types
```swift
CLLocationManager, CLGeocoder, CLCircularRegion
CLMonitor (modern API), CLVisit, CLPlacemark
```

---

### 4.4 Speech Framework + Natural Language
**Priority: High**  
**iOS Version:** Speech iOS 10+ (on-device iOS 13+); NL iOS 12+

#### What It Provides
**Speech:**
- Live and file-based speech-to-text transcription, on-device (private)
- Confidence scores per word
- Custom vocabulary for domain-specific terms

**Natural Language:**
- Sentiment analysis (positive/negative/neutral) on transcribed text
- Named entity recognition (people, places, organizations mentioned)
- Key phrase extraction
- Language detection
- Word embeddings for theme clustering

#### Mood-Map Integration Plan
1. Transcribe voice notes on-device immediately after recording — no cloud processing, fully private
2. Display transcript in the entry detail view alongside the audio player
3. Run sentiment analysis on note text to compute a "note sentiment score" and compare with mood selection
4. Extract named entities: frequently mentioned people ("stressed because of [Boss's name]") or places become correlatable triggers
5. Build a "trigger cloud" on the Insights screen: most frequently mentioned themes in entries logged during low-mood periods
6. Auto-suggest tags based on note content ("You mentioned 'tired' — add fatigue tag?")

#### Key Types
```swift
SFSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest
NLTagger, NLLanguageRecognizer, NLEmbedding, NLModel
```

---

### 4.5 AppIntents + Siri
**Priority: High**  
**iOS Version:** iOS 16+ (AppIntents); Siri Shortcuts iOS 12+

#### What It Provides
- Custom voice commands surfaced to Siri
- Spotlight integration (App Shortcuts appear in Spotlight without user setup)
- App Shortcuts in the Shortcuts app
- Parameter-based voice queries

#### Mood-Map Integration Plan
1. **"Hey Siri, log my mood"** → Siri opens an interactive dialog to capture mood and save a quick entry
2. **"Hey Siri, I'm feeling anxious"** → Intent recognizes emotion keyword, creates entry with that mood selected, prompts for notes
3. **"Hey Siri, show my mood for today"** → Returns today's entries as a Siri response
4. App Shortcuts appear in Spotlight: "Check in to Mood-Map" visible without any configuration
5. Integration with the Shortcuts app for automation: "When I arrive home, prompt me to log my mood"

#### Key Types
```swift
AppIntent, AppEntity, AppShortcut, ParameterSummary
@Parameter, @IntentParameterDependency, IntentResult
ShortcutsLink, AppShortcutsProvider
```

---

### 4.6 CoreML + Create ML
**Priority: Medium-High**  
**iOS Version:** iOS 11+

#### What It Provides
- On-device ML model inference (private, fast, no network)
- Tabular classification and regression
- Text classification
- Custom model training in Create ML with user data

#### Mood-Map Integration Plan
1. **Mood Prediction:** After accumulating enough entries, train a model on the user's own historical data (mood + sleep + exercise + weather + day-of-week + time-of-day) to predict likely upcoming mood states
2. **Anomaly Detection:** Flag entries that deviate significantly from the user's baseline pattern
3. **Sentiment Model:** Fine-tune a text classification model for mood-domain sentiment (the general NL model may not know that "anxious" + "deadline" = high stress)
4. **Pattern Surfacing:** "Your data suggests you feel best after 7+ hours of sleep and at least 20 minutes of exercise — you've hit that combination 8 times in the last 30 days"
5. On-device ensures all inference is private; model stays on device

#### Key Types
```swift
MLModel, MLModelConfiguration, MLBatchProvider
NLModel, NLModelConfiguration, NLTagger (with custom model)
CreateML.MLClassifier (offline training)
```

---

### 4.7 Foundation Models (Apple Intelligence)
**Priority: Medium**  
**iOS Version:** iOS 18.1+ (Apple Intelligence eligible devices: iPhone 15 Pro+, M-series iPad)

#### What It Provides
- On-device large language model access
- Structured output generation via `@Generable` macro
- Tool calling (model can invoke app functions)
- Session-based multi-turn prompting

#### Mood-Map Integration Plan
1. **Personalized Weekly Reflection:** Generate a paragraph-length summary of the user's week — "You had a challenging week emotionally, particularly mid-week, likely connected to reduced sleep on Tuesday and Wednesday. Your highest point was Saturday after your workout."
2. **Intelligent Journaling Prompts:** Generate contextual prompts based on the last entry: "You mentioned feeling isolated — what's one small thing you could do tomorrow to connect with someone?"
3. **Trigger Pattern Narrative:** Turn raw data correlations into readable insights for users who don't read charts
4. **Structured Emotion Extraction:** Use `@Generable` to extract structured mood data from free-form voice note transcripts

#### Key Types
```swift
SystemLanguageModel, LanguageModelSession
@Generable, GenerationOptions, Tool
LanguageModelSession.respond(to:)
```

#### Privacy Note
All inference is on-device. No user data is sent to Apple or any third party. Display "Processed on device" indicator to build user trust.

---

### 4.8 ActivityKit — Live Activities
**Priority: Medium**  
**iOS Version:** iOS 16.2+

#### What It Provides
- Persistent Lock Screen UI updated in real-time
- Dynamic Island integration on iPhone 14 Pro+
- Smart Stack placement on Apple Watch

#### Mood-Map Integration Plan
1. **Daily Mood Summary Live Activity:** Launches at midnight, shows today's mood count, current streak, and last logged mood emoji on the lock screen
2. **Check-In Prompt:** A persistent gentle prompt in the Dynamic Island compact view until the user logs their first mood of the day
3. **Active Tracking Mode:** When user starts a "mood observation session" (watching how they feel during a meeting, event, etc.), a Live Activity tracks elapsed time and allows one-tap mood update from lock screen

#### Key Types
```swift
ActivityAttributes, Activity<T>, ActivityContent
ActivityKit, ActivityState, ActivityUpdate
```

---

### 4.9 WidgetKit — Enhanced Widgets
**Priority: Medium**  
**iOS Version:** iOS 14+ (lock screen iOS 16+); Interactive iOS 17+

#### What It Provides (beyond current implementation)
- Lock screen accessory widgets
- Interactive widgets (buttons and toggles — iOS 17+)
- Configurable widgets via AppIntent
- Smart Stack intelligence

#### Mood-Map Enhancement Plan
Current widget only shows a motivational prompt. Enhance with:

1. **Small home screen:** Today's mood count + streak + dominant mood emoji
2. **Medium home screen:** Today's mood timeline with colored mood dots + weather for today
3. **Lock Screen circular:** Current streak number
4. **Lock Screen rectangular:** Last mood logged + time + quick log button (interactive, iOS 17+)
5. **Smart Stack card:** Auto-surfaced at morning/evening by time of day
6. **Watch complication:** Mood ring showing today's emotional spread by category color

#### Key Types
```swift
AppIntentTimelineProvider, WidgetFamily
AccessoryCircular, AccessoryRectangular, AccessoryInline
Button (in widget context), AppIntent
```

---

### 4.10 WatchConnectivity + watchOS App
**Priority: Medium**  
**iOS Version:** watchOS 7+

#### What It Provides
- Real-time data transfer iPhone ↔ Watch
- Background transfer when not connected
- Watch-side sensor access (heart rate, accelerometer)

#### Mood-Map Integration Plan
1. **Quick Mood Entry on Watch:** Tap a complication, select from your top 5 moods (pulled from recent history), optionally dictate a note, save — syncs to iPhone
2. **Physiological Context:** At check-in, automatically include current heart rate from Apple Watch to add a physiological layer to the mood entry
3. **Haptic Reminders:** Gentle haptic prompt at configured times, actionable without opening the app
4. **Watch-Side Insights:** A small insights glance showing today's mood count and current streak

#### Key Types
```swift
WCSession, WCSessionDelegate
WKExtendedRuntimeSession (for continuous monitoring)
HKWorkoutSession, HKLiveWorkoutBuilder (for heart rate during entry)
```

---

### 4.11 Journaling Suggestions API
**Priority: Low-Medium**  
**iOS Version:** iOS 17.2+

#### What It Provides
- Integration with Apple's native Journal app
- Ability to provide journaling suggestions that appear in Journal
- Allows app data to surface as journaling context
- Apple Health mood data visible as journal suggestions

#### Mood-Map Integration Plan
1. Write `HKStateOfMind` to HealthKit (from 4.1 above) — this automatically makes Mood-Map entries visible as journaling suggestions in Apple Journal
2. Register mood entries as journaling assets so users can reference their Mood-Map check-ins from within Journal
3. "Share to Journal" action from MoodEntryDetailView

#### Key Types
```swift
JournalingSuggestionsPicker, JSAsset
HealthKit integration handles most of this automatically
```

---

### 4.12 BackgroundTasks
**Priority: Low-Medium**  
**iOS Version:** iOS 13+

#### What It Provides
- Scheduled background app refresh
- Long-running processing tasks (device idle, charging)
- Continued processing tasks

#### Mood-Map Integration Plan
1. **Background HealthKit sync:** Pull last night's sleep data in the morning before user opens app, so check-in fields are pre-filled
2. **Background transcription:** Queue voice note transcription to run when device is idle and charging
3. **Nightly ML inference:** Run mood prediction model overnight to prepare next-day "predicted mood" context
4. **Background cloud sync:** Push pending mood entries when network is available

#### Key Types
```swift
BGTaskScheduler, BGAppRefreshTask, BGProcessingTask
BGTaskRequest, BGProcessingTaskRequest
```

---

### 4.13 SensorKit
**Priority: Low**  
**iOS Version:** iOS 14+ (requires special entitlement — clinical/research use)

#### What It Provides
- Ambient light measurements (time in bright/dim environments)
- App usage patterns by category
- Keyboard typing speed and correction rate (proxy for cognitive state)
- Phone face-up/down and usage duration

#### Mood-Map Integration Plan
SensorKit requires a special entitlement from Apple (typically for health research apps). If obtained:
1. Correlate screen time / app category usage with mood
2. Correlate ambient light (time outdoors) with mood
3. Use typing speed as a passive cognitive load indicator

**Note:** This API requires applying to Apple for the `com.apple.developer.sensorkit.reader.allow` entitlement. Not suitable for App Store apps without this process.

---

### 4.14 CoreMotion
**Priority: Low**  
**iOS Version:** iOS 4+

#### What It Provides
- Step count (pedometer)
- Motion activity classification (stationary, walking, running, cycling, automotive)
- Altimeter data (floors climbed)
- Raw accelerometer/gyroscope data

#### Mood-Map Integration Plan
1. If HealthKit is not authorized, fall back to CoreMotion pedometer for step count proxy
2. Motion activity state at check-in time ("You were walking when you logged this mood") adds context
3. Track "movement patterns" — users who go from high movement to sedentary often show mood shifts

#### Key Types
```swift
CMMotionActivityManager, CMPedometer, CMMotionManager
CMActivityType: stationary, walking, running, cycling, automotive
```

---

## 5. Integration Priority Matrix

| API | User Value | Implementation Effort | Privacy Sensitivity | Priority |
|---|---|---|---|---|
| HealthKit (Sleep, HRV) | Very High | Medium | High | P1 |
| HealthKit (StateOfMind write) | High | Low | Medium | P1 |
| WeatherKit | High | Low | Low | P1 |
| CoreLocation (geofence + geocode) | High | Medium | Medium | P1 |
| Speech + NL (voice transcription) | High | Medium | Low | P1 |
| AppIntents / Siri | High | Medium | Low | P2 |
| WidgetKit (enhanced) | Medium | Low | Low | P2 |
| CoreML (pattern prediction) | High | High | Low | P2 |
| Foundation Models | High | Medium | Low | P2 |
| ActivityKit (Live Activities) | Medium | Medium | Low | P3 |
| WatchOS App | Medium | High | Low | P3 |
| Journaling Suggestions | Medium | Low | Low | P3 |
| BackgroundTasks | Medium | Low | Low | P3 |
| CoreMotion | Low | Low | Low | P4 |
| SensorKit | Low | High | Very High | P4 |

---

## 6. Phased Roadmap

### Phase 1 — Smarter Data Collection
*Goal: Eliminate manual entry friction. The app knows context; users focus on the emotion.*

- **WeatherKit:** Auto-detect weather at check-in. Store full condition data, not just the 7-option enum
- **CoreLocation:** Reverse-geocode location to suggest place category. Store coordinates
- **HealthKit Read:** Pre-fill sleep and exercise from Apple Health. Show sync status
- **HealthKit Write:** Save mood selections as `HKStateOfMind` for Apple Health integration
- **Speech Framework:** Auto-transcribe voice notes on-device. Show transcript in detail view

### Phase 2 — Intelligent Insights
*Goal: Surface patterns users cannot see themselves. Go from data to wisdom.*

- **Natural Language:** Sentiment analysis on notes + transcripts. Entity extraction for trigger tracking
- **CoreML:** Train on-device mood prediction from user's own historical data
- **Foundation Models:** AI-generated weekly reflection narratives and journaling prompts
- **AppIntents:** Siri voice mood entry ("Hey Siri, I'm feeling anxious")
- **WidgetKit Enhanced:** Interactive lock screen widgets, configurable home screen widgets

### Phase 3 — Platform Expansion
*Goal: Make Mood-Map a first-class citizen of the Apple ecosystem.*

- **ActivityKit:** Daily mood Live Activity on lock screen + Dynamic Island
- **watchOS App:** Quick mood entry, heart rate at check-in, watch complications
- **Journaling Suggestions:** Surface entries in Apple Journal via HealthKit
- **BackgroundTasks:** Pre-fill check-in fields before user opens app

### Phase 4 — Research & Advanced
*Goal: Optional deep capabilities for power users and clinical contexts.*

- **CoreMotion:** Motion activity context at check-in time
- **SensorKit:** (Requires Apple entitlement) Passive ambient/usage context
- **Create ML:** Custom model training pipeline for advanced personalization

---

## 7. Privacy & Trust Principles

Every API integration must follow these principles:

1. **Explicit Permission First:** Request each permission at the moment of relevance, not at launch. Explain clearly why it's needed and what it unlocks
2. **On-Device First:** Prefer on-device processing (Speech, NL, CoreML, Foundation Models) over cloud-based equivalents
3. **Graceful Degradation:** If a permission is denied, the app works exactly as it does today — no nag screens, no broken features
4. **Data Minimization:** Don't collect what you don't need. Store coordinates only if the user explicitly enables the mood-map feature
5. **Transparency UI:** A "Data & Privacy" settings screen showing every data source the app reads/writes and allowing per-source revocation
6. **Health Data Isolation:** HealthKit data never leaves the device and is never sent to Appwrite or any cloud backend
7. **"Processed on device" indicators** on any AI/ML-powered feature

---

## 8. Technical Architecture Notes

### HealthKit Manager
Needs a new `HealthKitManager` class (or actor) separate from `NetworkManager`. HealthKit reads are device-local — mixing them into the Appwrite networking layer would be a category error.

### Sensor Context in MoodEntry
The `MoodEntry` model needs enrichment:
```swift
// New fields to add to MoodEntry
var latitude: Double?
var longitude: Double?
var temperature: Double?
var weatherCondition: String?   // WeatherKit condition code
var uvIndex: Double?
var heartRate: Double?          // at time of check-in
var hrv: Double?
var stepsToday: Int?
var motionActivity: String?     // walking, stationary, etc.
var noteTranscript: String?     // Speech transcription
var sentimentScore: Double?     // NL sentiment -1 to 1
```

### AppIntents Integration
Register mood names as entities so Siri can understand them:
```swift
struct MoodEntity: AppEntity {
    var id: String
    var name: String  // "anxious", "joyful", etc.
}

struct LogMoodIntent: AppIntent {
    @Parameter(title: "Mood") var mood: MoodEntity
    @Parameter(title: "Note") var note: String?
    func perform() async throws -> some IntentResult { ... }
}
```

### Privacy Permissions Required
Add to `Info.plist`:
- `NSHealthShareUsageDescription`
- `NSHealthUpdateUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription` (for geofencing)
- `NSSpeechRecognitionUsageDescription`
- `NSMicrophoneUsageDescription` (already exists)

---

## 9. Success Metrics

| Metric | Current Baseline | Target |
|---|---|---|
| Check-in completion rate | Unknown | +30% (less friction from auto-fill) |
| Fields populated per entry | ~3-4 avg | ~6-7 (auto-populated context) |
| Voice note usage | Low (manual only) | +50% (with auto-transcription) |
| Weekly active users | Baseline | +25% (Siri + widget access) |
| HealthKit authorization rate | 0% (not integrated) | >60% |
| Insight engagement | Chart views only | Narrative insights viewed daily |

---

## 10. Competitive Differentiation

Most mood tracking apps (Daylio, Reflectly, Bearable) either require full manual entry OR use cloud AI. Mood-Map's opportunity is:

- **Contextual Intelligence without Privacy Trade-offs:** WeatherKit + HealthKit + on-device ML means richer context than competitors without sending data to the cloud
- **Deep Apple Ecosystem Integration:** HealthKit write, Siri shortcuts, Live Activities, Watch app — few wellness apps use all of these together
- **Voice-Native:** Speech transcription + NL analysis makes voice notes genuinely useful, not just audio blobs
- **Apple Journal Bridge:** Via `HKStateOfMind`, Mood-Map entries surface in Apple's own Journal app — a powerful discovery channel

---

*Document prepared for Mood-Map iOS project. All API references are for planning purposes; implementation details subject to Apple developer program terms, entitlement approval requirements, and minimum iOS version constraints.*
