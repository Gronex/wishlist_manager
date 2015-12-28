import {Component} from 'angular2/core';
import {Table, TableData, TableHeader, TableRow} from '../directives/table/table';
import { BackendService } from '../services/backend';
import {Router} from 'angular2/router';

@Component({
  templateUrl: "build/users/users.html",
  directives: [Table]
})
export class UsersComponent{
  constructor(private backend: BackendService, private router: Router){}

  private headers = [
    new TableHeader("firstName", "First Name"),
    new TableHeader("lastName", "Last Name"),
    new TableHeader("birthday", "Birthday")
  ];

  private users: {}[] = [];

  ngOnInit() {
    this.backend
      .get("users")
      .then(users => {
        users.data.forEach(user => {
          var rowData = new Map<string, TableData>();
          rowData.set("firstName", new TableData(user.firstName));
          rowData.set("lastName", new TableData(user.lastName));
          rowData.set("birthday", new TableData(new Date(user.birthday)));
          var row = new TableRow(rowData, () => this.router.navigate(["Wishlist", {id: user.id}]));
          this.users.push(row);
        });
      });
  }
}
