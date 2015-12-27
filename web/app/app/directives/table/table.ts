import {Component, Input} from 'angular2/core';
import {NgClass} from 'angular2/common';
import {Router} from 'angular2/router';

export class TableHeader {
  private identifier: string;
  private text: string;

  constructor(identifier: string, text: string) {
    this.identifier = identifier;
    this.text = text;
  }
}

export class TableRow {
  private data: Map<string, TableData>;
  private link: string;
  //TODO: do things with links

  constructor(data: Map<string, TableData>, link?: string){
    this.link = link;
    this.data = data;
  }

  click() {
    console.log("hello")
  }

  get(key: string): TableData {
    return this.data.get(key);
  }
}


export class TableData {
  private data: any;
  private link: string;

  constructor(data: any, link?: string){
    this.link = link;
    this.data = data;
  }

  format(): string {
    if (this.data instanceof Date){
      return this.data.toLocaleDateString([], {year: "numeric", month: "2-digit", day: "2-digit"});
    }
    else {
      return this.data;
    }
  }
}

@Component({
  templateUrl: "build/directives/table/table.html",
  selector: "custom-table",
  directives: [NgClass]
})
export class Table{
  private hasHttpRegEx = new RegExp("^http(s)?://");
  private hasWwwRegEx = new RegExp("(^http(s)?://www)|(^www)");

  @Input() data: Array<TableRow>;
  @Input() headers: Array<TableHeader>;
  @Input() link: boolean;

  constructor(private router: Router){}

  formatLink(link: string){
    if (!this.hasWwwRegEx.test(link)){
      link = "www." + link;
    }

    if (!this.hasHttpRegEx.test(link)){
      link = "http://" + link;
    }
    return link;
  }

  click(row) {
    if (this.link){
      this.router.navigate(["Wishlist", {id: row.link}]);
    }
  }
}
