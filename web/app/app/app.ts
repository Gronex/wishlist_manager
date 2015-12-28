import {Component} from 'angular2/core';
import {ROUTER_DIRECTIVES, RouteConfig} from 'angular2/router';

import {Home} from './home';
import {Info} from './info';
import {UsersComponent} from './users/users';
import {UserComponent} from './users/user/user';
import {WishlistComponent} from './me/wishlist';
import {User} from './model/user';

@Component({
  selector: 'my-app',
  templateUrl: 'build/app.html',
  directives: [ROUTER_DIRECTIVES]
})
@RouteConfig([
  { path: '/', component: Home, name: "Home" },
  { path: 'info', component: Info, name: "Info"},
  { path: 'users', component: UsersComponent, name: "Users"},
  { path: 'users/:id', component: UserComponent, name: "Wishlist"},
  { path: 'wishlist', component: WishlistComponent, name: "MyWishlist"}
])
export class App{
  private user: User = new User();

  constructor(){
    this.user.id = 1;
    this.user.firstName = "Mads";
    this.user.lastName = "Slotsbo";
    this.user.email = "mads.slotsbo@gmail.com"
    this.user.birthday = new Date("1993-29-01");
  }
}
