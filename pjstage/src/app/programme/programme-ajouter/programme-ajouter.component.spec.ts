import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProgrammeAjouterComponent } from './programme-ajouter.component';

describe('ProgrammeAjouterComponent', () => {
  let component: ProgrammeAjouterComponent;
  let fixture: ComponentFixture<ProgrammeAjouterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProgrammeAjouterComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ProgrammeAjouterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
