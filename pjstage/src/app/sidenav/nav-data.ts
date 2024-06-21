import {INavbarData} from "./helper";

export  const navbarData:INavbarData[]= [
  {
    routeLink: 'dashboard',
    icon: 'fal fa-home',
    label: 'Dashboard',
  },
  {
    routeLink: 'programme',
    icon: 'fas fa-paper-plane',
    label: 'Programme',
    items:[
      {
        routeLink: 'programme/List',
        label: 'liste programme'
      },
      {
        routeLink: 'programme/ajouter',
        label: 'Créer vos programmes'
      }
    ]
  },
  {
    routeLink: 'dons',
    icon: 'fa fa-chart-bar',
    label: 'Dons',
    items:[
      {
        routeLink: 'dons/list',
        label: 'Liste des dons',
      }
    ]
  },
  {
    routeLink: 'conseil',
    icon: 'fal fa-box-open',
    label: 'Conseils',
    items:[
      {
        routeLink: 'conseil/List',
        label: 'liste des conseils',
      },
      {
        routeLink: 'conseil/ajouter',
        label: 'Créer un conseil'
      }
    ]
  },
  {
    routeLink: 'settings',
    icon: 'fas fa-cog',
    label: 'Options',
    items:[
      {
        routeLink: 'settings/profile',
        label: 'Profile',
      },
      {
        routeLink: 'settings/personnaliser',
        label: 'Personnaliser'
      }
    ]
  },
];
