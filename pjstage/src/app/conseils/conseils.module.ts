import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ConseilsRoutingModule } from './conseils-routing.module';
import { ConseilsAjouterComponent } from './conseils-ajouter/conseils-ajouter.component';
import {ConseilsComponent} from "./conseils.component";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";


@NgModule({
  declarations: [
    ConseilsComponent,
    ConseilsAjouterComponent
  ],
    imports: [
        CommonModule,
        ConseilsRoutingModule,
        FormsModule,
        ReactiveFormsModule
    ]
})
export class ConseilsModule { }
