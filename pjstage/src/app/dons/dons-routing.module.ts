import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {DonsComponent} from "./dons.component";

const routes: Routes = [
  {
    path: 'list',
    component: DonsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DonsRoutingModule { }
