import { Component } from '@angular/core';
import {LoginService} from "../../login/login.service";
import {ConseilsModel} from "./conseils-ajouter.model";


@Component({
  selector: 'app-conseils-ajouter',
  templateUrl: './conseils-ajouter.component.html',
  styleUrl: './conseils-ajouter.component.scss'
})
export class ConseilsAjouterComponent {
  conseil: ConseilsModel = { Titre: '', image: '', Description: ''};
  selectedFile: File | null = null;
  conseils: ConseilsModel[] = []

  constructor(private loginService: LoginService) { }

  conseilleuse() {
    if (this.selectedFile) {
      this.loginService.uploadImageCons(this.selectedFile).then(
        (url) => {
          console.log(url);
          this.conseil.image = url;
          this.loginService.addConseil(this.conseil).then(() => {
            console.log('Conseil added successfully');
          }).catch(error => {
            console.error('Error adding conseil: ', error);
          });
        }
      ).catch(
        (e) => {
          console.error('Error uploading image: ', e);
        }
      );

    } else {
      console.error('No file selected');
    }
  }
  onFileSelected(event: any) {
    this.selectedFile = event.target.files[0];
    console.log('File selected:', this.selectedFile);
  }

}
