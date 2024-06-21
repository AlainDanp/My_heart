import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ConseilsComponent} from "./conseils.component";
import {ConseilsAjouterComponent} from "./conseils-ajouter/conseils-ajouter.component";

const routes: Routes = [
  {
    path: 'List',
    component: ConseilsComponent
  },
  {
    path: 'ajouter',
    component: ConseilsAjouterComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConseilsRoutingModule { }
