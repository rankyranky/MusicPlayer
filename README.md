# Music Player

A single-screen iOS music player that searches the iTunes catalog and plays 30-second song previews.

## Setup

1. Clone the repository
2. Open `MusicPlayer.xcodeproj` in Xcode
3. Xcode will automatically resolve the Alamofire SPM dependency
4. Select a simulator and run (`Cmd+R`)

## Architecture

The project follows a **Clean(ish) Architecture + MVVM** pattern with three layers:
- **Domain** is the center and depends on nothing. It contains pure entities (`Track`) and protocol definitions (`MusicRepository`). No SwiftUI, no Alamofire, no Codable.
- **Data** implements Domain protocols. It owns networking (Alamofire), Codable DTOs, and the `DefaultMusicRepository`. DTO-to-Entity mapping lives here via `toDomain()`.
- **Presentation** contains SwiftUI views and ViewModels. ViewModels depend on Domain protocols, never on concrete implementations.

Dependencies always point inward. Concretions are injected from a single composition root (`DIContainer`).

### Why no Coordinator?

This is a single-screen app — there is nothing to coordinate. Adding a Coordinator would be unnecessary abstraction for the scope of this project.

## Tech Stack

- **SwiftUI** — declarative UI
- **Alamofire** — HTTP networking
- **AVPlayer** — audio playback for 30s previews
- **iTunes Search API** — music catalog

## Testing

Run tests with `Cmd+U` or:

```bash
xcodebuild test -scheme MusicPlayer -destination 'platform=iOS Simulator,name=iPhone 16'
