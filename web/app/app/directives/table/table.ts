import {Component, Input} from 'angular2/core';

export class TableHeader {
  private identifier: string;
  private text: string;

  constructor(identifier: string, text: string) {
    this.identifier = identifier;
    this.text = text;
  }
}

export class TableData {
  private data: any;
  private link: string;
  //TODO: do things with links

  constructor(data: any);
  constructor(data: any, link?: string){
    this.link = link;
    this.data = data;
  }

  format(): string{
    if (this.data instanceof Date){
      return this.data.toLocaleDateString([], {year: "numeric" ,month: "2-digit", day: "2-digit"});
    }
    else {
      return this.data;
    }
  }
}

@Component({
  templateUrl: "build/directives/table/table.html",
  selector: "custom-table"
})
export class Table{
  @Input() data: Array<Map<string, TableData>>;
  @Input() headers: Array<TableHeader>;

}
