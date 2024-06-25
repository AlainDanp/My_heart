import {Component, HostListener, OnInit} from '@angular/core';
import {LoginService} from "../login/login.service";

@Component({
  selector: 'app-conseils',
  templateUrl: './conseils.component.html',
  styleUrl: './conseils.component.scss'
})
export class ConseilsComponent implements OnInit{
  innerWidth: any;
  username: string = '';

  constructor(private loginService: LoginService) {
  }

  async ngOnInit(): Promise<void> {
    this.innerWidth = window.innerWidth;
  }

  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.innerWidth = window.innerWidth;
  }

  getClass() {
    return this.innerWidth < 925 ? 'row-md' : 'row';
  }
}
