import { Component } from '@angular/core';
import { LoginService } from '../../login/login.service';
import { Programmemodele } from './programme-ajouter.model';

@Component({
  selector: 'app-programme-ajouter',
  templateUrl: './programme-ajouter.component.html',
  styleUrls: ['./programme-ajouter.component.scss']
})
export class ProgrammeAjouterComponent {

  programme: Programmemodele = { titre: '', image: '', duree: 0 };
  selectedFile: File | null = null;
  programmes :Programmemodele[] =[];

  constructor(private loginService: LoginService) { }

   programmeuse() {
    if (this.selectedFile) {
        this.loginService.uploadImage(this.selectedFile).then(
          (url) => {
            console.log(url);
            this.programme.image = url;
            this.loginService.addProgramme(this.programme).then(() => {
              console.log('Programme added successfully');
            }).catch(error => {
              console.error('Error adding programme: ', error);
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
