import {Component, HostListener, OnInit} from '@angular/core';
import {LoginService} from "../login/login.service";
import {switchMap} from "rxjs";

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrl: './settings.component.scss'
})
export class SettingsComponent implements OnInit{
  innerWidth: any;
  username: string = '';
  email: string= '';

  constructor(private loginService: LoginService) {
  }

  async ngOnInit(): Promise<void> {
    this.innerWidth = window.innerWidth;
    this.loginService.getCurrentUser().pipe(
      switchMap(user => {
        if (user) {
          return this.loginService.getUserName(user.uid);
        } else {
          throw new Error('User not logged in');
        }
      })
    ).subscribe(
      username => {
        this.username = username;
      },
      error => {
        console.error('Error fetching user data:', error);
      }
    );
    this.loginService.getCurrenEmail().pipe(
      switchMap(email =>{
        if (email){
          return this.loginService.getEmail(email.uid);
        }else {
          throw new Error('User not logged in');
        }
      })
    ).subscribe(
      email => {
        this.email = email

      }
    )
  }
  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.innerWidth = window.innerWidth;
  }
  getClass() {
    return this.innerWidth < 925 ? 'row-md' : 'row';
  }
}
