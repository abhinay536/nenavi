# Firebase Security Rules & Configuration


### Rules Code

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is a patient
    function isPatient(userId) {
      return exists(/databases/$(database)/documents/users/$(userId))
        && get(/databases/$(database)/documents/users/$(userId)).data.role == 'patient';
    }
    
    // Helper function to check if user is a caregiver
    function isCaregiver(userId) {
      return exists(/databases/$(database)/documents/users/$(userId))
        && get(/databases/$(database)/documents/users/$(userId)).data.role == 'caregiver';
    }
    
    // Helper function to check if caregiver has this patient linked
    function hasPatient(caregiverId, patientId) {
      return exists(/databases/$(database)/documents/users/$(caregiverId)/patients/$(patientId));
    }
    
    // User documents - users can only read/write their own
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      // Caregiver's patients subcollection
      match /patients/{patientId} {
        allow read: if request.auth.uid == userId;
        allow write: if request.auth.uid == userId;
      }
    }
    
    // Scores collection
    match /scores/{document=**} {
      // Allow patient to read/write their own scores
      allow read, write: if request.auth.uid == resource.data.patientUid;
      
      // Allow caregiver to read their patient's scores
      allow read: if isCaregiver(request.auth.uid) 
        && hasPatient(request.auth.uid, resource.data.patientUid);
    }
  }
}
```

## Firestore Collection Structure

Your collections should look like this:

```
firestore/
├── users/
│   ├── {patientUid}/
│   │   ├── email: "patient@email.com"
│   │   ├── role: "patient"
│   │   ├── caregiverEmail: "caregiver@email.com"
│   │   └── createdAt: timestamp
│   │
│   └── {caregiverUid}/
│       ├── email: "caregiver@email.com"
│       ├── role: "caregiver"
│       ├── createdAt: timestamp
│       └── patients/ (subcollection)
│           └── {patientUid}/
│               ├── patientEmail: "patient@email.com"
│               ├── patientUid: "{patientUid}"
│               └── linkedAt: timestamp
│
└── scores/
    └── {documentId}/
        ├── patientUid: "{patientUid}"
        ├── date: "2024-01-15"
        ├── compositeScore: 85
        ├── domainScores: { ... }
        ├── difficulty: "Basic"
        └── timestamp: server_timestamp
```

## Steps to Enable in Firebase Console

1. **Create Firestore Database**
   - Project → Firestore Database → Create Database
   - Start in **production mode** (rules will protect it)
   - Choose region (recommended: closest to you)

2. **Enable Firebase Authentication**
   - Authentication → Sign-in method
   - Enable "Email/Password"

3. **Deploy Security Rules**
   - Copy the rules above
   - Firestore → Rules → Paste & Publish

4. **Create Indexes (if needed)**
   - If you get index creation errors, follow the link in the error
   - Firebase will auto-suggest required indexes

## Testing the Setup

### Patient Registration Flow
1. Register as Caregiver first (no email dependency)
2. Register as Patient with Caregiver's email
3. Patient should appear in Caregiver's dashboard

### Data Isolation
- Patient A cannot see Patient B's scores (enforced by rules)
- Caregiver can see all their linked patients' scores
- Each patient has their own history

### Troubleshooting

**"Missing or insufficient permissions"**
- Check rules are published correctly
- Verify user's role in users collection
- Check that patientUid matches in scores

**Patient not appearing in caregiver's list**
- Verify patient registered with correct caregiver email
- Check that entry exists in `users/{caregiverUid}/patients/{patientUid}`
- Verify Firebase timestamp is valid

**Scores not syncing**
- Check that scores are saved with correct patientUid
- Verify Firestore collection matches structure above
- Check browser console for errors
