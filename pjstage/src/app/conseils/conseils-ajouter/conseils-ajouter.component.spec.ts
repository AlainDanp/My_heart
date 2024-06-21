import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConseilsAjouterComponent } from './conseils-ajouter.component';

describe('ConseilsAjouterComponent', () => {
  let component: ConseilsAjouterComponent;
  let fixture: ComponentFixture<ConseilsAjouterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ConseilsAjouterComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ConseilsAjouterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
