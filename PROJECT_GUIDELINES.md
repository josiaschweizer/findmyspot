# FindMySpot Project Guidelines
These guidelines define the technical and organization standard for the FindMySport project.
The goal is to keep the codbase consisten, maintainable, and easy to work with for all team members.

## 1. Project Scope
FindMySpot is a native iOS application for discovering public and freely accessible places based on the user's current needs.

The application is developed as part of our Vertiefungsarbeit (VA).

The main focus is on:

- displaying places on a map
- discovering suitable places nearby
- filtering places based on specific needs
- displaying detailed information about places
- allowing users to contribute places and informations
- providing user authentication
- creating a simple and intuitive user experience

The required features defined in the VA have priority over additional features.

New features should only be added when they provide a clear benefit and do not put the completion of the required features at risk.

---

## 2. Technology Stack

The following technologies are used:

### iOS

- Swift
- SwiftUI
- MapKit
- CoreLocation
- Xcode
- Swift Package Manager

### Backend

- Supabase
- PostgreSQL (already set up in the supabase project)
- Supabase Auth
- Supabase Storage
- RLW (Row Level Security)
- supabase-swift

### Development

- Github
- Figma

New frameworks and dependencies should only be added when there is a clear reason for using them.

---

## 3. Project Structure

The iOS application follows a simple MVVM-based structure.

```text
FindMySpot/
├── Models/
├── Views/
├── ViewModels/
├── Services/
├── Extensions/
├── Utilities/
└── Resources/
```

Responsibilities should be seperated as follows:

### Models

Contain application data structures.

Examples:

- `Place`
- `PlaceRating`
- `UserProfile`

### Views

Contain SwiftUI user interface components.

Views should primarily be responsible for presentation and should contain as little business logic as possible.

### ViewModels

Contain presentation logic and manage state required by views.

### Services

Contain communication with external systems and platform APIs.

Examples:

- `SupabaseService`
- `PlaceService`
- `AuthService`
- `LocationService`

### Extensions

Contain reusable Swift extensions.

### Utilities

Contain small reusable helpers that do not belong to a specific feature.

---

## 4. Git Workflow

The `main` branch represents the stable state of the project. Direct development on `main` is not allowed.

Every change must be implemented on a separate branch and merged through a pull request.

### Branch Names

Branch names must be short, written in lowercase and use hyphens between words.

Use an appropriate prefix:

```text
feat/map
feat/place-detail
fix/location-permission
chore/update-dependencies
refactor/map-service
docs/project-documentation
test/place-filter
```

### Commits

Every commit message must begin with an appropriate Conventional Commit type. The message after the colon should match the branch name without its prefix.

For the branch `feat/place-detail`, valid commits include:

```text
feat: place-detail
fix: place-detail
test: place-detail
```

### Pull Requests

After completing a change:

1. Commit the changes.
2. Push the branch.
3. Create a pull request.
4. Use the complete branch name as the pull-request title.
5. Assign the review to `@josia.schweizer`.
6. Merge the pull request into `main`.
7. Delete the branch after it has been merged.

Example pull-request title:

```text
feat/place-detail
```

### Merge Commits

Merge commits must begin with `merge:` followed by the complete branch name.

```text
merge: feat/place-detail
```

### KI Usage Documentation 

Screenshots used to document AI usage for the Vertiefungsarbeit are an exception for the regular git commit guidelines.

These commits must always be commited and pushed directly to `main`.
No separate branch or pull request is required for KI-usage screenshots.

The commit message must use the following format:

```text
feat: doc
- add KI-usage screenshots for Nr. <number>
```

Example:

```text
feat: doc
- add KI-usage screenshots for Nr. 1
```

KI-usage screenshot commits are the only exception to the rule that direct development on `main`is not allowed.

---

## 5. Branch Naming

Branch names must use lowercase letters and hyphens.

The following prefixes should be used:

```text
feature/<name>
fix/<name>
refactor/<name>
docs/<name>
chore/<name>
```

Examples:

```text
feature/place-detail
feature/map-filter
feature/authentication

fix/map-annotations
fix/login-error

refactor/place-service

docs/project-guidelines

chore/update-dependencies
```

Branch names should describe the purpose of the branch clearly.

---

## 6. Commit Guidelines

Commits should be small and represent one logical change.

Commit messages are written in English.

Use lowercase imperative-style messages.

Examples:

```text
add place detail view

implement map annotations

add place repository

fix location permission handling

refactor authentication service

update project guidelines
```

Avoid meaningless commit messages such as:

```text
update

changes

fix

stuff

test
```

Do not combine unrelated changes into a single commit.

---

## 7. Swift Coding Guidelines

### Naming

Follow the official Swift naming conventions.

Types use `UpperCamelCase`:

```swift
struct PlaceDetailView
final class PlaceService
enum PlaceCategory
```

Properties, variables and functions use `lowerCamelCase`:

```swift
let placeName: String

func fetchPlaceDetails()
func createPlace()
```

Name should describe their purpose clearly.

Avoid unnecessary abbrevations.

Prefer:

```swift
currentLocation
placeDescription
selectedCategory
```

instead of:

```swift
currLoc
desc
selCat
```

### Access Control

Use the most restrictive access level possible.

Implementation details should be marked `private` whenever they are not requried outside their type.

### Immutability

Prefer immutable types and values whenever possible.

### Optionals

Avoid force-unswrapping optionals.

Do not use: 

```swift
let place = selectedPlace!
```

Prefer safe optional handling:

```swift
guard let place = selectedPlace else {
    return
}
```

### Functions

Functions should have on clear responsibility.

If a function beomces difficult to understand, it should be split into smaller functions.

### SwiftUI Views

Views should remain small and readable.

Large views should be split into reusable subviews / components.

Avoid putting database access or complex business logic directly into views.

---

## 8. Supabase & Database Guidelines

### Migrations

All database schema changes must be implemented using Supabase migrations.

Migration files are stored in: 

```text
supabase/migrations/
```

Create migrations using:

```bash
supabase migration new <migration-name>
```

Example:

```bash
supabase migration new create_places
```

Database changes should first be tested against the local Supabase instance.

### Local Development

Start the local Supabase environment using:

```bash
supabase start
```

Apply all migrations from scratch using:

```bash
supabase db reset
```

Before pushing migrations to a remote database, they must work successfully against a clean local database.

### Remove Database

Migrations are deployed using:

```bash
supabase db push
```

Use the dry-run option before deploying important changes:

```bash
supabase db push --dry-run
```

### NEVER Modify Applied Migrations

Once a migration has been applied to a production database, it must not be modified or deleted.

Incorrect database changes must be corrected using a new migration.

Example:

```text
20260905100000_create_ratings.sql
20260905103000_remove_ratings.sql
```

The migration history must remain reproducible.

### No Manual Schema Changes

Do not modify the database schema manually through the Supabase dashboard.

Schema changes must always be represented by migration files in the repository.

This ensures that the databse schema can be reprocued by every developer.

### Naming

PostgreSQL tables and columns use `snake_case`.

Examples:

```text
places
place_images
place_ratings

created_at
created_by
wheelchair_accessible
power_outlets
```

---

## 9. Security & Secrets

Row Level Security must be enabled for tables exposed through the Supabase API.

Access should be controlled using explicit RLS policies.

Never rely solely on client-side checks for authorization.

For example, if only the creator of a place is allowed to modify it, the restriction must also exist in the database through a RLS policy.

---

## 10. Testing

Every feature must be tested before it is merged into `main`.

At minimum, verify:

- the application builds successfully
- the feature works as expected
- existing functionality still works
- relevant error cases are handled

Database migrations must be tested using:

```bash
supabase db reset
```

A migration is not considered complete if the database cannot be recreated from scratch.

## 11. Pull Requests & Reviews

Changes are integrated into `main` via pull requests.

A Pull Request should:

- have a clear and representative title
- describe what was changed
- mention relevant technical decisions
- explain how the change was tested

Pull Request should be remain reasonably small.

Pull Requests should be reviewed by @josia.schweizer

---

## 12. Dependencies

Dependencies should only be introcued when they provide a clear advantage over implementing the required functionality using existing frameworks.

Before adding a dpeendency, consider: 

- Is it actually maintained?
- Is it necessary?

Dependencies should be added using Swift Package Manager whenever possible.

## 13. Core Rules

The following rules apply throughout the entire project:

**1. No direct development on `main`.**

**2. No database schema changes outside Supabase migrations.**

**3. Never modify migrations that have already been deployed to a shared database.**

**4. No secrets or private credentials in the repository.**

**5. Database changes must work from a clean `supabase db reset`.**

**6. Required VA functionality has priority over optional features.**

**7. Keep the architecture as simple as possible while maintaining clean separation of responsibilities.**
