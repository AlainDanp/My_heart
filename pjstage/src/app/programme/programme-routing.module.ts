import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {ProgrammeComponent} from "./programme.component";
import {ProgrammeAjouterComponent} from "./programme-ajouter/programme-ajouter.component";

const routes: Routes = [
  {
    path: 'List',
    component: ProgrammeComponent
  },
  {
    path: 'ajouter',
    component: ProgrammeAjouterComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProgrammeRoutingModule { }
