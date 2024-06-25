import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ConseillsRoutingModule } from './conseills-routing.module';
import {ConseillsComponent} from "./conseills.component";
import {ConseillsAjouterComponent} from "./conseills-ajouter/conseills-ajouter.component";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    ConseillsComponent,
    ConseillsAjouterComponent

  ],
  imports: [
    CommonModule,
    ConseillsRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ]
})
export class ConseillsModule { }
