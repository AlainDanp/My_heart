import {Component, HostListener, inject, OnInit} from '@angular/core';
import {LoginService} from "../login/login.service";
import {Programmemodele} from "./programme-ajouter/programme-ajouter.model";
import {Observable} from "rxjs";

@Component({
  selector: 'app-programme',
  templateUrl: './programme.component.html',
  styleUrl: './programme.component.scss'
})
export class ProgrammeComponent implements OnInit{
  totalProgramem$: Observable<number> = new Observable<number>();
  innerWidth: any;
  username: string = '';
  programmes :Programmemodele[] =[];

  constructor(private loginService: LoginService) {
  }

  async ngOnInit(): Promise<void> {
    this.totalProgramem$ = this.loginService.getTotalProgramme();
    this.innerWidth = window.innerWidth;
    this.loginService.getProgramme().subscribe(programmes => {
      this.programmes = programmes;
      this.programmes.forEach(programme => {
        console.log(`Image URL: ${programme.image}`);
      });
    });
  }

  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.innerWidth = window.innerWidth;
  }

  getClass() {
    return this.innerWidth < 925 ? 'row-md' : 'row';
  }

}

