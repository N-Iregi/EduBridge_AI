# Entity Relationship Diagram (ERD)

This document provides a logical representation of the database schema for the **EduBridge AI** platform. Although Firestore is a NoSQL document database, establishing clear relational structures helps ensure data consistency, clear access paths, and proper security rule boundary checks.

## Logical ERD Diagram

```mermaid
erDiagram
    USERS {
        string id PK "Matches Firebase Auth UID"
        string email
        string fullName
        string role "student | mentor | admin"
        string bio
        string profilePictureUrl
        timestamp createdAt
        timestamp updatedAt
    }

    SCHOLARSHIPS {
        string id PK "Auto-generated UUID"
        string title
        string description
        string amount
        timestamp deadline
        string eligibilityCriteria
        string provider
        string applicationUrl
        string category "undergraduate | postgraduate | STEM"
        timestamp createdAt
        timestamp updatedAt
    }

    APPLICATIONS {
        string id PK "Auto-generated UUID"
        string userId FK "users.id"
        string scholarshipId FK "scholarships.id"
        string scholarshipTitle "Denormalized"
        string status "applied | in_progress | accepted | rejected"
        timestamp appliedAt
        list documents "List of file URLs"
        string notes
        timestamp createdAt
        timestamp updatedAt
    }

    BOOKMARKS {
        string id PK "userId_scholarshipId"
        string userId FK "users.id"
        string scholarshipId FK "scholarships.id"
        timestamp bookmarkedAt
    }

    NOTIFICATIONS {
        string id PK "Auto-generated UUID"
        string userId FK "users.id"
        string title
        string body
        bool isRead
        timestamp createdAt
    }

    MENTORSHIP_SESSIONS {
        string id PK "Auto-generated UUID"
        string studentId FK "users.id (role=student)"
        string mentorId FK "users.id (role=mentor)"
        string status "pending | scheduled | completed | cancelled"
        timestamp scheduledAt
        string topic
        string notes
        string meetingLink
        timestamp createdAt
        timestamp updatedAt
    }

    COMMUNITY_POSTS {
        string id PK "Auto-generated UUID"
        string authorId FK "users.id"
        string authorName "Denormalized"
        string authorProfilePicture "Denormalized"
        string content
        int likesCount
        int commentsCount
        timestamp createdAt
        timestamp updatedAt
    }

    COMMENTS {
        string id PK "Auto-generated UUID"
        string authorId FK "users.id"
        string authorName "Denormalized"
        string content
        timestamp createdAt
    }

    USERS ||--o{ APPLICATIONS : "submits"
    SCHOLARSHIPS ||--o{ APPLICATIONS : "has"
    USERS ||--o{ BOOKMARKS : "bookmarks"
    SCHOLARSHIPS ||--o{ BOOKMARKS : "is_bookmarked_by"
    USERS ||--o{ NOTIFICATIONS : "receives"
    USERS ||--o{ MENTORSHIP_SESSIONS : "requests (student)"
    USERS ||--o{ MENTORSHIP_SESSIONS : "conducts (mentor)"
    USERS ||--o{ COMMUNITY_POSTS : "publishes"
    COMMUNITY_POSTS ||--o{ COMMENTS : "contains (sub-collection)"
    USERS ||--o{ COMMENTS : "writes"
```

## Description of Relationships

1. **Users to Applications (1:N)**: A user can submit multiple scholarship applications. Each application belongs to exactly one user.
2. **Scholarships to Applications (1:N)**: A scholarship can have multiple student applications. Each application maps to one specific scholarship.
3. **Users to Bookmarks (1:N)**: A user can bookmark multiple scholarships. To prevent duplicates, the document ID is formulated as `${userId}_${scholarshipId}`.
4. **Users to Notifications (1:N)**: A user can receive multiple push or system notifications. Each notification is linked to a single user.
5. **Users to Mentorship Sessions (1:N / 1:M)**: A session links two users: one student and one mentor. Thus, there are two distinct relationships pointing from `USERS` to `MENTORSHIP_SESSIONS` (one as the student requestor, one as the mentor host).
6. **Users to Community Posts (1:N)**: A user can author multiple forum posts.
7. **Community Posts to Comments (1:N)**: Each post can have multiple comments. Comments are organized as a sub-collection nested directly under `community_posts/{postId}/comments` to localize reading and deletion patterns.
