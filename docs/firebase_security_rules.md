# Firebase Security Rules Design

This document details the security model implemented via Firebase Security Rules for **EduBridge AI**. The rules enforce least-privilege access, ensuring that user profile and application data is isolated, while allowing appropriate access to public scholarship lists and community resources.

## Key Rules & Enforcement Goals

1. **User Profiling Isolation (`users`)**:
   - Anyone can register an account (create) and view other profiles (to see mentors or students in the community).
   - Only the matching authenticated owner (UID matches the document ID) is permitted to update or write to their own profile.

2. **Public Scholarships (`scholarships`)**:
   - The scholarship collection is read-only for all authenticated users (students and mentors).
   - Direct database writes (creates, updates, deletes) are blocked for non-admin accounts.

3. **Secure Applications (`applications`)**:
   - Authenticated students can create applications.
   - Users can only read, update, or delete applications that they personally submitted (`request.auth.uid == resource.data.userId`).
   - Mentors and admins may be granted broader read privileges if necessary, but standard rules block access from other students.

4. **Protected Bookmarks (`bookmarks`)**:
   - A user can only view, create, or delete their own bookmark list.
   - The bookmark document ID is structured as `${userId}_${scholarshipId}`, and rules verify that `userId` matches `request.auth.uid`.

5. **Notification Inbox (`notifications`)**:
   - Users can only read and manage (update `isRead` or delete) notifications delivered to their own `userId`.

6. **Mentorship Scheduling (`mentorship_sessions`)**:
   - A session can only be read or written if the active authenticated user is either the student requestor or the mentor host (`request.auth.uid == resource.data.studentId || request.auth.uid == resource.data.mentorId`).

7. **Community Posts & Comments (`community_posts` & `comments`)**:
   - All authenticated users can read posts and comments.
   - Only the original post or comment author can edit or delete their respective content (`request.auth.uid == resource.data.authorId`).

---

## Firestore Rules Schema (`firestore.rules`)

The security rules are defined as follows:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper: Checks if the user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper: Checks if the user is writing their own document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users Collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isOwner(userId);
      allow delete: if false; // Profiles cannot be deleted via app client
    }

    // Scholarships Collection (Read-only for all users)
    match /scholarships/{scholarshipId} {
      allow read: if isAuthenticated();
      allow write: if false; // Writes must happen through admin console/backend
    }

    // Applications Collection
    match /applications/{applicationId} {
      allow read, update, delete: if isAuthenticated() && 
        (resource.data.userId == request.auth.uid);
      allow create: if isAuthenticated() && 
        (request.resource.data.userId == request.auth.uid);
    }

    // Bookmarks Collection
    match /bookmarks/{bookmarkId} {
      allow read, delete: if isAuthenticated() && 
        (resource.data.userId == request.auth.uid);
      allow create: if isAuthenticated() && 
        (request.resource.data.userId == request.auth.uid);
    }

    // Notifications Collection
    match /notifications/{notificationId} {
      allow read, update, delete: if isAuthenticated() && 
        (resource.data.userId == request.auth.uid);
      allow create: if isAuthenticated(); // Allows system-triggered creation
    }

    // Mentorship Sessions Collection
    match /mentorship_sessions/{sessionId} {
      allow read, update, delete: if isAuthenticated() && 
        (resource.data.studentId == request.auth.uid || resource.data.mentorId == request.auth.uid);
      allow create: if isAuthenticated() && 
        (request.resource.data.studentId == request.auth.uid);
    }

    // Community Posts Collection
    match /community_posts/{postId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && 
        (request.resource.data.authorId == request.auth.uid);
      allow update, delete: if isAuthenticated() && 
        (resource.data.authorId == request.auth.uid);

      // Comments Sub-collection
      match /comments/{commentId} {
        allow read: if isAuthenticated();
        allow create: if isAuthenticated() && 
          (request.resource.data.authorId == request.auth.uid);
        allow update, delete: if isAuthenticated() && 
          (resource.data.authorId == request.auth.uid);
      }
    }
  }
}
```
