import { NgModule } from '@angular/core';
import {CommonModule, NgOptimizedImage} from '@angular/common';

import { SettingsRoutingModule } from './settings-routing.module';
import {SettingsComponent} from "./settings.component";
import { SettingsProfileComponent } from './settings-profile/settings-profile.component';


@NgModule({
  declarations: [
    SettingsComponent,
    SettingsProfileComponent
  ],
  imports: [
    CommonModule,
    SettingsRoutingModule,
    NgOptimizedImage
  ]
})
export class SettingsModule { }
