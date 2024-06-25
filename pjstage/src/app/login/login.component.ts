import {Component, ElementRef, inject, OnInit, Renderer2} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {User} from "./user.model";
import {Router} from "@angular/router";
import {LoginService} from "./login.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnInit{
  authService = inject(LoginService);
  signInForm: FormGroup;
  signUpForm: FormGroup;
  constructor(

    private renderer: Renderer2,
    private el: ElementRef,
    private router: Router) {
    this.signInForm = new FormGroup({
      email: new FormControl('', [Validators.required, Validators.email]),
      password: new FormControl('', [Validators.required, Validators.minLength(6)]),
    });

    this.signUpForm = new FormGroup({
      username: new FormControl('', [Validators.required, Validators.minLength(3)]),
      email: new FormControl('', [Validators.required, Validators.email]),
      password: new FormControl('', [Validators.required, Validators.minLength(6)]),
    });
  }

  ngOnInit() {
    const sign_in_btn = this.el.nativeElement.querySelector("#sign-in-btn");
    const sign_up_btn = this.el.nativeElement.querySelector("#sign-up-btn");
    const container = this.el.nativeElement.querySelector(".container");

    if (sign_up_btn && sign_in_btn && container) {
      sign_up_btn.addEventListener("click", () => {
        this.renderer.addClass(container, "sign-up-mode");
      });

      sign_in_btn.addEventListener("click", () => {
        this.renderer.removeClass(container, "sign-up-mode");
      });
    }
  }

  async onSignIn() {
    if (this.signInForm.invalid) {
      return;
    }
    try {
      const result = await this.authService.signIn(this.signInForm.value as User);
      console.log('User signed in:', result.user);
      this.router.navigate(['/dashboard']);
    } catch (error) {
      console.error('Sign in error:', error);
    }
  }

  async onSignUp() {
    if (this.signUpForm.invalid) {
      return;
    }
    try {
      const result = await this.authService.signUp(this.signUpForm.value as User);
      if (result && result.user) {
        console.log('User signed up:', result.user);
        await this.authService.updateUser(this.signUpForm.value.username);
        await this.authService.updateUser(this.signUpForm.value.email);
        await this.authService.addUserToFirestore({
          uid: result.user.uid,
          username: this.signUpForm.value.username,
          email: this.signUpForm.value.email,
          password: this.signUpForm.value.password,
        });
        this.router.navigate(['/dashboard']);
      } else {
        console.error('Sign up error: User not returned');
      }
    } catch (error) {
      console.error('Sign up error:', error);
    }
  }

  switchToSignUp() {
    const container = document.querySelector('.container');
    if (container) {
      container.classList.add('sign-up-mode');
    }
  }

  switchToSignIn() {
    const container = document.querySelector('.container');
    if (container) {
      container.classList.remove('sign-up-mode');
    }
  }
}
