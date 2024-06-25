import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ConseillsAjouterComponent} from "./conseills-ajouter/conseills-ajouter.component";
import {ConseillsComponent} from "./conseills.component";

const routes: Routes = [
  {
    path: 'List',
    component: ConseillsComponent
  },
  {
    path: 'ajouter',
    component: ConseillsAjouterComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConseillsRoutingModule { }
