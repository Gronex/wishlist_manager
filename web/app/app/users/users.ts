import {Component} from 'angular2/core';
import {Table, TableData, TableHeader} from '../directives/table/table';

@Component({
  templateUrl: "build/users/users.html",
  directives: [Table]
})
export class Users{
  private headers = [
    new TableHeader("firstName", "First Name"),
    new TableHeader("lastName", "Last Name"),
    new TableHeader("birthday", "Birthday"),
  ];

  private data = [
    { "firstName": new TableData("Mads"), "lastName": new TableData("Slotsbo"), "birthday": new TableData(new Date("1993-01-29"))},
    { "firstName": new TableData("Anders"), "lastName": new TableData("Slotsbo"), "birthday": new TableData(new Date("1996-05-24"))}
  ]
}
