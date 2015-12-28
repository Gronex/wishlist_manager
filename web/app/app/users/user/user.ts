import {Component} from 'angular2/core';
import {RouteParams} from 'angular2/router';
import {BackendService} from '../../services/backend';
import {Table, TableData, TableRow, TableHeader} from '../../directives/table/table';

@Component({
  directives: [Table],
  templateUrl: "build/users/user/user.html"
})
export class UserComponent {
  private user = {};

  private headers = [
    new TableHeader("name", "Name"),
    new TableHeader("description", "Description"),
    new TableHeader("link", "Link")
  ];

  private wishlist: {}[] = [];

  constructor(private params: RouteParams, private backend: BackendService){
  }

  ngOnInit() {
    this.backend.get('users', this.params.get('id'))
      .then(resp => {
        this.user = resp.data;

        resp.data.items.forEach(item => {
          var rowData = new Map<string, TableData>();
          rowData.set('name', new TableData(item.name));
          rowData.set('description', new TableData(item.description));
          rowData.set('link', new TableData(item.link, item.link));
          this.wishlist.push(new TableRow(rowData));
        });
      });
  }

  formatDate(date: string): string {
    if (!date) return "";
    var newDate = new Date(date);
    return newDate.toLocaleDateString()
  }
}
