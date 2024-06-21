import { NgModule } from '@angular/core';
import {CommonModule, NgOptimizedImage} from '@angular/common';

import { ProgrammeRoutingModule } from './programme-routing.module';
import {ProgrammeComponent} from "./programme.component";
import { ProgrammeAjouterComponent } from './programme-ajouter/programme-ajouter.component';


@NgModule({
  declarations: [
    ProgrammeComponent,
    ProgrammeAjouterComponent,
  ],
  imports: [
    CommonModule,
    ProgrammeRoutingModule,
    NgOptimizedImage,
  ]
})
export class ProgrammeModule { }
