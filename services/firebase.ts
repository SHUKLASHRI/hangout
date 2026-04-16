import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getDatabase } from 'firebase/database';

// These should be moved to .env in production
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "hangout-mvp.firebaseapp.com",
  databaseURL: "https://hangout-mvp-default-rtdb.firebaseio.com",
  projectId: "hangout-mvp",
  storageBucket: "hangout-mvp.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const rtdb = getDatabase(app);

export default app;
