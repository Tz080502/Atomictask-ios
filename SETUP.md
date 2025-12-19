# TaskFocus iOS App - Setup Guide

## Overview

TaskFocus is a minimal iOS app designed for users with ADHD to focus on one task at a time. It integrates with your existing Supabase-based task management SaaS.

## Project Structure

```
TaskFocusApp/
├── Sources/TaskFocusApp/
│   ├── TaskFocusApp.swift          # App entry point
│   ├── ContentView.swift            # Root view with auth state management
│   ├── Models/
│   │   ├── Task.swift               # Task data model
│   │   └── Project.swift            # Project data model
│   ├── Services/
│   │   ├── SupabaseService.swift    # Supabase client & API calls
│   │   └── SwipeLimitService.swift  # Daily swipe limit management
│   ├── ViewModels/
│   │   ├── AuthViewModel.swift      # Authentication logic
│   │   └── TaskViewModel.swift      # Task management & sorting
│   ├── Views/
│   │   ├── AuthView.swift           # Login/Signup screen
│   │   ├── MainTaskView.swift       # Main task display screen
│   │   ├── TaskCardView.swift       # Swipeable task card
│   │   ├── CongratsView.swift       # All tasks completed screen
│   │   ├── LimitReachedView.swift   # Daily limit reached screen
│   │   └── SettingsView.swift       # Settings & preferences
│   └── Utilities/
│       ├── Constants.swift          # App constants & config
│       └── ColorTheme.swift         # Color definitions
├── Package.swift                    # Swift Package Manager config
├── Info.plist                       # iOS app configuration
└── README.md                        # Project documentation
```

## Features Implemented

### ✅ Core Features
- **Supabase Authentication**: Login/Signup with email & password
- **Task Fetching**: Retrieves incomplete tasks for authenticated user
- **Project Integration**: Displays project name for each task
- **One Task at a Time**: Shows single task card to reduce overwhelm
- **Swipe to Complete**: Swipe right gesture to mark task as done
- **3 Swipes Per Day**: Enforced daily limit with midnight reset
- **Smart Sorting**: 
  - Quick Tasks First (ascending duration)
  - Hard Tasks First (descending duration)
- **Task Duration**: Uses `how_explanation` field for duration estimation
- **Congrats Screen**: Shown when all tasks are completed
- **Limit Reached Screen**: Shown when daily swipe limit is hit
- **Settings**: Sort preference, swipe counter, sign out

### 🎨 Design
- Custom color scheme optimized for ADHD users
- Clean, minimal UI with reduced visual clutter
- Smooth animations and transitions
- Portrait-only orientation for focused experience

## How to Build & Run

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 17.0+ device or simulator
- Active internet connection (for Supabase)

### Steps

1. **Open in Xcode**
   ```bash
   cd /Users/tamimmultaheb/CascadeProjects/TaskFocusApp
   open TaskFocusApp.xcodeproj
   ```

2. **Install Dependencies**
   - Xcode will automatically resolve Swift Package Manager dependencies
   - The Supabase Swift SDK will be downloaded automatically

3. **Select Target**
   - Choose an iOS 17+ simulator or connected device
   - Select the TaskFocusApp scheme

4. **Build & Run**
   - Press `Cmd + R` or click the Run button
   - Wait for build to complete

## Configuration

### Supabase Settings
The app is pre-configured with your Supabase credentials in `Constants.swift`:
- **URL**: `https://imaoqufxisdfokbtbumb.supabase.co`
- **Anon Key**: Already configured

### Database Schema
The app expects these tables in Supabase:

**tasks table:**
- `id` (UUID)
- `project_id` (UUID, foreign key)
- `content` (text)
- `is_completed` (boolean)
- `position` (integer)
- `created_at` (timestamp)
- `updated_at` (timestamp)
- `how_explanation` (text, nullable) - Used for duration estimation

**projects table:**
- `id` (UUID)
- `user_id` (UUID, foreign key)
- `name` (text)
- `position` (integer)
- `created_at` (timestamp)
- `updated_at` (timestamp)
- `type` (text)
- `goal_description` (text, nullable)
- `goal_step_count` (integer)
- `archived` (boolean)
- `workspace_id` (UUID, nullable)

## Usage Flow

1. **Login/Signup**: User authenticates with email & password
2. **Task Loading**: App fetches incomplete tasks and projects
3. **Task Sorting**: Tasks sorted by user preference (quick/hard first)
4. **Task Display**: First task shown as swipeable card
5. **Swipe Right**: Marks task complete, shows next task
6. **Daily Limit**: After 3 swipes, shows limit reached screen
7. **All Done**: When no tasks remain, shows congrats screen
8. **Settings**: User can change sort preference and sign out

## Key Implementation Details

### Daily Swipe Limit
- Stored in `UserDefaults` with date tracking
- Automatically resets at midnight
- Prevents swipes when limit reached

### Task Sorting
- Extracts duration from `how_explanation` field
- Parses first number found in the text
- Falls back to `Int.max` if no duration found
- Sorts based on user preference

### Authentication State
- Managed by `SupabaseService` singleton
- Persists session across app launches
- Auto-checks session on app start

### Error Handling
- Network errors shown as toast messages
- Authentication errors displayed on login screen
- Graceful fallbacks for missing data

## Customization

### Changing Colors
Edit `ColorTheme.swift` to modify the color scheme:
- `appBackground`: #F9F3E9
- `cardBackground`: #FFFCF9
- `accentRed`: #B35C5C
- `accentBlue`: #608BC1
- `textDark`: #3D3D3D
- `borderStroke`: #E8E2D8

### Changing Daily Limit
Edit `Constants.swift`:
```swift
static let maxSwipesPerDay = 3  // Change to desired limit
```

### Adding More Sort Options
1. Add case to `SortPreference` enum in `Constants.swift`
2. Update sorting logic in `TaskViewModel.sortTasks()`

## Testing

### Test Accounts
Create test accounts in Supabase Auth dashboard or use signup flow in app.

### Test Data
Ensure your Supabase has:
- At least one project for the test user
- Multiple tasks with varying `how_explanation` values
- Tasks with `is_completed = false`

## Troubleshooting

### "No tasks available"
- Check that tasks exist in Supabase for the logged-in user
- Verify `is_completed = false` for tasks
- Ensure tasks have valid `project_id`

### Authentication fails
- Verify Supabase URL and anon key are correct
- Check internet connection
- Ensure Supabase Auth is enabled in dashboard

### Swipe limit not resetting
- Check device date/time settings
- Verify app has been closed and reopened after midnight

## Next Steps

### Potential Enhancements
- Push notifications for new tasks
- Offline support with local caching
- Task scheduling/time blocking
- Progress tracking and analytics
- Widget for iOS home screen
- Apple Watch companion app
- Haptic feedback on swipe
- Undo last swipe action
- Custom task duration input
- Dark mode support

## Support

For issues or questions about the implementation, refer to:
- Supabase Swift SDK: https://github.com/supabase/supabase-swift
- SwiftUI Documentation: https://developer.apple.com/documentation/swiftui
