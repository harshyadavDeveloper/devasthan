# 🛕 Devasthan — Your Personal Sacred Space

A Flutter app for Hindu devotees to build their own virtual mandir, listen to daily aartis, and maintain a spiritual practice streak.

---

## ✨ Features

- **Mandir Builder** — Place, drag, and arrange deities and decor on your personal temple canvas. Saved locally via Hive.
- **Aarti Player** — Stream bhajans and aartis directly from Zoho Catalyst Stratus CDN via `just_audio`. No APK bloat.
- **Daily Streak** — Tracks consecutive days of app usage. Persisted across restarts.
- **Morning Alarm** — Set a daily aarti alarm at an exact time with vibration. Survives app kill.
- **Dark Temple Mode** — Full saffron/gold dark theme alongside the light mode.
- **Daily Wisdom** — Rotating quotes from Bhagavad Gita and Vedic scriptures.
- **AdMob Ready** — Banner ad placeholders on all screens, ready for integration.

---

## 🛠️ Tech Stack

| Layer            | Technology                  |
| ---------------- | --------------------------- |
| Framework        | Flutter 3.x                 |
| State Management | Provider                    |
| Navigation       | GoRouter                    |
| Local Storage    | Hive                        |
| Audio Streaming  | just_audio                  |
| Notifications    | flutter_local_notifications |
| Timezone         | timezone                    |
| Audio CDN        | Zoho Catalyst Stratus       |
| Fonts            | Poppins (Google Fonts)      |

---

## 📁 Project Structure

lib/

├── core/

│ └── theme/

│ └── app_theme.dart # Saffron/gold light + dark temple theme

├── navigation/

│ ├── app_router.dart # GoRouter config

│ └── app_shell.dart # Bottom nav shell

├── providers/

│ ├── app_provider.dart # Theme toggle

│ ├── mandir_provider.dart # Mandir builder state + Hive persistence

│ ├── aarti_provider.dart # Audio player state + catalog

│ ├── streak_provider.dart # Daily streak logic + Hive persistence

│ └── alarm_provider.dart # Exact alarm scheduling + notifications

└── screens/

├── home/

│ └── home_screen.dart # Greeting, streak, daily aarti, quote

├── mandir/

│ └── mandir_screen.dart # Drag & drop temple builder

├── aarti/

│ └── aarti_screen.dart # Track list + player controls

└── profile/

└── profile_screen.dart # Alarm, streak, theme, about

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android Studio / VS Code
- Physical device or emulator (Android 5.0+)

### Setup

```bash
# Clone the repo
git clone https://github.com/harshyadavDeveloper/devasthan.git
cd devasthan

# Install dependencies
flutter pub get

# Generate app icon
dart run flutter_launcher_icons

# Generate splash screen
dart run flutter_native_splash:create

# Run
flutter run
```

### Fonts
Download [Poppins](https://fonts.google.com/specimen/Poppins) and place these four weights in `assets/fonts/`:
Poppins-Regular.ttf

Poppins-Medium.ttf

Poppins-SemiBold.ttf

Poppins-Bold.ttf

---

## 🎵 Audio

Bhajan MP3 files are hosted on **Zoho Catalyst Stratus** (CDN). The app streams them on demand — no files are bundled in the APK.

Current tracks:
| Title | Deity |
|-------|-------|
| Jai Ganesh Jai Ganesh Deva | Ganesha |
| Om Jai Shiv Omkara | Shiva |
| Om Jai Lakshmi Mata | Lakshmi |
| Jai Hanuman Gyan Gun Sagar | Hanuman |
| Achyutam Keshavam | Krishna |
| Jai Ambe Gauri | Durga |
| Jai Saraswati Mata | Saraswati |

---

## 🔔 Alarm

The daily aarti alarm uses `zonedSchedule` with `Asia/Kolkata` timezone. It:
- Rings at the exact time set by the user
- Vibrates with pattern `[0, 1000, 500, 1000]`
- Repeats daily via `DateTimeComponents.time`
- Survives app kill and device reboot

> Requires **exact alarm permission** on Android 12+. The app requests this automatically on first launch.

---

## 📱 Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

## 🗺️ Roadmap

- [ ] Phase 6 — AdMob banner integration
- [ ] Real deity images replacing emoji placeholders
- [ ] Panchang / Hindu calendar integration
- [ ] Community bhajan uploads
- [ ] YouTube player fallback for extended catalog
- [ ] iOS App Store release

---

## 👨‍💻 Built By

**Harsh Yadav** — Flutter & MERN Stack Developer
- GitHub: [@harshyadavDeveloper](https://github.com/harshyadavDeveloper)
- Bangalore, India

---

## 📄 License

This project is private and not open for redistribution.

---

> 🙏 *Jai Shri Ram — May this app bring peace and devotion to every home.*
