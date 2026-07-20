# Firestore Database Structure

This document outlines the detailed structure of all collections in the Firestore database for **EduBridge AI**.

## Core Collections

### 1. `users`
- **Path**: `/users/{userId}`
- **Description**: Stores user profile information. The document ID maps directly to the Firebase Auth UID.

| Field | Type | Description |
|---|---|---|
| `id` | String | User UID (matches Auth UID) |
| `email` | String | Email address of the user |
| `fullName` | String | Complete display name |
| `role` | String | User role: `student` \| `mentor` \| `admin` |
| `bio` | String | Profile biography/description |
| `profilePictureUrl` | String | URL of the profile picture |
| `createdAt` | Timestamp | Timestamp of profile registration |
| `updatedAt` | Timestamp | Timestamp of last profile update |

---

### 2. `scholarships`
- **Path**: `/scholarships/{scholarshipId}`
- **Description**: Read-only listing of available academic scholarships.

| Field | Type | Description |
|---|---|---|
| `id` | String | Unique scholarship UUID |
| `title` | String | Scholarship title |
| `description` | String | Detailed information |
| `amount` | String | Funding amount (e.g. "$5,000", "Fully Funded") |
| `deadline` | Timestamp | Application submission deadline |
| `eligibilityCriteria`| String | Bullet points or text describing eligibility |
| `provider` | String | Organization sponsoring the scholarship |
| `applicationUrl` | String | External URL to apply directly |
| `category` | String | Category tag: `undergraduate` \| `postgraduate` \| `STEM` |
| `createdAt` | Timestamp | Database insertion time |
| `updatedAt` | Timestamp | Document last update time |

---

### 3. `applications`
- **Path**: `/applications/{applicationId}`
- **Description**: Tracks user applications.

| Field | Type | Description |
|---|---|---|
| `id` | String | Unique application ID |
| `userId` | String | Reference to `users.id` |
| `scholarshipId` | String | Reference to `scholarships.id` |
| `scholarshipTitle` | String | Denormalized scholarship title for quick lookup |
| `status` | String | Current state: `applied` \| `in_progress` \| `accepted` \| `rejected` |
| `appliedAt` | Timestamp | Submission timestamp |
| `documents` | Array (String) | URLs of uploaded application documents (e.g. CVs, essays) |
| `notes` | String | Custom student text notes |
| `createdAt` | Timestamp | Record creation time |
| `updatedAt` | Timestamp | Last status change or update time |

---

### 4. `bookmarks`
- **Path**: `/bookmarks/{bookmarkId}`
- **Description**: Stores user bookmark lists. The document ID is structured as `${userId}_${scholarshipId}` to easily query bookmark state and prevent duplicate listings.

| Field | Type | Description |
|---|---|---|
| `id` | String | Bookmark identifier (`${userId}_${scholarshipId}`) |
| `userId` | String | Reference to `users.id` |
| `scholarshipId` | String | Reference to `scholarships.id` |
| `bookmarkedAt` | Timestamp | Timestamp when the item was bookmarked |

---

### 5. `notifications`
- **Path**: `/notifications/{notificationId}`
- **Description**: Stores personalized user notifications and system reminders.

| Field | Type | Description |
|---|---|---|
| `id` | String | Notification UUID |
| `userId` | String | Target user reference (`users.id`) |
| `title` | String | Header text of the notification |
| `body` | String | Notification details |
| `isRead` | Boolean | True if read by user |
| `createdAt` | Timestamp | Timestamp sent |

---

### 6. `mentorship_sessions`
- **Path**: `/mentorship_sessions/{sessionId}`
- **Description**: Connects students with professional mentors for preparation.

| Field | Type | Description |
|---|---|---|
| `id` | String | Mentorship session UUID |
| `studentId` | String | Student user reference (`users.id`) |
| `mentorId` | String | Mentor user reference (`users.id`) |
| `status` | String | Status: `pending` \| `scheduled` \| `completed` \| `cancelled` |
| `scheduledAt` | Timestamp | Date and time of session |
| `topic` | String | Discussion focus (e.g., "Mock Interview", "CV Review") |
| `notes` | String | Session notes or agenda details |
| `meetingLink` | String | Video call URL (e.g., Zoom or Google Meet) |
| `createdAt` | Timestamp | Booking creation timestamp |
| `updatedAt` | Timestamp | Timestamp of last session modification |

---

### 7. `community_posts`
- **Path**: `/community_posts/{postId}`
- **Description**: Discussion posts in the community page.

| Field | Type | Description |
|---|---|---|
| `id` | String | Post UUID |
| `authorId` | String | Reference to `users.id` |
| `authorName` | String | Denormalized name of post author |
| `authorProfilePicture` | String | Denormalized avatar URL |
| `content` | String | Post text content |
| `likesCount` | Integer | Number of likes received |
| `commentsCount` | Integer | Number of comments received |
| `createdAt` | Timestamp | Publication timestamp |
| `updatedAt` | Timestamp | Last edit timestamp |

---

### 8. `comments`
- **Path**: `/community_posts/{postId}/comments/{commentId}` (Sub-collection)
- **Description**: Sub-collection containing post comments.

| Field | Type | Description |
|---|---|---|
| `id` | String | Comment UUID |
| `authorId` | String | Reference to `users.id` |
| `authorName` | String | Denormalized author display name |
| `content` | String | Comment text |
| `createdAt` | Timestamp | Publication timestamp |
