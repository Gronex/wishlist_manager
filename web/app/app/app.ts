import {Component} from 'angular2/core';
import {ROUTER_DIRECTIVES, RouteConfig} from 'angular2/router';

import {Home} from './home';
import {Info} from './info';
import {UsersComponent} from './users/users';
import {UserComponent} from './users/user/user';

@Component({
  selector: 'my-app',
  templateUrl: 'build/app.html',
  directives: [ROUTER_DIRECTIVES]
})
@RouteConfig([
  { path: '/', component: Home, name: "Home" },
  { path: 'info', component: Info, name: "Info"},
  { path: 'users', component: UsersComponent, name: "Users"},
  { path: 'users/:id', component: UserComponent, name: "Wishlist"}
])
export class App{ }
