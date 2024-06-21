import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ConseilsRoutingModule } from './conseils-routing.module';
import { ConseilsAjouterComponent } from './conseils-ajouter/conseils-ajouter.component';
import {ConseilsComponent} from "./conseils.component";


@NgModule({
  declarations: [
    ConseilsComponent,
    ConseilsAjouterComponent
  ],
  imports: [
    CommonModule,
    ConseilsRoutingModule
  ]
})
export class ConseilsModule { }
