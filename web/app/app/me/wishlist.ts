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
    this.clearEdit();
  }

  ngOnInit() {
    this.backend.get('users', 1)
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

  clearEdit(){
    this.editing = {
      "editing": false,
      "name": "",
      "description": "",
      "link": ""
    };
  }

  save(){
    if (this.editing["id"]){
      var tmp = this.editing;
      this.backend
        .put(this.editing, "items", this.editing["id"])
        .then(resp => {
          var rowData = this.wishlist.find((val) => val.get("id").format() == tmp["id"]);
          rowData.get("name").update(tmp["name"]);
          rowData.get("description").update(tmp["description"]);
          rowData.get("link").update(tmp["link"]);
        });
    }
    else{
      this.backend
        .post(this.editing, "items")
        .then(item => {
          var rowData = new Map<string, TableData>();
          rowData.set('id', new TableData(item.id));
          rowData.set('name', new TableData(item.name));
          rowData.set('description', new TableData(item.description));
          rowData.set('link', new TableData(item.link, item.link));
          this.wishlist.push(new TableRow(rowData, (row) => this.chooseItem(row, this.wishlist)));
        });
    }
    this.clearEdit();
  }
}
