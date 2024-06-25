import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConseillsAjouterComponent } from './conseills-ajouter.component';

describe('ConseillsAjouterComponent', () => {
  let component: ConseillsAjouterComponent;
  let fixture: ComponentFixture<ConseillsAjouterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ConseillsAjouterComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ConseillsAjouterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
