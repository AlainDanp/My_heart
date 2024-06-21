import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AngularFireModule } from '@angular/fire/compat';
import { AngularFireAuthModule } from '@angular/fire/compat/auth';
import { AngularFirestoreModule } from '@angular/fire/compat/firestore';

import { environment } from '../environments/environment';
import { LoginComponent } from './login/login.component';
import {OverlayModule} from "@angular/cdk/overlay";
import {CdkMenuModule} from "@angular/cdk/menu";
import { LayoutComponent } from './layout/layout.component';
import {SidenavComponent} from "./sidenav/sidenav.component";
import {BodyComponent} from "./body/body.component";
import {PagesComponent} from "./pages/pages.component";
import {HeaderComponent} from "./header/header.component";
import {SublevelMenuComponent} from "./sidenav/sublevel-menu.component";
import {DonsComponent} from "./dons/dons.component";
import {DashboardComponent} from "./dashboard/dashboard.component";
import {ReactiveFormsModule} from "@angular/forms";
import {BrowserAnimationsModule} from "@angular/platform-browser/animations";

@NgModule({
  declarations: [
    LoginComponent,
    LayoutComponent,
    AppComponent,
    SidenavComponent,
    DonsComponent,
    BodyComponent,
    PagesComponent,
    HeaderComponent,
    DashboardComponent,
    SublevelMenuComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFireAuthModule,
    AngularFirestoreModule,
    OverlayModule,
    CdkMenuModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
