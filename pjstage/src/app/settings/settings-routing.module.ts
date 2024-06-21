import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {SettingsComponent} from "./settings.component";
import {SettingsProfileComponent} from "./settings-profile/settings-profile.component";

const routes: Routes = [
  {
    path:'profile',
    component: SettingsComponent
  },
  {
    path:'personnaliser',
    component: SettingsProfileComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SettingsRoutingModule { }
