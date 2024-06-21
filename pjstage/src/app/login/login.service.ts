import { Injectable, inject } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import {AngularFirestore, AngularFirestoreCollection, QuerySnapshot} from '@angular/fire/compat/firestore';
import { User } from './user.model';
import { Router } from '@angular/router';
import {first, switchMap,map} from 'rxjs/operators';
import {Observable, of} from "rxjs";

interface UserData {
  username: string;
}
@Injectable({
  providedIn: 'root',
})

export class LoginService {
  auth = inject(AngularFireAuth);
  firestore = inject(AngularFirestore);
  router = inject(Router);
  dataRef: AngularFirestoreCollection<User>;

  constructor() {
    this.dataRef = this.firestore.collection<User>('Admins');
  }

   async signIn(user: User) {
     const userCredential = await this.auth.signInWithEmailAndPassword(<string>user.email, <string>user.password);
     if (userCredential.user) {
       const token = await userCredential.user.getIdToken();
       localStorage.setItem('token', token); // Stocker le token dans le localStorage
       localStorage.setItem('user', JSON.stringify(userCredential.user));
       return userCredential;
     }
     throw new Error('Sign in failed');
  }

  async signUp(user: User) {
    const userCredential = await this.auth.createUserWithEmailAndPassword(<string>user.email, <string>user.password);
    if (userCredential.user) {
      await this.updateUser(user.username); // Mettre à jour le profil utilisateur
      await this.dataRef.doc(userCredential.user.uid).set(user); // Ajouter l'utilisateur à Firestore
      const token = await userCredential.user.getIdToken();
      localStorage.setItem('token', token); // Stocker le token dans le localStorage
      localStorage.setItem('user', JSON.stringify(userCredential.user));
      return userCredential;
    }
    throw new Error('Sign up failed');
  }

  updateUser(displayName: string) {
    const currentUser = this.auth.currentUser;
    if (currentUser) {
      return currentUser.then(user => {
        if (user) {
          return user.updateProfile({ displayName });
        } else {
          throw new Error('No user logged in');
        }
      });
    } else {
      throw new Error('No user logged in');
    }
  }
  async addUserToFirestore(userData: { uid: string, username: string, email: string, password: string}) {
    return this.firestore.collection('Admins').doc(userData.uid).set({
      username: userData.username,
      email: userData.email,
      password: userData.password,
    });
  }
  sendRecoveryEmail(email: string) {
    return this.auth.sendPasswordResetEmail(email);
  }

  async signOut() {
    try {
      await this.auth.signOut();
      localStorage.removeItem('user'); // Remove user info
      localStorage.removeItem('token'); // Remove token
      await this.router.navigate(['/login'])
    } catch (error) {
      console.error('Error during sign out:', error);
      throw error;
    }
  }

  routerlink(url: string) {
    this.router.navigateByUrl(url);
  }
  getCurrentUser() {
    return this.auth.authState.pipe(first()).pipe();
  }
  getUserName(uid: string): Observable<string> {
    return this.firestore.collection('Admins').doc<UserData>(uid).get().pipe(
      switchMap(doc => {
        if (doc.exists) {
          const userData = doc.data();
          if (userData && userData.username) {
            return of(userData.username); // Retourner le nom d'utilisateur ou une chaîne vide si non défini
          } else {
            throw new Error('User data is undefined');
          }
        } else {
          throw new Error('User document not found');
        }
      })
    );
  }
  isLoggedIn(): boolean {
    return !!localStorage.getItem('token'); // Vérifie si le token est présent dans le localStorage
  }
  getTotalAdmins(): Observable<number> {
    return this.firestore.collection('Admins').get().pipe(
      map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }
  getTotalPatients(): Observable<number>{
    return  this.firestore.collection('Patient').get().pipe(
      map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }
}
