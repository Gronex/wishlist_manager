import { Component } from 'angular2/core';
import {Table, TableData, TableHeader, TableRow} from '../directives/table/table';
import { BackendService } from '../services/backend';

@Component({
  templateUrl: "build/me/wishlist.html",
  directives: [Table]
})
export class WishlistComponent {
  private headers = [
    new TableHeader("name", "Name"),
    new TableHeader("description", "Description"),
    new TableHeader("link", "Link")
  ];

  private wishlist: TableRow[] = [];
  private userId: number;
  private editing: {};

  constructor(private backend: BackendService){
    this.wishlist = [];
    this.editing = {
      "editing": false,
      "name": "",
      "description": "",
      "link": ""
    };
  }

  ngOnInit() {
    this.backend.get(['users', 1])
      .then(resp => {
        this.userId = resp.id;

        resp.data.items.forEach(item => {
          var rowData = new Map<string, TableData>();
          rowData.set('id', new TableData(item.id));
          rowData.set('name', new TableData(item.name));
          rowData.set('description', new TableData(item.description));
          rowData.set('link', new TableData(item.link, item.link));
          this.wishlist.push(new TableRow(rowData, (row) => this.chooseItem(row, this.wishlist)));
        });
      });
  }

  chooseItem(item: TableRow, list: TableRow[]): void{
    this.editing = {
      "id": item.get("id").format(),
      "name": item.get("name").format(),
      "description": item.get("description").format(),
      "link": item.get("link").format()
    };
  }

  save(){
    if (this.editing["id"]){
      var saved = this.backend
        .put(["item", this.editing["id"]], this.editing)
        .then(resp => {
          var rowData = this.wishlist.find((val) => val.get("id") === this.editing["id"]);
          rowData.get("name").update(resp["name"]);
          rowData.get("description").update(resp["description"]);
          rowData.get("link").update(resp["link"]);
        });
    }
    else{
      var saved = this.backend
        .post(["item"], this.editing)
        .then(item => {
          var rowData = new Map<string, TableData>();
          rowData.set('id', new TableData(item.id));
          rowData.set('name', new TableData(item.name));
          rowData.set('description', new TableData(item.description));
          rowData.set('link', new TableData(item.link, item.link));
          this.wishlist.push(new TableRow(rowData, (row) => this.chooseItem(row, this.wishlist)));
        });
    }
    this.editing = {
      "editing": false,
      "name": "",
      "description": "",
      "link": ""
    };
  }
}
