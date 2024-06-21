import { Component, HostListener, OnInit } from '@angular/core';
import { LoginService } from "../login/login.service";
import {switchMap} from "rxjs/operators";
import {Observable} from "rxjs";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  totalAdmins$: Observable<number> = new Observable<number>();
  totalPatien$: Observable<number> = new Observable<number>();

  innerWidth: any;
  username: string = '';

  constructor(private loginService: LoginService) { }

  async ngOnInit(): Promise<void> {
    this.innerWidth = window.innerWidth;
    this.totalAdmins$ = this.loginService.getTotalAdmins();
    this.totalPatien$ = this.loginService.getTotalPatients();
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
  }

  @HostListener('window:resize', ['$event'])
  onResize(event: any) {
    this.innerWidth = window.innerWidth;
  }

  getClass() {
    return this.innerWidth < 925 ? 'row-md' : 'row';
  }
}
