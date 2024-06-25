import {Injectable, inject, Query} from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import { AngularFirestore, AngularFirestoreCollection, QuerySnapshot } from '@angular/fire/compat/firestore';
import { User } from './user.model';
import { Router } from '@angular/router';
import {first, switchMap, map, finalize, catchError, concatWith, concatMap} from 'rxjs/operators';
import { combineLatest, Observable, of } from "rxjs";
import { Programmemodele } from "../programme/programme-ajouter/programme-ajouter.model";
import { AngularFireStorage } from "@angular/fire/compat/storage";
import {snapshotEqual} from "@angular/fire/firestore";
import {ConseilsModel} from "../conseils/conseils-ajouter/conseils-ajouter.model";


interface UserData {
  username: string;
  email: string;
}

export interface Patient {
  id: string;
  Nom: string;
  Email: string;
  Numero: number;
  Genre: string;
  Statut: string;
}

@Injectable({
  providedIn: 'root',
})

export class LoginService {
  auth = inject(AngularFireAuth);
  firestore = inject(AngularFirestore);
  router = inject(Router);
  dataRef: AngularFirestoreCollection<User>;
  programmeCollection = this.firestore.collection<Programmemodele>('Programme');
  conseilCollection = this.firestore.collection<ConseilsModel>('Conseil');
  constructor(private storage: AngularFireStorage) {
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

  async addUserToFirestore(userData: { uid: string, username: string, email: string, password: string }) {
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
  getCurrenEmail(){
    return this.auth.authState.pipe(first()).pipe();
  }


  getCurrentUser() {
    return this.auth.authState.pipe(first()).pipe();
  }
  getEmail(uid: string):Observable<string>{
    return this.firestore.collection('Admins').doc<UserData>(uid).get().pipe(
      switchMap(doc => {
        if (doc.exists){
          const  userData = doc.data();
          if (userData && userData.email) {
            return of (userData.email);
          }else {
            throw  new Error('Email data')
          }
        } else {
          throw new Error('User document not found');
        }
      })
    )
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

  // service pour d'ADMINISTRATEUR
  getTotalAdmins(): Observable<number> {
    return this.firestore.collection('Admins').get().pipe(
      map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }
  getTotalProgramme(): Observable<number>{
    return  this.firestore.collection('Programme').get().pipe(
      map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }
  getTotalConseil(): Observable<number>{
    return this.firestore.collection('Conseil').get().pipe(
    map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }

  //service pour le nombre de clients total
  getTotalPatients(): Observable<number> {
    return this.firestore.collection('Patient').get().pipe(
      map((snapshot: QuerySnapshot<any>) => snapshot.size)
    );
  }

  // service pour le nombre d'utilisateurs total
  getTotalUsers(): Observable<number> {
    return combineLatest([this.getTotalAdmins(), this.getTotalPatients()]).pipe(
      map(([totalAdmins, totalPatients]) => totalAdmins + totalPatients)
    );
  }

  getPatients(): Observable<Patient[]> {
    return this.firestore.collection<Patient>('Patient').snapshotChanges().pipe(
      map(actions => {
        return actions.map(a => {
          const data = a.payload.doc.data() as Patient;
          const id = a.payload.doc.id;
          return { ...data, id };
        });
      })
    );
  }

  getProgramme(): Observable<Programmemodele[]> {
    return this.programmeCollection.valueChanges({ idField: 'id' });
  }

  addProgramme(programme: Programmemodele): Promise<void> {
    const id = this.firestore.createId();
    return this.programmeCollection.doc(id).set(programme); // Assurez-vous que `programme` contient titre, image, duree, etc.
  }
  getConseil(): Observable<ConseilsModel[]>{
    return this.conseilCollection.valueChanges({idField: 'id'});
  }
  addConseil(conseil: ConseilsModel): Promise<void>{
    const id = this.firestore.createId();
    return  this.conseilCollection.doc(id).set(conseil);
  }
  uploadImage(file: File): Promise<string> {
    const id = Math.random().toString(36).substring(2);
    const ref = this.storage.ref(id);
    const task = ref.put(file);
    return new Promise((resolve, reject) => {
      task.snapshotChanges().pipe(
        finalize(() => {
          ref.getDownloadURL().subscribe({
            next: (url) => {
              resolve(url);
            },
            error: (error) => {
              reject(error);
            }
          });
        })
      ).subscribe();
    });
  }
  uploadImageCons(file: File): Promise<string>{
    const id = Math.random().toString(36).substring(2);
    const ref = this.storage.ref(id);
    const task = ref.put(file);
    return new Promise((resolve, reject) => {
      task.snapshotChanges().pipe(
        finalize(() => {
          ref.getDownloadURL().subscribe({
            next: (url) =>{
              resolve(url);
            },
            error: (error) => {
              reject(error)
            }
          });
        })
      ).subscribe()
    });
  }


}
