import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {LayoutComponent} from "./layout/layout.component";
import {LoginComponent} from "./login/login.component";
import {DashboardComponent} from "./dashboard/dashboard.component";
import {AuthGuard} from "../AuthGuard";




const routes: Routes = [
  {path: '',redirectTo: 'login',pathMatch: 'full'},
  {path: 'login', component:LoginComponent},
  {
    path: '',
    component: LayoutComponent,
    children: [
      { path: 'dashboard', component: DashboardComponent, canActivate: [AuthGuard]  },
      { path: 'programme',loadChildren: () => import('./programme/programme.module').then(m => m.ProgrammeModule)},
      { path: 'dons',loadChildren:() => import('./dons/dons.module').then(m => m.DonsModule) },
      { path: 'conseil',loadChildren:() => import('./conseils/conseils-routing.module').then(m => m.ConseilsRoutingModule)},
      { path: 'settings',loadChildren:() => import('./settings/settings-routing.module').then(m => m.SettingsRoutingModule)},
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
