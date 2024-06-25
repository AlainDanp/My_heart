import {Component, HostListener, OnInit} from '@angular/core';
import {LoginService} from "../login/login.service";
import {ConseillsModel} from "./conseills-ajouter/conseills-ajouter.model";
import {Observable} from "rxjs";

@Component({
  selector: 'app-conseills',
  templateUrl: './conseills.component.html',
  styleUrl: './conseills.component.scss'
})
export class ConseillsComponent implements OnInit{
  totalConseil$: Observable<number> = new Observable<number>();
  innerWidth: any;
  username: string = '';
  conseils : ConseillsModel[] = []

  constructor(private loginService: LoginService) {
  }
  async ngOnInit() : Promise<void>{
    this.innerWidth = window.innerWidth;
    this.totalConseil$ = this.loginService.getTotalConseil();
    this.loginService.getConseil().subscribe(conseil => {
      this.conseils = conseil;
      this.conseils.forEach(conseil => {
        console.log(`Image URL: ${conseil.image}`)
      })
    })
  }
  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.innerWidth = window.innerWidth;
  }
  getClass() {
    return this.innerWidth < 925 ? 'row-md' : 'row';
  }

}
