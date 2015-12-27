import {Component} from 'angular2/core';
import {Table, TableData, TableHeader} from '../directives/table/table';
import { BackendService } from '../services/backend';

@Component({
  templateUrl: "build/users/users.html",
  directives: [Table]
})
export class Users{
  constructor(private backend: BackendService){
  }

  private headers = [
    new TableHeader("firstName", "First Name"),
    new TableHeader("lastName", "Last Name"),
    new TableHeader("birthday", "Birthday"),
  ];

  private users: {}[] = [];

  ngOnInit() {
    this.backend
      .get("users")
      .then(users => {
        users.forEach(user => {
          this.users.push({
            "firstName": new TableData(user.firstName),
            "lastName": new TableData(user.lastName),
            "birthday": new TableData(new Date(user.birthday))
          });
        });
      }, console.log);
  }
}
