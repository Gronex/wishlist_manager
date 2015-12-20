import {Component} from 'angular2/core';
import {ROUTER_DIRECTIVES, RouteConfig} from 'angular2/router';

import {Home} from './home';
import {Info} from './info';

@Component({
  selector: 'my-app',
  templateUrl: 'app/app.html',
  directives: [ROUTER_DIRECTIVES]
})
@RouteConfig([
  { path: '/', component: Home, name: "Home" },
  { path: '/info', component: Info, name: "Info"}
])
export class App{ }
